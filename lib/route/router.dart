import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/screens/setting/setting_page.dart';

import '../screens/auth/login_page.dart';
import '../screens/auth/splash_page.dart';
import '../screens/home_page.dart';
import '../screens/project/contacts/contact/contact_page.dart';
import '../screens/project/contacts/contact_list_page.dart';
import '../screens/project/leads/lead/lead_page.dart';
import '../screens/project/leads/lead_list_page.dart';
import '../screens/project/opportunities/opportunity/opportunity_page.dart';
import '../screens/project/opportunities/opportunity_list_page.dart';
import '../screens/project/project_page.dart';
import '../screens/project/walk_in/create_contact_page.dart';
import '../screens/project/walk_in/walk_in_page.dart';
import '../screens/project/walk_in/walk_in_tab.dart';
import '../screens/qr_page.dart';
import '../screens/setting/setting_bu_page.dart';
import '../screens/setting/setting_language_page.dart';
import '../screens/setting/setting_profile_page.dart';
import 'auth_guard.dart';

part 'router.gr.dart';

/// [ref] - https://pub.dev/packages/auto_route/versions/7.8.0
///
/// [build_runner]
/// - flutter packages pub run build_runner build
/// - flutter packages pub run build_runner watch
/// - flutter packages pub run build_runner watch --delete-conflicting-outputs
/// - flutter packages pub run build_runner clean
@AutoRouterConfig()
class RootRoutes extends _$RootRoutes {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          path: '/splash',
          keepHistory: false,
          initial: true,
        ),
        AutoRoute(page: LoginRoute.page, path: '/login'),
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
        AutoRoute(
          page: ContactRoute.page,
          path: '/project/:projectId/contact/:id',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: LeadRoute.page,
          path: '/project/:projectId/lead/:id',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: OpportunityRoute.page,
          path: '/project/:projectId/opportunity/:id',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: ProjectRoute.page,
          path: '/project/:id',
          children: [
            AutoRoute(
              page: WalkInTab.page,
              path: 'walk_in',
              maintainState: true,
              children: [
                AutoRoute(page: WalkInRoute.page, path: ''),
                AutoRoute(page: CreateContactRoute.page, path: 'full'),
                // RedirectRoute(path: '*', redirectTo: ''),
              ],
            ),
            AutoRoute(page: ContactListRoute.page, path: 'contact'),
            AutoRoute(page: LeadListRoute.page, path: 'lead'),
            AutoRoute(page: OpportunityListRoute.page, path: 'opportunity'),
            RedirectRoute(path: '*', redirectTo: 'walk_in'),
          ],
          guards: [AuthGuard()],
        ),
        AutoRoute(page: QRRoute.page, path: '/qr'),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}

@RoutePage(name: 'ContactTab')
class ContactTabPage extends AutoRouter {
  const ContactTabPage({super.key});
}

@RoutePage(name: 'LeadTab')
class LeadTabPage extends AutoRouter {
  const LeadTabPage({super.key});
}

@RoutePage(name: 'OpportunityTab')
class OpportunityTabPage extends AutoRouter {
  const OpportunityTabPage({super.key});
}
