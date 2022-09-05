import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/listing_screen.dart';
import 'package:lernapp/widgets/task_screen.dart';
import 'package:uuid/uuid.dart';

class LernappRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/listing',
    routes: [
      GoRoute(
        name: 'listing',
        path: '/listing',
        builder: (context, state) => const ListingScreen(),
      ),
      GoRoute(
        name: 'task',
        path: '/task:tid',
        builder: (context, state) {
          return TaskScreen(uuid: UuidValue(state.params['tid']!));
        },
      )
    ],
  );
}
