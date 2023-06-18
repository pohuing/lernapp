import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/widgets/listing_screen/task_tile.dart';

Finder findTaskTileWithTitle(String title) {
  return find.byWidgetPredicate((widget) {
    if (widget case TaskTile tile when tile.task.taskTitle == title) {
      return true;
    }
    return false;
  });
}

Future<void> tapAndSettle(
  WidgetTester widgetTester,
  Finder finder, {
  bool warnIfMissed = true,
}) async {
  await widgetTester.tap(finder, warnIfMissed: warnIfMissed);
  await widgetTester.pumpAndSettle();
}
