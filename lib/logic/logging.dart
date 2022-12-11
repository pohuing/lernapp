import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter/foundation.dart';

void log(String message, {String? name}) {
  // Don't log to preserve performance
  if (kProfileMode || kReleaseMode) return;
  if (!kIsWeb && Platform.environment.containsKey('FLUTTER_TEST')) {
    // ignore: avoid_print
    print('[$name]: $message');
  } else {
    dev.log(message, name: name ?? '');
  }
}
