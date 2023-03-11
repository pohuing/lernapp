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
