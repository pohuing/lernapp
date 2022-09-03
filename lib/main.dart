import 'package:flutter/material.dart';
import 'package:lernapp/widgets/drawing_area.dart';
import 'package:lernapp/widgets/flippable.dart';
import 'package:lernapp/widgets/hint_card.dart';
import 'package:lernapp/widgets/solution_card.dart';

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
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Expanded(child: TaskCard()),
                Expanded(
                  child: Flippable(
                    front: HintCard(),
                    back: SolutionCard(),
                  ),
                ),
              ],
            ),
          ),
          const Flexible(
            flex: 5,
            child: DrawingArea(),
          ),
        ],
      ),
    );
  }
}
