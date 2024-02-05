import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/api/api_client.dart';

import '../config/encrypted_preferences.dart';
import '../route/auth_guard.dart';

class User {
  String _token = '';
  String _saleId = '';
  String _buId = '';

  String get token => _token;
  String get saleId => _saleId;
  String get buId => _buId;
  bool get isSignedIn => _saleId != '';

  init(String token, String sale, String bu) {
    _token = token;
    _saleId = sale;
    _buId = bu;
  }

  setToken(String token) {
    _token = token;
  }

  signIn(String sale, String bu) {
    _saleId = sale;
    _buId = bu;
  }

  signOut() {
    _saleId = '';
    _buId = '';
  }
}

class AuthController extends ChangeNotifier {
  User user = User();

  bool get isSignedIn => user.isSignedIn;

  Future<void> init() async {
    String token = await EncryptedPref.getToken();
    String auth = await EncryptedPref.getAuth();
    String buId = await EncryptedPref.getBuId();

    var data = jsonDecode(auth);
    String saleId = data['sale_id'].toString();
    if (saleId != '') {
      isAuthenticated = true;
      ApiClient.setSaleId(saleId);
    }
    if (buId != '') {
      ApiClient.setBuId(buId);
    }
    // await ConfigFirebaseMessage.registerNotification();

    user.init(token, saleId, buId);
    notifyListeners();
  }

  Future<void> setToken(token) async {
    EncryptedPref.saveToken(jsonEncode(token).toString());
    user = user.setToken(jsonEncode(token).toString());
    notifyListeners();
  }

  Future<void> signIn(data) async {
    EncryptedPref.saveAuth(jsonEncode(data).toString());

    String saleId = data['sale_id'].toString();
    String buId = data['bu_id'].toString();
    if (saleId != '') {
      isAuthenticated = true;
      ApiClient.setSaleId(saleId);
    }
    if (buId != '') {
      ApiClient.setBuId(buId);
      EncryptedPref.saveBuId(data['bu_id']);
    }
    // await ConfigFirebaseMessage.registerNotification();
    user = user.signIn(data['sale_id'], data['bu_id']);
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: [Logout] clear data
    isAuthenticated = false;

    EncryptedPref.clearPreferences();
    user = user.signOut();
    notifyListeners();
  }
}

final authControllerProvider = ChangeNotifierProvider<AuthController>((ref) {
  return AuthController();
});
