import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/task_screen.dart';

import '../widgets/listing_screen.dart';

class LernappRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/listing',
    routes: [
      GoRoute(
        name: 'listing',
        path: '/listing',
        builder: (context, state) => ListingScreen(),
      ),
      GoRoute(
        name: 'task',
        path: '/task:tid',
        builder: (context, state) {
          return TaskScreen(state.params['tid']!);
        },
      )
    ],
  );
}
