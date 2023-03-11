import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/blocs/selection_cubit.dart';
import 'package:lernapp/logic/nullable_extensions.dart';
import 'package:lernapp/widgets/general_purpose/adaptive_alert_dialog.dart';

import '../../generated/l10n.dart';

class StartSessionDialog extends StatefulWidget {
  const StartSessionDialog({super.key});

  @override
  State<StartSessionDialog> createState() => _StartSessionDialogState();
}

class _StartSessionDialogState extends State<StartSessionDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionCubit, SelectionState>(
      builder: (context, state) => AdaptiveAlertDialog(
        title: S.of(context).startSessionDialog_title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile.adaptive(
              title: Text(S.of(context).startSessionDialog_countTitle),
              value: state.withLimit,
              onChanged: (value) {
                if (value) {
                  context.read<SelectionCubit>().setLimit(1);
                } else {
                  context.read<SelectionCubit>().setLimit(-1);
                }
              },
            ),
            if (state.withLimit)
              ListTile(
                title: Text(S.of(context).startSessionDialog_countInputTitle),
                trailing: SizedBox(
                  width: 80,
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      int.tryParse(value).map(
                        context.read<SelectionCubit>().setLimit,
                      );
                    },
                  ),
                ),
              ),
            SwitchListTile.adaptive(
              title: Text(S.of(context).startSessionDialog_randomizeTitle),
              value: state.isRandomized,
              onChanged: (_) => context
                  .read<SelectionCubit>()
                  .setShouldRandomize(!state.isRandomized),
            )
          ],
        ),
        onCancel: context.pop,
        cancelChild: Text(S.of(context).cancel),
        onConfirm: () => context.push(
          '/session',
          extra: context.read<SelectionCubit>().state.maybeShuffledUuids,
        ),
        confirmChild: Text(S.of(context).start),
      ),
    );
  }
}
