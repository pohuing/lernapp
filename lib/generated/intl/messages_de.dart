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

  static String m0(NUMBER) =>
      "vor ${Intl.plural(NUMBER, one: 'einem Jahr', other: '${NUMBER} Jahren')}";

  static String m1(NUMBER) =>
      "vor ${Intl.plural(NUMBER, one: 'einem Tag', other: '${NUMBER} Tagen')}";

  static String m2(NUMBER) =>
      "vor ${Intl.plural(NUMBER, one: 'einer Stunde', other: '${NUMBER} Stunden')}";

  static String m3(NUMBER) =>
      "vor ${Intl.plural(NUMBER, one: 'einer Minute', other: '${NUMBER} Minuten')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Abbrechen"),
        "colorPickerDialog_brightThemeColourTitle":
            MessageLookupByLibrary.simpleMessage("Farbe für helles Farbschema"),
        "colorPickerDialog_confirm":
            MessageLookupByLibrary.simpleMessage("Fertig"),
        "colorPickerDialog_darkThemeColourTitle":
            MessageLookupByLibrary.simpleMessage(
                "Farbe für dunkles Farbschema"),
        "colorPickerDialog_separateColorsTitle":
            MessageLookupByLibrary.simpleMessage("Benutze separate Farben"),
        "colorPickerDialog_title":
            MessageLookupByLibrary.simpleMessage("Farbe hinzufügen"),
        "connectedTaskListing_emptyRepositoryHint":
            MessageLookupByLibrary.simpleMessage(
                "Anscheinend hast du noch keine Aufgaben. Tippe hier um welche zu importieren."),
        "createTaskScreen_solutionDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Beschreibung"),
        "createTaskScreen_solutionTitleLabel":
            MessageLookupByLibrary.simpleMessage("Lösungstitel"),
        "createTaskScreen_taskDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Beschreibung"),
        "createTaskScreen_taskTitleLabel":
            MessageLookupByLibrary.simpleMessage("Aufgabentitel"),
        "drawingPreview_description": MessageLookupByLibrary.simpleMessage(
            "So würde ein \"A\" mit einem Kreis in der Korrekturfarbe aussehen"),
        "historyScreen_endTitle": MessageLookupByLibrary.simpleMessage("Ende:"),
        "historyScreen_noAnswersInTimeFrameHint":
            MessageLookupByLibrary.simpleMessage(
                "In diesem Zeitraum wurden keine Fragen beantwortet"),
        "historyScreen_startButtonTitle":
            MessageLookupByLibrary.simpleMessage("Start"),
        "historyScreen_startTitle":
            MessageLookupByLibrary.simpleMessage("Anfang:"),
        "historyScreen_timeFrameTitle":
            MessageLookupByLibrary.simpleMessage("Zeitraum"),
        "historyScreen_title": MessageLookupByLibrary.simpleMessage("Verlauf"),
        "importScreen_importActionTitle":
            MessageLookupByLibrary.simpleMessage("Geladene Daten importieren"),
        "importScreen_importActionWarning":
            MessageLookupByLibrary.simpleMessage(
                "Dies überschreibt bestehende Daten"),
        "importScreen_importConfirmation":
            MessageLookupByLibrary.simpleMessage("Importieren abgeschlossen"),
        "importScreen_importTileTitle":
            MessageLookupByLibrary.simpleMessage("Datei auswählen"),
        "importScreen_previewTitle":
            MessageLookupByLibrary.simpleMessage("Vorschau:"),
        "importScreen_title": MessageLookupByLibrary.simpleMessage("Import"),
        "importTile_title": MessageLookupByLibrary.simpleMessage("Importieren"),
        "listingScreenTrailing_scribbleTitle":
            MessageLookupByLibrary.simpleMessage("Kritzeln"),
        "listingScreenTrailing_sessionModeButtonTooltip":
            MessageLookupByLibrary.simpleMessage("Aufgaben auswählen"),
        "listingScreenTrailing_settingsTitle":
            MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "listingScreen_title": MessageLookupByLibrary.simpleMessage("Aufgaben"),
        "repositoryOptionsSelection_addConfigurationTitle":
            MessageLookupByLibrary.simpleMessage("Konfiguration hinzufügen"),
        "repositoryOptionsSelection_exportDescription":
            MessageLookupByLibrary.simpleMessage(
                "Exportiere die aktuell gespeicherten Daten in eine Datei"),
        "repositoryOptionsSelection_exportTitle":
            MessageLookupByLibrary.simpleMessage("Exportieren"),
        "repositoryOptionsSelection_resetConfirmationDialogTitle":
            MessageLookupByLibrary.simpleMessage("Bist du dir sicher?"),
        "repositoryOptionsSelection_resetConfirmationDialogWarning":
            MessageLookupByLibrary.simpleMessage(
                "Dies wird alle gespeicherten Aufgaben und Antworten löschen!"),
        "repositoryOptionsSelection_resetStorageDescription":
            MessageLookupByLibrary.simpleMessage(
                "Lösche alle gespeicherten Aufgaben und Antworten"),
        "repositoryOptionsSelection_resetStorageTitle":
            MessageLookupByLibrary.simpleMessage("Speicher zurücksetzen"),
        "repositoryOptionsSelection_saveDescription":
            MessageLookupByLibrary.simpleMessage(
                "Dies sollte automatisch im Hintergrund passieren"),
        "repositoryOptionsSelection_saveTitle":
            MessageLookupByLibrary.simpleMessage("Speichern"),
        "repositoryOptionsSelection_sectionTitle":
            MessageLookupByLibrary.simpleMessage("Datenquelle"),
        "rootScreenNav_history":
            MessageLookupByLibrary.simpleMessage("Verlauf"),
        "rootScreenNav_tasks": MessageLookupByLibrary.simpleMessage("Aufgaben"),
        "scratchpadScreen_title":
            MessageLookupByLibrary.simpleMessage("Kritzeln"),
        "sessionScreen_nextTitle":
            MessageLookupByLibrary.simpleMessage("Weiter"),
        "sessionScreen_previousTitle":
            MessageLookupByLibrary.simpleMessage("Zurück"),
        "sessionScreen_titleReview":
            MessageLookupByLibrary.simpleMessage("Bewerten"),
        "sessionScreen_titleSession":
            MessageLookupByLibrary.simpleMessage("Sitzung"),
        "sessionScreen_unknownTaskIdHint": MessageLookupByLibrary.simpleMessage(
            "Etwas ist schief gelaufen: diese Aufgabe gibt es nicht."),
        "settingsScreen_title":
            MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "startSessionDialog_countInputTitle":
            MessageLookupByLibrary.simpleMessage("Anzahl"),
        "startSessionDialog_countTitle":
            MessageLookupByLibrary.simpleMessage("Anzahl begrenzen"),
        "startSessionDialog_randomizeTitle":
            MessageLookupByLibrary.simpleMessage("Zufällige Reihenfolge"),
        "startSessionDialog_title":
            MessageLookupByLibrary.simpleMessage("Sitzung vorbereiten"),
        "taskArea_correctionColorsDescription":
            MessageLookupByLibrary.simpleMessage(
                "Farben welche beim Korrigieren verwendet werden"),
        "taskArea_correctionColorsTitle":
            MessageLookupByLibrary.simpleMessage("Korrekturfarben"),
        "taskArea_defaultLineWidthDescription":
            MessageLookupByLibrary.simpleMessage(
                "Wie breit Striche standardmäßig sind"),
        "taskArea_defaultLineWidthTitle":
            MessageLookupByLibrary.simpleMessage("Standardstrichstärke"),
        "taskArea_differenceLessThanOneMinute":
            MessageLookupByLibrary.simpleMessage("Now"),
        "taskArea_differenceindays365YearsAgo": m0,
        "taskArea_differenceindaysDaysAgo": m1,
        "taskArea_differenceinhoursHoursAgo": m2,
        "taskArea_differenceinminutesMinutesAgo": m3,
        "taskArea_historyButtonTitle": MessageLookupByLibrary.simpleMessage(
            "Zeige Verlaufsleiste selbst wenn Aufgabe noch nicht gelöst wurde"),
        "taskScreen_errorTitle": MessageLookupByLibrary.simpleMessage("Fehler"),
        "taskScreen_loadingTitle":
            MessageLookupByLibrary.simpleMessage("Laden"),
        "themeSettingsTile_PaintAATitle":
            MessageLookupByLibrary.simpleMessage("Verwende AA beim Zeichnen"),
        "themeSettingsTile_blendAADescription":
            MessageLookupByLibrary.simpleMessage(
                "Verwende Anti-Aliasing beim Überlagern von Ebenen, geringe Auswirkung auf die Leistung"),
        "themeSettingsTile_blendAATitle":
            MessageLookupByLibrary.simpleMessage("Verwende AA beim Überlagern"),
        "themeSettingsTile_paintAADescription":
            MessageLookupByLibrary.simpleMessage(
                "Verwende Anti-Aliasing beim Zeichnen der Striche, hohe Auswirkung auf die Leistung"),
        "themeSettingsTile_visualSectionTitle":
            MessageLookupByLibrary.simpleMessage("Optisch")
      };
}
