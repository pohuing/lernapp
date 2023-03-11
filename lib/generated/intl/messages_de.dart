// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "connectedTaskListing_emptyRepositoryHint":
            MessageLookupByLibrary.simpleMessage(
                "Anscheinend hast du noch keine Aufgaben. Tippe hier um welche zu importieren."),
        "listingScreenTrailing_scribbleTitle":
            MessageLookupByLibrary.simpleMessage("Kritzeln"),
        "listingScreenTrailing_sessionModeButtonTooltip":
            MessageLookupByLibrary.simpleMessage("Aufgaben auswählen"),
        "listingScreenTrailing_settingsTitle":
            MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "listingScreen_title": MessageLookupByLibrary.simpleMessage("Aufgaben"),
        "rootScreenNav_history":
            MessageLookupByLibrary.simpleMessage("Verlauf"),
        "rootScreenNav_tasks": MessageLookupByLibrary.simpleMessage("Aufgaben"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "startSessionDialog_countInputTitle":
            MessageLookupByLibrary.simpleMessage("Anzahl"),
        "startSessionDialog_countTitle":
            MessageLookupByLibrary.simpleMessage("Anzahl begrenzen"),
        "startSessionDialog_randomizeTitle":
            MessageLookupByLibrary.simpleMessage("Zufällige Reihenfolge"),
        "startSessionDialog_title":
            MessageLookupByLibrary.simpleMessage("Sitzung vorbereiten")
      };
}
