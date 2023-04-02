import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lernapp/logic/import/file_reading.dart';
import 'package:lernapp/logic/logging.dart';

main() {
  group('Import tests utf8', () {
    late final Uint8List bytes;
    setUpAll(() {
      final file = File('./test/unit_tests/import_tests/sample_data_utf8.json');
      bytes = file.readAsBytesSync();
    });

    test('Test deserialization', () async {
      log('message');
      final result = await readByteArrayToTaskCategory(bytes);

      expect(result, hasLength(1));
      expect(result.first.title, '1大成功');

      expect(result.first.tasks, hasLength(2));
      expect(result.first.tasks.first.taskTitle, '1: task 1 オヒオ');
      expect(result.first.tasks.first.taskBody, 'desc: 1.1');
      expect(result.first.tasks.first.solutionTitle, 'solTit: 1.1');
      expect(result.first.tasks.first.solutionBody, 'solBod: 1.1');

      expect(result.first.subCategories, hasLength(1));
      expect(result.first.subCategories.first.title, '1: subcategory 1');
      expect(result.first.subCategories.first.subCategories, hasLength(1));
    });
  });
  group('Import tests utf16LE', () {
    late final Uint8List bytes;
    setUpAll(() {
      final file =
          File('./test/unit_tests/import_tests/sample_data_utf16_le.json');
      bytes = file.readAsBytesSync();
    });

    test('Test deserialization', () async {
      final result = await readByteArrayToTaskCategory(bytes);

      expect(result, hasLength(1));
      expect(result.first.title, '1大成功');

      expect(result.first.tasks, hasLength(2));
      expect(result.first.tasks.first.taskTitle, '1: task 1 オヒオ');
      expect(result.first.tasks.first.taskBody, 'desc: 1.1');
      expect(result.first.tasks.first.solutionBody, 'solBod: 1.1');
      expect(result.first.tasks.first.solutionTitle, 'solTit: 1.1');

      expect(result.first.subCategories, hasLength(1));
      expect(result.first.subCategories.first.title, '1: subcategory 1');
      expect(result.first.subCategories.first.subCategories, hasLength(1));
    });
  });
  group('Import tests utf16BE', () {
    late final Uint8List bytes;
    setUpAll(() {
      final file =
          File('./test/unit_tests/import_tests/sample_data_utf16_be.json');
      bytes = file.readAsBytesSync();
    });

    test('Test deserialization', () async {
      final result = await readByteArrayToTaskCategory(bytes);

      expect(result, hasLength(1));
      expect(result.first.title, '1大成功');

      expect(result.first.tasks, hasLength(2));
      expect(result.first.tasks.first.taskTitle, '1: task 1 オヒオ');
      expect(result.first.tasks.first.taskBody, 'desc: 1.1');
      expect(result.first.tasks.first.solutionBody, 'solBod: 1.1');
      expect(result.first.tasks.first.solutionTitle, 'solTit: 1.1');

      expect(result.first.subCategories, hasLength(1));
      expect(result.first.subCategories.first.title, '1: subcategory 1');
      expect(result.first.subCategories.first.subCategories, hasLength(1));
    });
  });
}
