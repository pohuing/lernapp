import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImportTile extends StatelessWidget {
  const ImportTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.download),
      title: Text('import'),
      onTap: () {
        context.push('/import');
      },
    );
  }
}
