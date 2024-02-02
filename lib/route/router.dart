import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../screens/auth/login_page.dart';
import '../screens/auth/splash_page.dart';
import '../screens/home_page.dart';
import 'auth_guard.dart';

part 'router.gr.dart';

/// [ref] https://pub.dev/packages/auto_route/versions/7.8.0
///
/// [run] flutter packages pub run build_runner watch
@AutoRouterConfig()
class RootRoutes extends _$RootRoutes {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/splash', keepHistory: false),
        AutoRoute(page: LoginRoute.page, path: '/login', keepHistory: false),
        AutoRoute(page: HomeRoute.page, path: '/', guards: [AuthGuard()]),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}
