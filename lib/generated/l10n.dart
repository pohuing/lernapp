// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tasks`
  String get rootScreenNav_tasks {
    return Intl.message(
      'Tasks',
      name: 'rootScreenNav_tasks',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get rootScreenNav_history {
    return Intl.message(
      'History',
      name: 'rootScreenNav_history',
      desc: '',
      args: [],
    );
  }

  /// `Tasks`
  String get listingScreen_title {
    return Intl.message(
      'Tasks',
      name: 'listingScreen_title',
      desc: '',
      args: [],
    );
  }

  /// `Scribble`
  String get listingScreenTrailing_scribbleTitle {
    return Intl.message(
      'Scribble',
      name: 'listingScreenTrailing_scribbleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get listingScreenTrailing_settingsTitle {
    return Intl.message(
      'Settings',
      name: 'listingScreenTrailing_settingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Select tasks`
  String get listingScreenTrailing_sessionModeButtonTooltip {
    return Intl.message(
      'Select tasks',
      name: 'listingScreenTrailing_sessionModeButtonTooltip',
      desc: '',
      args: [],
    );
  }

  /// `You don't appear to have any tasks yet. Tap here to import.`
  String get connectedTaskListing_emptyRepositoryHint {
    return Intl.message(
      'You don\'t appear to have any tasks yet. Tap here to import.',
      name: 'connectedTaskListing_emptyRepositoryHint',
      desc: '',
      args: [],
    );
  }

  /// `Configure Session`
  String get startSessionDialog_title {
    return Intl.message(
      'Configure Session',
      name: 'startSessionDialog_title',
      desc: '',
      args: [],
    );
  }

  /// `Limit question count`
  String get startSessionDialog_countTitle {
    return Intl.message(
      'Limit question count',
      name: 'startSessionDialog_countTitle',
      desc: '',
      args: [],
    );
  }

  /// `Randomize`
  String get startSessionDialog_randomizeTitle {
    return Intl.message(
      'Randomize',
      name: 'startSessionDialog_randomizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Count`
  String get startSessionDialog_countInputTitle {
    return Intl.message(
      'Count',
      name: 'startSessionDialog_countInputTitle',
      desc: '',
      args: [],
    );
  }

  /// `Time Frame`
  String get historyScreen_timeFrameTitle {
    return Intl.message(
      'Time Frame',
      name: 'historyScreen_timeFrameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start:`
  String get historyScreen_startTitle {
    return Intl.message(
      'Start:',
      name: 'historyScreen_startTitle',
      desc: '',
      args: [],
    );
  }

  /// `End:`
  String get historyScreen_endTitle {
    return Intl.message(
      'End:',
      name: 'historyScreen_endTitle',
      desc: '',
      args: [],
    );
  }

  /// `No questions have been answered in this time frame`
  String get historyScreen_noAnswersInTimeFrameHint {
    return Intl.message(
      'No questions have been answered in this time frame',
      name: 'historyScreen_noAnswersInTimeFrameHint',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get historyScreen_startButtonTitle {
    return Intl.message(
      'Start',
      name: 'historyScreen_startButtonTitle',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get historyScreen_title {
    return Intl.message(
      'History',
      name: 'historyScreen_title',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get importScreen_title {
    return Intl.message(
      'Import',
      name: 'importScreen_title',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get importScreen_importTileTitle {
    return Intl.message(
      'Import',
      name: 'importScreen_importTileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Import loaded data`
  String get importScreen_importActionTitle {
    return Intl.message(
      'Import loaded data',
      name: 'importScreen_importActionTitle',
      desc: '',
      args: [],
    );
  }

  /// `This will overwrite existing data`
  String get importScreen_importActionWarning {
    return Intl.message(
      'This will overwrite existing data',
      name: 'importScreen_importActionWarning',
      desc: '',
      args: [],
    );
  }

  /// `Finished import`
  String get importScreen_importConfirmation {
    return Intl.message(
      'Finished import',
      name: 'importScreen_importConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Result:`
  String get importScreen_previewTitle {
    return Intl.message(
      'Result:',
      name: 'importScreen_previewTitle',
      desc: '',
      args: [],
    );
  }

  /// `import`
  String get importTile_title {
    return Intl.message(
      'import',
      name: 'importTile_title',
      desc: '',
      args: [],
    );
  }

  /// `Task Title`
  String get createTaskScreen_taskTitleLabel {
    return Intl.message(
      'Task Title',
      name: 'createTaskScreen_taskTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Task`
  String get createTaskScreen_taskDescriptionLabel {
    return Intl.message(
      'Task',
      name: 'createTaskScreen_taskDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Solution Title`
  String get createTaskScreen_solutionTitleLabel {
    return Intl.message(
      'Solution Title',
      name: 'createTaskScreen_solutionTitleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Solution`
  String get createTaskScreen_solutionDescriptionLabel {
    return Intl.message(
      'Solution',
      name: 'createTaskScreen_solutionDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get sessionScreen_titleReview {
    return Intl.message(
      'Review',
      name: 'sessionScreen_titleReview',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get sessionScreen_titleSession {
    return Intl.message(
      'Session',
      name: 'sessionScreen_titleSession',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get sessionScreen_previousTitle {
    return Intl.message(
      'Previous',
      name: 'sessionScreen_previousTitle',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get sessionScreen_nextTitle {
    return Intl.message(
      'Next',
      name: 'sessionScreen_nextTitle',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, could not find any data for that task id`
  String get sessionScreen_unknownTaskIdHint {
    return Intl.message(
      'Something went wrong, could not find any data for that task id',
      name: 'sessionScreen_unknownTaskIdHint',
      desc: '',
      args: [],
    );
  }

  /// `{NUMBER, plural, one {one minute} other {{NUMBER} minutes}}`
  String taskArea_differenceinminutesMinutesAgo(num NUMBER) {
    return Intl.plural(
      NUMBER,
      one: 'one minute',
      other: '$NUMBER minutes',
      name: 'taskArea_differenceinminutesMinutesAgo',
      desc: '',
      args: [NUMBER],
    );
  }

  /// `Now`
  String get taskArea_differenceLessThanOneMinute {
    return Intl.message(
      'Now',
      name: 'taskArea_differenceLessThanOneMinute',
      desc: '',
      args: [],
    );
  }

  /// `{NUMBER, plural, one {one hour} other {{NUMBER} hours}} ago`
  String taskArea_differenceinhoursHoursAgo(num NUMBER) {
    return Intl.message(
      '${Intl.plural(NUMBER, one: 'one hour', other: '$NUMBER hours')} ago',
      name: 'taskArea_differenceinhoursHoursAgo',
      desc: '',
      args: [NUMBER],
    );
  }

  /// `{NUMBER, plural, one {one Day} other {{NUMBER} Days}} ago`
  String taskArea_differenceindaysDaysAgo(num NUMBER) {
    return Intl.message(
      '${Intl.plural(NUMBER, one: 'one Day', other: '$NUMBER Days')} ago',
      name: 'taskArea_differenceindaysDaysAgo',
      desc: '',
      args: [NUMBER],
    );
  }

  /// `{NUMBER, plural, one {one Year} other {{NUMBER} Years}} ago`
  String differenceindays365YearsAgo(num NUMBER) {
    return Intl.message(
      '${Intl.plural(NUMBER, one: 'one Year', other: '$NUMBER Years')} ago',
      name: 'differenceindays365YearsAgo',
      desc: '',
      args: [NUMBER],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
