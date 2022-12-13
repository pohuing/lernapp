// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/logic/nullable_extensions.dart';

main() {
  test('.map should return null', () {
    const bool? maybeNull = null;

    final result = maybeNull.map((value) => !value);

    expect(maybeNull, isNull);
    expect(result, isNull);
  });

  test('.map should return transformed value', () {
    const bool? maybeNull = false;

    final result = maybeNull.map((value) => !value);

    expect(maybeNull, false);
    expect(result, true);
  });
}
