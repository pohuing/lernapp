// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(NUMBER) =>
      "${Intl.plural(NUMBER, one: 'one Year', other: '${NUMBER} Years')} ago";

  static String m1(NUMBER) =>
      "${Intl.plural(NUMBER, one: 'one Day', other: '${NUMBER} Days')} ago";

  static String m2(NUMBER) =>
      "${Intl.plural(NUMBER, one: 'one hour', other: '${NUMBER} hours')} ago";

  static String m3(NUMBER) =>
      "${Intl.plural(NUMBER, one: 'one minute', other: '${NUMBER} minutes')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "connectedTaskListing_emptyRepositoryHint":
            MessageLookupByLibrary.simpleMessage(
                "You don\'t appear to have any tasks yet. Tap here to import."),
        "createTaskScreen_solutionDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Solution"),
        "createTaskScreen_solutionTitleLabel":
            MessageLookupByLibrary.simpleMessage("Solution Title"),
        "createTaskScreen_taskDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Task"),
        "createTaskScreen_taskTitleLabel":
            MessageLookupByLibrary.simpleMessage("Task Title"),
        "drawingPreview_description": MessageLookupByLibrary.simpleMessage(
            "Currently an A with a correction circle would look like this"),
        "drawingPreview_title": MessageLookupByLibrary.simpleMessage("Preview"),
        "historyScreen_endTitle": MessageLookupByLibrary.simpleMessage("End:"),
        "historyScreen_noAnswersInTimeFrameHint":
            MessageLookupByLibrary.simpleMessage(
                "No questions have been answered in this time frame"),
        "historyScreen_startButtonTitle":
            MessageLookupByLibrary.simpleMessage("Start"),
        "historyScreen_startTitle":
            MessageLookupByLibrary.simpleMessage("Start:"),
        "historyScreen_timeFrameTitle":
            MessageLookupByLibrary.simpleMessage("Time Frame"),
        "historyScreen_title": MessageLookupByLibrary.simpleMessage("History"),
        "importScreen_importActionTitle":
            MessageLookupByLibrary.simpleMessage("Import loaded data"),
        "importScreen_importActionWarning":
            MessageLookupByLibrary.simpleMessage(
                "This will overwrite existing data"),
        "importScreen_importConfirmation":
            MessageLookupByLibrary.simpleMessage("Finished import"),
        "importScreen_importTileTitle":
            MessageLookupByLibrary.simpleMessage("Import"),
        "importScreen_previewTitle":
            MessageLookupByLibrary.simpleMessage("Result:"),
        "importScreen_title": MessageLookupByLibrary.simpleMessage("Import"),
        "importTile_title": MessageLookupByLibrary.simpleMessage("import"),
        "listingScreenTrailing_scribbleTitle":
            MessageLookupByLibrary.simpleMessage("Scribble"),
        "listingScreenTrailing_sessionModeButtonTooltip":
            MessageLookupByLibrary.simpleMessage("Select tasks"),
        "listingScreenTrailing_settingsTitle":
            MessageLookupByLibrary.simpleMessage("Settings"),
        "listingScreen_title": MessageLookupByLibrary.simpleMessage("Tasks"),
        "repositoryOptionsSelection_addConfigurationTitle":
            MessageLookupByLibrary.simpleMessage("Add configuration"),
        "repositoryOptionsSelection_exportDescription":
            MessageLookupByLibrary.simpleMessage(
                "Export current storage to file"),
        "repositoryOptionsSelection_exportTitle":
            MessageLookupByLibrary.simpleMessage("Export"),
        "repositoryOptionsSelection_resetConfirmationDialogTitle":
            MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "repositoryOptionsSelection_resetConfirmationDialogWarning":
            MessageLookupByLibrary.simpleMessage(
                "This will delete all tasks as well as answers!"),
        "repositoryOptionsSelection_resetStorageDescription":
            MessageLookupByLibrary.simpleMessage(
                "Delete all your loaded tasks as well as entered solutions"),
        "repositoryOptionsSelection_resetStorageTitle":
            MessageLookupByLibrary.simpleMessage("Reset storage"),
        "repositoryOptionsSelection_saveDescription":
            MessageLookupByLibrary.simpleMessage(
                "This should happen automatically in the background"),
        "repositoryOptionsSelection_saveTitle":
            MessageLookupByLibrary.simpleMessage("Save"),
        "repositoryOptionsSelection_sectionTitle":
            MessageLookupByLibrary.simpleMessage("Data source"),
        "rootScreenNav_history":
            MessageLookupByLibrary.simpleMessage("History"),
        "rootScreenNav_tasks": MessageLookupByLibrary.simpleMessage("Tasks"),
        "scratchpadScreen_title":
            MessageLookupByLibrary.simpleMessage("Scribble"),
        "sessionScreen_nextTitle": MessageLookupByLibrary.simpleMessage("Next"),
        "sessionScreen_previousTitle":
            MessageLookupByLibrary.simpleMessage("Previous"),
        "sessionScreen_titleReview":
            MessageLookupByLibrary.simpleMessage("Review"),
        "sessionScreen_titleSession":
            MessageLookupByLibrary.simpleMessage("Session"),
        "sessionScreen_unknownTaskIdHint": MessageLookupByLibrary.simpleMessage(
            "Something went wrong, could not find any data for that task id"),
        "settingsScreen_title":
            MessageLookupByLibrary.simpleMessage("Preferences"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "startSessionDialog_countInputTitle":
            MessageLookupByLibrary.simpleMessage("Count"),
        "startSessionDialog_countTitle":
            MessageLookupByLibrary.simpleMessage("Limit question count"),
        "startSessionDialog_randomizeTitle":
            MessageLookupByLibrary.simpleMessage("Randomize"),
        "startSessionDialog_title":
            MessageLookupByLibrary.simpleMessage("Configure Session"),
        "taskArea_correctionColorsDescription":
            MessageLookupByLibrary.simpleMessage(
                "Colors available after showing solution"),
        "taskArea_correctionColorsTitle":
            MessageLookupByLibrary.simpleMessage("Correction colors"),
        "taskArea_defaultLineWidthDescription":
            MessageLookupByLibrary.simpleMessage(
                "How wide new lines should be in pixels"),
        "taskArea_defaultLineWidthTitle":
            MessageLookupByLibrary.simpleMessage("Default line width"),
        "taskArea_differenceLessThanOneMinute":
            MessageLookupByLibrary.simpleMessage("Now"),
        "taskArea_differenceindays365YearsAgo": m0,
        "taskArea_differenceindaysDaysAgo": m1,
        "taskArea_differenceinhoursHoursAgo": m2,
        "taskArea_differenceinminutesMinutesAgo": m3,
        "taskArea_historyButtonTitle": MessageLookupByLibrary.simpleMessage(
            "Show history button before revealing solution"),
        "themeSettingsTile_PaintAATitle":
            MessageLookupByLibrary.simpleMessage("Enable Paint AA"),
        "themeSettingsTile_blendAADescription":
            MessageLookupByLibrary.simpleMessage(
                "Apply anti-aliasing when blending layers, minor performance impact"),
        "themeSettingsTile_blendAATitle":
            MessageLookupByLibrary.simpleMessage("Enable blend AA"),
        "themeSettingsTile_paintAADescription":
            MessageLookupByLibrary.simpleMessage(
                "Apply anti-aliasing when drawing lines, major performance impact"),
        "themeSettingsTile_visualSectionTitle":
            MessageLookupByLibrary.simpleMessage("Visual")
      };
}
