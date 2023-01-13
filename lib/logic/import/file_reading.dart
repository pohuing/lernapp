import 'dart:convert';
import 'dart:typed_data';

import 'package:lernapp/logic/list_extensions.dart';
import 'package:lernapp/model/task_category.dart';

enum Encoding { utf8, utf16BE, utf16LE }

Future<List<TaskCategory>> readByteArrayToTaskCategory(Uint8List bytes) async {
  final object = json.decode(await prepareString(bytes));
  if ((object is Iterable)) {
    return object
        .map((e) => TaskCategory.fromMap(e))
        .whereType<TaskCategory>()
        .toList();
  } else {
    throw const FormatException('JSON is missing top level task categories');
  }
}

Future<String> prepareString(Uint8List bytes) async {
  final codes = convertUtf16ToUtf8(bytes);
  final encoding = guessFileEncoding(bytes);
  var contents = uint16ToString(codes, encoding);
  return contents.trim();
}

String uint16ToString(Uint16List codes, Encoding encoding) {
  switch (encoding) {
    case Encoding.utf8:
      return utf8.decode(codes);
    case Encoding.utf16BE:
      return String.fromCharCodes(codes);
    case Encoding.utf16LE:
      return String.fromCharCodes(codes);
  }
}

Uint16List convertUtf16ToUtf8(Uint8List bytes) {
  switch (guessFileEncoding(bytes)) {
    case Encoding.utf8:
      return Uint16List.fromList(bytes);
    case Encoding.utf16BE:
      return Uint16List.fromList(
        bytes.pairwise().map((e) => e.one << 8 | e.two).toList(),
      );
    case Encoding.utf16LE:
      return Uint16List.fromList(
        bytes.pairwise().map((e) => e.two << 8 | e.one).toList(),
      );
  }
}

/// Guesses file encoding based on the file's BOM
Encoding guessFileEncoding(Uint8List bytes) {
  if (bytes.length >= 3 &&
      bytes[0] == 0xef &&
      bytes[1] == 0xbb &&
      bytes[2] == 0xbf) {
    return Encoding.utf8;
  }

  if (bytes.length >= 2 && (bytes[0] == 0xfe && bytes[1] == 0xff)) {
    return Encoding.utf16BE;
  }
  if (bytes.length >= 2 && bytes[0] == 0xff && bytes[1] == 0xfe) {
    return Encoding.utf16LE;
  }

  /// Return utf8 and pray it's not Windows 1252 or something else
  return Encoding.utf8;
}
