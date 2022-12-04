import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/widgets/drawing_area/drawing_area.dart';
import 'package:lernapp/widgets/general_purpose/scratchpad.dart';
import 'package:provider/provider.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Draw example', (widgetTester) async {
    final prefs = PreferencesBloc(
      PreferencesStateBase(
        RepositorySettings([], null),
        ThemePreferences(false, false),
      ),
    );

    var drawingArea = MaterialApp(
      builder: (context, child) => MultiProvider(
        providers: [
          BlocProvider.value(value: prefs),
        ],
        child: Scaffold(
          body: Stack(
            children: [
              const Scratchpad(),
              PerformanceOverlay.allEnabled(),
            ],
          ),
        ),
      ),
    );
    await widgetTester.pumpWidget(drawingArea);
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
