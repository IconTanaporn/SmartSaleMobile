import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_sale_mobile/config/encrypted_preferences.dart';
import 'package:smart_sale_mobile/route/router.dart';

bool isAuthenticated = false;

class AuthGuard implements AutoRouteGuard {
  Future<bool> loadUserLoginData() async {
    String auth = await EncryptedPref.getAuth();
    return auth != '';
  }

  @override
  Future onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (await loadUserLoginData()) {
      // await ConfigFirebaseMessage.registerNotification();
      isAuthenticated = true;
    }

    if (isAuthenticated) {
      resolver.next();
    } else {
      resolver.redirect(LoginRoute(onResult: (success) {
        // await ConfigFirebaseMessage.registerNotification();
        isAuthenticated = true;
        resolver.next();
      }));
    }
  }
}

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  set isAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }
}
