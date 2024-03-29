import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../providers/auth_provider.dart';

class AuthGuard implements AutoRouteGuard {
  @override
  Future onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (user.isSignedIn) {
      resolver.next();
    } else {
      resolver.redirect(LoginRoute(onResult: (success) {
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
