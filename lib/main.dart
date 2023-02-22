import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/blocs/preferences/preferences_bloc.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/router.dart';
import 'package:lernapp/logic/ui_overlay_setter_observer.dart';
import 'package:lernapp/logic/version.dart';
import 'package:lernapp/repositories/preferences_repository.dart';
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.addObserver(UIOverlaySetterObserver());

  if (kIsWeb ||
      [TargetPlatform.android, TargetPlatform.windows]
          .contains(defaultTargetPlatform)) {
    await SystemTheme.accentColor.load();
  }
  await Hive.initFlutter();

  final preferencesRepository =
      await PreferencesRepository.openBox('preferences');
  final currentPreferences = preferencesRepository.loadPreferences();

  final preferencesBloc =
      PreferencesBloc(currentPreferences, preferencesRepository);

  final tasksRepositoryConfiguration =
      currentPreferences.repositorySettings.currentConfiguration!;
  final tasksRepository = await tasksRepositoryConfiguration.createRepository();
  await initVersionName();

  Widget builder([BuildContext? context]) => MultiProvider(
        providers: [
          BlocProvider.value(value: preferencesBloc),
          BlocProvider<TasksBloc>(
              create: (context) => TasksBloc(tasksRepository, preferencesBloc)),
          BlocProvider<SelectionCubit>(create: (context) => SelectionCubit()),
        ],
        child: const MyApp(),
      );

  runApp(builder());
}

class MyApp extends StatelessWidget {
  final bool? showPerformanceOverlay;

  const MyApp({super.key, this.showPerformanceOverlay});

  ThemeData get brightTheme {
    var data = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: SystemTheme.accentColor.accent,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: Typography().black,
    );

    data = data.copyWith(
      listTileTheme: data.listTileTheme.copyWith(tileColor: Colors.transparent),
      canvasColor: Colors.transparent,
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.white,
        barBackgroundColor: data.colorScheme.background.withAlpha(120),
        textTheme:
            CupertinoTextThemeData(primaryColor: data.colorScheme.primary),
      ),
    );

    return data;
  }

  ThemeData get darkTheme {
    var data = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: SystemTheme.accentColor.accent,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: Typography().white,
    );

    data = data.copyWith(
      listTileTheme: data.listTileTheme.copyWith(tileColor: Colors.transparent),
      canvasColor: Colors.transparent,
      cupertinoOverrideTheme: CupertinoThemeData(
        scaffoldBackgroundColor: Colors.black,
        barBackgroundColor: data.colorScheme.background.withAlpha(120),
        textTheme:
            CupertinoTextThemeData(primaryColor: data.colorScheme.primary),
      ),
    );

    return data;
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
