import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/listing_screen/category_tile.dart';
import 'package:lernapp/widgets/listing_screen/task_tile.dart';
import 'package:lernapp/widgets/task_screen/task_screen.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

main() {
  final bindings = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Test drawing perf in TaskScreen', (widgetTester) async {
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
            HiveRepositoryConfiguration('testbox2'),
          ],
          hiveRepositoryConfiguration,
        ),
        ThemePreferences(false, false),
      ),
    );
    final defaultRepository =
    await hiveRepositoryConfiguration.createRepository();

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
    await widgetTester
        .tap(find.widgetWithText(CategoryTile, 'Angewandte Informatik'));
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(
        find.widgetWithText(CategoryTile, 'Objektorientierte Programmierung'));
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.widgetWithText(
        TaskTile, 'Modellieren eines Kettensägengeschäfts'));
    await widgetTester.pumpAndSettle();
    expect(find.byType(TaskScreen), findsOneWidget);

    // Draw central star
    await bindings.traceTimeline(() async {
      for (var i = 0.0; i < 100; i++) {
        await widgetTester.timedDrag(
          find.byType(DrawingArea),
          Offset.fromDirection(i, 100),
          const Duration(milliseconds: 150),
        );
      }
      await widgetTester.pumpAndSettle();
    });

    // Change line size
    await widgetTester.tap(find.byType(Slider));
    await widgetTester.pumpAndSettle();

    // Add colored lines
    await widgetTester.tap(find.byTooltip('Add a new color'));
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find
        .byType(ColorPickerSlider)
        .last);
    await widgetTester.pumpAndSettle();
    await widgetTester.tap(find.text('Confirm'));
    await widgetTester.pumpAndSettle();

    for (var i = 0.0; i < 30; i++) {
      await widgetTester.timedDrag(
        find.byType(DrawingArea),
        Offset.fromDirection(i, 100),
        const Duration(milliseconds: 150),
      );
      await widgetTester.pumpAndSettle();
    }

    await widgetTester.tap(find.byIcon(Icons.pan_tool));
    await bindings.traceAction(reportKey: 'drawing_timeline', () async {
      await widgetTester.timedDrag(
        find.byType(DrawingArea),
        Offset.fromDirection(0, 100),
        const Duration(milliseconds: 500),
      );
      await widgetTester.pumpAndSettle();
    });
  });
}
