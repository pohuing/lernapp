import 'package:flutter/material.dart';
import 'package:lernapp/logic/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lernapp',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routeInformationParser: LernappRouter.router.routeInformationParser,
      routeInformationProvider: LernappRouter.router.routeInformationProvider,
      routerDelegate: LernappRouter.router.routerDelegate,
    );
  }
}
