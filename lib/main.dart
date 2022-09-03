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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lernapp',
      theme: ThemeData(
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
      appBar: AppBar(
        title: const Text('Lernapp'),
        primary: true,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
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
            child: ClipRect(child: DrawingArea()),
          ),
        ],
      ),
    );
  }
}
