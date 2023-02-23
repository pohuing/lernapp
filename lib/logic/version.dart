import 'package:flutter/services.dart';
import 'package:lernapp/logic/logging.dart';

String get VERSION_NAME {
  return _versionName;
}

String _versionName = '';

/// Loads the version name from the bundle based on git branch and commit hash
Future<String> getVersionName() async {
  try {
    final head =
        (await rootBundle.loadString('version')).replaceAll('\n', ' ').trim();

    return head;
  } catch (e) {
    log(
      'Failed to load version string: ${e.toString()}',
      name: 'getVersionName',
    );
    return '';
  }
}

Future<void> initVersionName() async {
  _versionName = await getVersionName();
}
