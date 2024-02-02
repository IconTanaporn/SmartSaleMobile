import 'dart:ui';

import 'package:flutter_i18n/flutter_i18n.dart';

import '../utils/utils.dart';
import 'encrypted_preferences.dart';

class Language {
  Language._();

  static String _lang = 'th';
  static Map<String, dynamic> file = <String, dynamic>{};

  static String get currentLanguage => _lang;

  static FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      fallbackFile: 'th',
      basePath: 'assets/i18n',
    ),
    missingTranslationHandler: (key, locale) {
      IconFrameworkUtils.log(
        'FileTranslationLoader',
        '--- Missing Key: $key',
        'languageCode: ${locale?.countryCode}',
      );
    },
  );

  static Future setCurrentLanguage(String language) async {
    _lang = language;
    await EncryptedPref.saveLanguage(language);
    await FlutterI18n.refresh(
      navigatorKey.currentContext!,
      Locale(Language.currentLanguage),
    );
  }

  static Future setLanguage() async {
    final lang = await EncryptedPref.getLanguage();
    if (lang != '') {
      _lang = lang;
      await FlutterI18n.refresh(
        navigatorKey.currentContext!,
        Locale(Language.currentLanguage),
      );
    } else {
      setCurrentLanguage(Language.currentLanguage);
    }
  }

  static String translate(
    String key, {
    String? fallbackKey,
    Map<String, String>? translationParams,
  }) {
    final context = navigatorKey.currentContext!;
    return FlutterI18n.translate(
      context,
      key,
      fallbackKey: fallbackKey,
      translationParams: translationParams,
    );
  }
}
