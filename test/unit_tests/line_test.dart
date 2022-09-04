import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/model/line.dart';

void main() {
  test('Test line pruning', () {
    final line = Line([
      const Offset(0, 0),
      const Offset(1, 0),
      const Offset(2, 0),
    ]);

    line.prune();

    expect(line.path.length, 2);
  });
}
