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

  /// `DELETE`
  String get Alert_Delete {
    return Intl.message(
      'DELETE',
      name: 'Alert_Delete',
      desc: '',
      args: [],
    );
  }

  /// `ERROR`
  String get Alert_Error {
    return Intl.message(
      'ERROR',
      name: 'Alert_Error',
      desc: '',
      args: [],
    );
  }

  /// `Remind`
  String get Alert_Remind {
    return Intl.message(
      'Remind',
      name: 'Alert_Remind',
      desc: '',
      args: [],
    );
  }

  /// `FINISH`
  String get Alert_Finish {
    return Intl.message(
      'FINISH',
      name: 'Alert_Finish',
      desc: '',
      args: [],
    );
  }

  /// `WARNING`
  String get Alert_Warning {
    return Intl.message(
      'WARNING',
      name: 'Alert_Warning',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Button_Cancel {
    return Intl.message(
      'Cancel',
      name: 'Button_Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get Button_Confirm {
    return Intl.message(
      'Sure',
      name: 'Button_Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Please type in member name`
  String get add_member_hint {
    return Intl.message(
      'Please type in member name',
      name: 'add_member_hint',
      desc: '',
      args: [],
    );
  }

  /// `Member is existed`
  String get existed_member {
    return Intl.message(
      'Member is existed',
      name: 'existed_member',
      desc: '',
      args: [],
    );
  }

  /// `MainDish is existed`
  String get existed_mainDish {
    return Intl.message(
      'MainDish is existed',
      name: 'existed_mainDish',
      desc: '',
      args: [],
    );
  }

  /// `Beverage is existed`
  String get existed_beverage {
    return Intl.message(
      'Beverage is existed',
      name: 'existed_beverage',
      desc: '',
      args: [],
    );
  }

  /// `Sort (smaller first; default 0)`
  String get hint_sort {
    return Intl.message(
      'Sort (smaller first; default 0)',
      name: 'hint_sort',
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
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
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
