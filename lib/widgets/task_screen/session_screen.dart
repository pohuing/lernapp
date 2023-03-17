import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lernapp/blocs/session_cubit.dart';
import 'package:lernapp/blocs/tasks/tasks_bloc.dart';
import 'package:lernapp/generated/l10n.dart';
import 'package:lernapp/widgets/general_purpose/platform_adaptive_scaffold.dart';
import 'package:lernapp/widgets/task_screen/task_area.dart';
import 'package:uuid/uuid.dart';

class SessionScreen extends StatefulWidget {
  final List<UuidValue> tasks;
  final bool reviewStyle;

  const SessionScreen({super.key, required this.tasks, bool? reviewStyle})
      : reviewStyle = reviewStyle ?? false;

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late final SessionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return PlatformAdaptiveScaffold(
      title: widget.reviewStyle
          ? S.of(context).sessionScreen_titleReview
          : S.of(context).sessionScreen_titleSession,
      useSliverAppBar: false,
      previousTitle: S.of(context).listingScreen_title,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => cubit.previous(),
            child: Text(S.of(context).sessionScreen_previousTitle),
          ),
          BlocBuilder<SessionCubit, SessionState>(
            bloc: cubit,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  '${state.index + 1}/${state.tasks.length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => cubit.next(),
            child: Text(S.of(context).sessionScreen_nextTitle),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SessionCubit, SessionState>(
          bloc: cubit,
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: FutureBuilder(
                key: Key(state.currentTask.toString()),
                future: context
                    .read<TasksBloc>()
                    .repository
                    .findByUuid(state.currentTask!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: TaskArea(
                        key: Key(state.currentTask!.uuid.toString()),
                        showBackButton: false,
                        task: snapshot.data!,
                        reviewStyle: widget.reviewStyle,
                      ),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Text(
                        S.of(context).sessionScreen_unknownTaskIdHint,
                      ),
                    );
                  } else {
                    return const AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    cubit = SessionCubit(widget.tasks);
    cubit.next();
    super.initState();
  }
}
