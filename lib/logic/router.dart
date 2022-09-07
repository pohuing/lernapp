import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/listing_screen.dart';
import 'package:lernapp/widgets/scratchpad.dart';
import 'package:lernapp/widgets/task_screen.dart';
import 'package:uuid/uuid.dart';

class LernappRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/listing',
    redirect: (state) {},
    routes: [
      GoRoute(
        path: '/',
        redirect: (state) => '/listing',
      ),
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
      ),
      GoRoute(
        name: 'scratchpad',
        path: '/scratchpad',
        builder: (context, state) => Scratchpad(),
      ),
    ],
  );
}
