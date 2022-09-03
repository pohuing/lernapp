import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area.dart';
import 'package:lernapp/widgets/hint_card.dart';

import 'widgets/task_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lernapp')),
      body: GridView.count(
        primary: true,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        children: const [
          TaskCard(),
          HintCard(),
          DrawingArea(),
        ],
      ),
    );
  }
}
