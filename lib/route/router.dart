import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_sale_mobile/screens/setting/setting_page.dart';

import '../screens/auth/login_page.dart';
import '../screens/auth/splash_page.dart';
import '../screens/home_page.dart';
import '../screens/setting/setting_bu_page.dart';
import '../screens/setting/setting_language_page.dart';
import '../screens/setting/setting_profile_page.dart';
import 'auth_guard.dart';

part 'router.gr.dart';

/// [ref] - https://pub.dev/packages/auto_route/versions/7.8.0
///
/// [run] flutter packages pub run build_runner watch
/// [or] flutter packages pub run build_runner build
@AutoRouterConfig()
class RootRoutes extends _$RootRoutes {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/splash', keepHistory: false),
        AutoRoute(page: LoginRoute.page, path: '/login', keepHistory: false),
        AutoRoute(page: HomeRoute.page, path: '/', guards: [AuthGuard()]),
        AutoRoute(
          page: SettingRoute.page,
          path: '/setting',
          children: [
            AutoRoute(page: SettingLanguageRoute.page, path: 'language'),
            AutoRoute(page: SettingBuRoute.page, path: 'bu'),
            AutoRoute(page: SettingProfileRoute.page, path: 'profile'),
            RedirectRoute(path: '*', redirectTo: 'language'),
          ],
          guards: [AuthGuard()],
        ),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}
