import 'package:flutter/material.dart';
import 'package:lernapp/logic/version.dart';

class CustomAboutListTile extends StatelessWidget {
  const CustomAboutListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: const Icon(Icons.info),
      applicationVersion: versionName,
      applicationIcon: const Image(
        isAntiAlias: false,
        width: 200,
        image: AssetImage('images/dorime.gif'),
      ),
    );
  }
}
