import 'package:flutter/material.dart';
import 'package:lernapp/generated/application_information/about_contents.dart';

class CustomAboutListTile extends StatelessWidget {
  const CustomAboutListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AboutListTile(
      icon: Icon(Icons.info),
      applicationVersion: versionName,
      applicationLegalese: applicationLegalese,
      applicationIcon: Image(
        isAntiAlias: false,
        width: 200,
        image: AssetImage('images/logo'),
      ),
    );
  }
}
