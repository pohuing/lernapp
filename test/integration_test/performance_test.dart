import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/model/preferences/repository_configuration/hive_repository_configuration.dart';
import 'package:lernapp/model/preferences/repository_configuration/repository_settings.dart';
import 'package:lernapp/model/preferences/theme_preferences.dart';
import 'package:lernapp/repositories/preferences_repository.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/general_purpose/scratchpad.dart';
import 'package:provider/provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Draw example', (widgetTester) async {
    Hive.init('.');
    final prefsRepo =
        PreferencesRepository(await Hive.openBox('testing_performance_test'));
    final prefs = PreferencesBloc(
      PreferencesStateBase(
        RepositorySettings([HiveRepositoryConfiguration('perftest')], null),
        ThemePreferences.defaults(),
      ),
      prefsRepo,
    );

    var drawingArea = MaterialApp(
      localizationsDelegates: const [S.delegate],
      home: MultiProvider(
        providers: [
          BlocProvider.value(value: prefs),
        ],
        child: Scaffold(
          body: Builder(
            builder: (context) => Stack(
              children: [
                const Scratchpad(),
                PerformanceOverlay.allEnabled(),
              ],
            ),
          ),
        ),
      ),
    );
    await widgetTester.pumpWidget(drawingArea);
    await widgetTester.pumpAndSettle();

    await binding.traceAction(
      () async {
        for (var i = 0.0; i < 100; i++) {
          await widgetTester.timedDrag(
            find.byType(DrawingArea),
            Offset.fromDirection(i, 100),
            const Duration(milliseconds: 150),
          );
        }
        await widgetTester.pumpAndSettle();
      },
      reportKey: 'drawing_timeline',
    );
  });
}
