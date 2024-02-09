import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/api/api_client.dart';

import '../config/encrypted_preferences.dart';

class User {
  String _token = '';
  String _saleId = '';
  String _buId = '';

  String get token => _token;
  String get saleId => _saleId;
  String get buId => _buId;
  bool get isSignedIn => _saleId != '';

  setToken(String value) {
    _token = value;
  }

  setSaleId(String value) {
    _saleId = value;
  }

  setBuId(String value) {
    _buId = value;
  }
}

User user = User();

class AuthController extends ChangeNotifier {
  User get auth => user;

  bool get isSignedIn => user.isSignedIn;

  Future<void> init() async {
    String token = await EncryptedPref.getToken();
    String auth = await EncryptedPref.getAuth();
    String buId = await EncryptedPref.getBuId();

    user.setToken(token);

    if (auth.isNotEmpty) {
      var data = jsonDecode(auth);
      String saleId = data['sale_id'].toString();
      if (saleId != '') {
        ApiClient.setSaleId(saleId);
        await user.setSaleId(saleId);
      }
      if (buId != '') {
        ApiClient.setBuId(buId);
        await user.setBuId(buId);
      }
    }

    // await ConfigFirebaseMessage.registerNotification();

    notifyListeners();
  }

  Future<void> setToken(token) async {
    await EncryptedPref.saveToken(jsonEncode(token).toString());
    await user.setToken(jsonEncode(token).toString());
    notifyListeners();
  }

  Future<void> setBuId(String bu) async {
    await EncryptedPref.saveBuId(bu);
    await user.setBuId(bu);

    notifyListeners();
  }

  Future<void> signIn(data) async {
    await EncryptedPref.saveAuth(jsonEncode(data).toString());

    String saleId = data['sale_id'];
    String buId = data['bu_id'].toString();
    if (saleId != '') {
      ApiClient.setSaleId(saleId);
      await user.setSaleId(data['sale_id']);
    }

    if (buId != '') {
      ApiClient.setBuId(buId);
      await EncryptedPref.saveBuId(data['bu_id']);
      await user.setBuId(data['bu_id']);
    }
    // await ConfigFirebaseMessage.registerNotification();
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: [Logout] clear data

    await EncryptedPref.clearPreferences();
    user = User();
    notifyListeners();
  }
}

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});
