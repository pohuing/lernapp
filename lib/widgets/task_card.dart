import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Function()? onTap;
  final String title;

  const TaskCard({Key? key, this.onTap, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              const VerticalDivider(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.start,
                  ),
                  const Text("Bottom Text"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
