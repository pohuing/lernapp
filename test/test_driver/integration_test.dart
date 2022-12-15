// ignore: depend_on_referenced_packages
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
      responseDataCallback: (data) async {
        if (data != null) {
          final timeline = driver.Timeline.fromJson(data['drawing_timeline']);
          final summary = driver.TimelineSummary.summarize(timeline);

          await summary.writeTimelineToFile(
            'drawing_timeline',
            pretty: true,
            includeSummary: true,
          );
        }
      },
    );
