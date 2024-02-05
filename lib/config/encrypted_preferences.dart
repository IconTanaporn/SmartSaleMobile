import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import '../utils/utils.dart';
import 'language.dart';

class EncryptedPref {
  EncryptedPref._();

  static const String _runtimeType = 'EncryptedPreferences';

  static const String _token = 'token';
  static const String _language = 'language';
  static const String _buId = 'bu_id';
  static const String _auth = 'auth';

  static final _encrypted = EncryptedSharedPreferences();

  static Future saveToken(String token) async {
    bool success = await _encrypted.setString(_token, token);
    if (success) {
      IconFrameworkUtils.log(_runtimeType, 'saveToken', 'success');
    } else {
      IconFrameworkUtils.log(_runtimeType, 'saveToken', 'fail');
    }
  }

  static Future saveLanguage(String lang) async {
    bool success = await _encrypted.setString(_language, lang);
    if (success) {
      IconFrameworkUtils.log(_runtimeType, 'saveLanguage', 'success');
    } else {
      IconFrameworkUtils.log(_runtimeType, 'saveLanguage', 'fail');
    }
  }

  static Future saveBuId(String id) async {
    bool success = await _encrypted.setString(_buId, id);
    if (success) {
      IconFrameworkUtils.log(_runtimeType, 'saveBuId', 'success');
    } else {
      IconFrameworkUtils.log(_runtimeType, 'saveBuId', 'fail');
    }
  }

  static Future saveAuth(String data) async {
    bool success = await _encrypted.setString(_auth, data);
    if (success) {
      IconFrameworkUtils.log(_runtimeType, 'saveUserLoginData', 'success');
    } else {
      IconFrameworkUtils.log(_runtimeType, 'saveUserLoginData', 'fail');
    }
  }

  static Future<String> getToken() async {
    return await _encrypted.getString(_token);
  }

  static Future<String> getLanguage() async {
    return await _encrypted.getString(_language);
  }

  static Future<String> getBuId() async {
    return await _encrypted.getString(_buId);
  }

  static Future<String> getAuth() async {
    return await _encrypted.getString(_auth);
  }

  static Future<bool> clearPreferences() async {
    bool success = await _encrypted.clear();
    saveLanguage(Language.currentLanguage);
    if (success) {
      IconFrameworkUtils.log(_runtimeType, 'clearPreferences', 'success');
    } else {
      IconFrameworkUtils.log(_runtimeType, 'clearPreferences', 'fail');
    }
    return success;
  }
}
