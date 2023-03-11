import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lernapp/generated/l10n.dart';

class ImportTile extends StatelessWidget {
  const ImportTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.download),
      title: Text(S.of(context).importTile_title),
      onTap: () {
        context.push('/import');
      },
    );
  }
}
