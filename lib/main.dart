import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/logic/router.dart';
import 'package:lernapp/repositories/task_repository.dart';
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
  final repository = HiveTaskRepository(box: await Hive.openBox('tcbox'));

  runApp(
    MultiProvider(
      providers: [
        Provider<TaskRepositoryBase>.value(value: repository),
        BlocProvider<TasksBloc>(create: (context) => TasksBloc(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return BlocProvider(
      create: (BuildContext context) {
        return SelectionCubit();
      },
      child: MaterialApp.router(
        title: 'Lernapp',
        themeMode: ThemeMode.system,
        theme: brightTheme,
        darkTheme: darkTheme,
        routeInformationParser: LernappRouter.router.routeInformationParser,
        routeInformationProvider: LernappRouter.router.routeInformationProvider,
        routerDelegate: LernappRouter.router.routerDelegate,
      ),
    );
  }
}
