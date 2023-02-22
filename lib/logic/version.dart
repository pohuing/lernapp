import 'package:flutter/services.dart';
import 'package:lernapp/logic/logging.dart';

String get VERSION_NAME {
  return _versionName;
}

String _versionName = '';

/// Loads the version name from the bundle based on git branch and commit hash
Future<String> getVersionName() async {
  try {
    final head = await rootBundle.loadString('.git/HEAD');
    final commit =
        (await rootBundle.loadString('.git/ORIG_HEAD')).substring(0, 8);

    final branch = head.split('/').last.trim();

    return '$branch #$commit';
  } catch (e) {
    log('Failed to load version string: ${e.toString()}');
    return '';
  }
}

Future<void> initVersionName() async {
  _versionName = await getVersionName();
}
