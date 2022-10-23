import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/main.dart';
import 'package:lernapp/model/task.dart';
import 'package:lernapp/widgets/general_purpose/scratchpad.dart';
import 'package:lernapp/widgets/listing_screen/listing_screen.dart';
import 'package:lernapp/widgets/task_screen/session_screen.dart';
import 'package:lernapp/widgets/task_screen/task_screen.dart';
import 'package:uuid/uuid.dart';

class LernappRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/listing',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) async => '/listing',
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
        builder: (context, state) => const Scratchpad(),
      ),
      GoRoute(
        name: 'session',
        path: '/session',
        builder: (context, state) => SessionScreen(
          tasks: context
              .read<SelectionCubit>()
              .state
              .selectedUuids
              .map((e) => taskRepository.findByUuid(e))
              .whereType<Task>()
              .toList(),
        ),
      ),
    ],
  );
}
