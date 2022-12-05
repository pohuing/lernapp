import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/router.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb ||
      [TargetPlatform.android, TargetPlatform.windows]
          .contains(defaultTargetPlatform)) {
    await SystemTheme.accentColor.load();
  }
  await Hive.initFlutter();

  var hiveRepositoryConfiguration = HiveRepositoryConfiguration('tcbox');
  final prefs = PreferencesBloc(
    PreferencesStateBase(
      RepositorySettings(
        [
          hiveRepositoryConfiguration,
          HiveRepositoryConfiguration('aaabox'),
        ],
        hiveRepositoryConfiguration,
      ),
      ThemePreferences(false, false),
    ),
  );
  final defaultRepository =
      await hiveRepositoryConfiguration.createRepository();

  runApp(
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
}

class MyApp extends StatelessWidget {
  final bool? showPerformanceOverlay;

  const MyApp({super.key, this.showPerformanceOverlay});

  ThemeData get brightTheme {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: SystemTheme.accentColor.accent,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: Typography().black,
    );
  }

  ThemeData get darkTheme {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: SystemTheme.accentColor.accent,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: Typography().white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lernapp',
      themeMode: ThemeMode.system,
      theme: brightTheme,
      darkTheme: darkTheme,
      showPerformanceOverlay: showPerformanceOverlay ?? false,
      routeInformationParser: LernappRouter.router.routeInformationParser,
      routeInformationProvider: LernappRouter.router.routeInformationProvider,
      routerDelegate: LernappRouter.router.routerDelegate,
    );
  }
}
