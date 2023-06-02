import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/model/preferences/repository_configuration/hive_repository_configuration.dart';
import 'package:lernapp/model/preferences/repository_configuration/repository_settings.dart';
import 'package:lernapp/model/preferences/theme_preferences.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/model/task_category.dart';
import 'package:lernapp/repositories/preferences_repository.dart';
import 'package:lernapp/widgets/listing_screen/task_listing.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

main() async {
  final bindings = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  bindings.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmarkLive;

  testWidgets('Test drawing perf in TaskScreen', (widgetTester) async {
    await Hive.initFlutter();
    var box = await Hive.openBox('testing_performance_test');
    await box.clear();
    final prefsRepo = PreferencesRepository(box);
    if (kIsWeb ||
        [TargetPlatform.android, TargetPlatform.windows]
            .contains(defaultTargetPlatform)) {
      await SystemTheme.accentColor.load();
    }
    await Hive.initFlutter();

    var hiveRepositoryConfiguration = HiveRepositoryConfiguration('testbox');
    final prefs = PreferencesBloc(
      PreferencesStateBase(
        RepositorySettings(
          [
            hiveRepositoryConfiguration,
          ],
          hiveRepositoryConfiguration,
        ),
        ThemePreferences.defaults(),
      ),
      prefsRepo,
    );

    final defaultRepository =
        await hiveRepositoryConfiguration.createRepository();
    defaultRepository.categories.clear();
    defaultRepository.categories.addAll(generateTasks(10000));
    await defaultRepository.save();
    await widgetTester.pumpWidget(
      MultiProvider(
        providers: [
          BlocProvider.value(value: prefs),
          BlocProvider<TasksBloc>(
            create: (context) => TasksBloc(defaultRepository, prefs),
          ),
          BlocProvider<SelectionCubit>(
            create: (context) => SelectionCubit(),
          ),
        ],
        child: const MyApp(showPerformanceOverlay: true),
      ),
    );

    await widgetTester.pumpAndSettle();
    expect(find.byType(TaskListing), findsOneWidget);
    await bindings.traceAction(reportKey: 'drawing_timeline', () async {
      for (int i = 0; i < 10; i++) {
        await widgetTester.fling(
          find.byType(TaskListing),
          const Offset(0, -400),
          400,
        );
        await widgetTester.pumpAndSettle();
      }
    });
  });
}

List<TaskCategory> generateTasks(int count) {
  final categories = <TaskCategory>[];
  int numItems() => categories.fold(
        0,
        (previousValue, element) =>
            previousValue += element.gatherUuids().length,
      );

  while (numItems() < count) {
    categories.add(
      TaskCategory(
        title: 'title',
        tasks: List.generate(
          3,
          (index) => Task(
            'Title',
            'TaskDescription',
            'Solution',
            'SolutionDescription',
          ),
        ),
        subCategories: [],
      ),
    );
  }

  return categories;
}
