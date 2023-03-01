import 'package:flutter/material.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/tab_destination.dart';
import 'package:lernapp/widgets/history_screen/history_screen.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      showAppBar: false,
      destinations: [
        TabDestination(
          builder: (context) => const ListingScreen(),
          title: 'Tasks',
          icon: const Icon(Icons.list),
        ),
        TabDestination(
          builder: (context) => const HistoryScreen(),
          title: 'History',
          icon: const Icon(Icons.history),
        ),
      ],
    );
  }
}
