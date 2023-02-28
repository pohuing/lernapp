import 'package:go_router/go_router.dart';
import 'package:lernapp/widgets/general_purpose/scratchpad.dart';
import 'package:lernapp/widgets/history_screen/history_screen.dart';
import 'package:lernapp/widgets/import_flow/import_screen.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';
import 'package:lernapp/widgets/root_screen.dart';
import 'package:lernapp/widgets/settings_screen/settings_screen.dart';
import 'package:lernapp/widgets/task_screen/session_screen.dart';
import 'package:lernapp/widgets/task_screen/task_screen.dart';
import 'package:uuid/uuid.dart';

class LernappRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => RootScreen(),
      ),
      GoRoute(
        name: 'listing',
        path: '/listing',
        builder: (context, state) => const ListingScreen(),
      ),
      GoRoute(
        name: 'task',
        path: '/task:tid',
        redirect: (context, state) =>
            Uuid.isValidUUID(fromString: state.params['tid'] ?? 'lol')
                ? null
                : '/404',
        builder: (context, state) {
          return TaskScreen(uuid: UuidValue(state.params['tid']!));
        },
      ),
      GoRoute(
        name: 'scratchpad',
        path: '/scratchpad',
        builder: (context, state) => const Scratchpad(),
      ),
      GoRoute(
        name: 'session',
        path: '/session',
        builder: (context, state) => SessionScreen(
          tasks: state.extra as List<UuidValue>,
        ),
      ),
      GoRoute(
        name: 'preference',
        path: '/preferences',
        builder: (context, state) => const PreferencesScreen(),
      ),
      GoRoute(
        path: '/import',
        name: 'import',
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        name: 'history',
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
}
