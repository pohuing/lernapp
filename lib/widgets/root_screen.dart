import 'package:flutter/material.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold/tab_destination.dart';
import 'package:lernapp/widgets/history_screen/history_screen.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';

import '../generated/l10n.dart';

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
          title: S.of(context).rootScreenNav_tasks,
          icon: const Icon(Icons.list),
        ),
        TabDestination(
          builder: (context) => const HistoryScreen(),
          title: S.of(context).rootScreenNav_history,
          icon: const Icon(Icons.history),
        ),
      ],
    );
  }
}
