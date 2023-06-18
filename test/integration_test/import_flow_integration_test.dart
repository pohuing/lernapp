import 'dart:io';

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
import 'package:lernapp/repositories/preferences_repository.dart';
import 'package:lernapp/widgets/import_flow/import_screen.dart';
import 'package:lernapp/widgets/import_flow/import_tile.dart';
import 'package:lernapp/widgets/listing_screen/category_tile.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'utils.dart';

const testingHiveNamePref = 'importFlowPrefHive';
const testingStorageName = 'importFlowStorageHive';

main() {
  final bindings = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late final String contents;

  tearDown(() async {
    await Future.wait([
      (await Hive.openBox(testingHiveNamePref)).deleteFromDisk(),
      (await Hive.openBox<List<dynamic>>(testingStorageName)).deleteFromDisk()
    ]);
  });

  setUp(() async {
    final file = File('./test/unit_tests/import_tests/sample_data_utf8.json');
    contents = await file.readAsString();
  });

  testWidgets('Import Flow', (widgetTester) async {
    Hive.init('.');

    if (kIsWeb ||
        [TargetPlatform.android, TargetPlatform.windows]
            .contains(defaultTargetPlatform)) {
      await SystemTheme.accentColor.load();
    }
    await Hive.initFlutter();

    final prefBox = await Hive.openBox(testingHiveNamePref);
    await prefBox.clear();

    final storageBox = await Hive.openBox(testingStorageName);
    await storageBox.clear();
    await storageBox.close();

    final prefsRepo = PreferencesRepository(prefBox);

    final hiveRepositoryConfiguration =
        HiveRepositoryConfiguration(testingStorageName);
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
    await defaultRepository.wipeStorage();

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
        child: const MyApp(),
      ),
    );
    await widgetTester.pumpAndSettle();

    await tapAndSettle(widgetTester, find.byType(PopupMenuButton));
    await tapAndSettle(widgetTester, find.byType(ImportTile));
    expect(find.byIcon(Icons.file_open), findsOneWidget);

    await widgetTester
        .state<ImportScreenState>(find.byType(ImportScreen))
        .parseContents(contents, 'We are checking');
    await widgetTester.pumpAndSettle();

    await tapAndSettle(widgetTester, find.byIcon(Icons.check));
    await tapAndSettle(widgetTester, find.byType(BackButton));
    expect(find.widgetWithText(CategoryTile, '1大成功'), findsOneWidget);

    //Twice because the first tap closes the popup menu

    await tapAndSettle(widgetTester, find.widgetWithText(CategoryTile, '1大成功'),
        warnIfMissed: false);
    await tapAndSettle(widgetTester, find.widgetWithText(CategoryTile, '1大成功'));
    expect(findTaskTileWithTitle('1: task 2'), findsOneWidget);
  });
}
