import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/screens/project/leads/lead/send_brochure_page.dart';
import 'package:smart_sale_mobile/screens/project/opportunities/opportunity/opportunity_questionnaire_page.dart';
import 'package:smart_sale_mobile/screens/setting/setting_page.dart';

import '../screens/auth/login_page.dart';
import '../screens/auth/splash_page.dart';
import '../screens/home_page.dart';
import '../screens/project/contacts/contact/contact_page.dart';
import '../screens/project/contacts/contact_list_page.dart';
import '../screens/project/leads/lead/activity_log_page.dart';
import '../screens/project/leads/lead/activity_page.dart';
import '../screens/project/leads/lead/add_activity_page.dart';
import '../screens/project/leads/lead/brochure_page.dart';
import '../screens/project/leads/lead/calendar_page.dart';
import '../screens/project/leads/lead/lead_page.dart';
import '../screens/project/leads/lead/lead_tab.dart';
import '../screens/project/leads/lead_list_page.dart';
import '../screens/project/opportunities/opportunity/edit_opportunity_page.dart';
import '../screens/project/opportunities/opportunity/opportunity_close_job_page.dart';
import '../screens/project/opportunities/opportunity/opportunity_page.dart';
import '../screens/project/opportunities/opportunity/opportunity_progress_page.dart';
import '../screens/project/opportunities/opportunity/opportunity_tab.dart';
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
  final AutoRoute _settingTab = AutoRoute(
    page: SettingRoute.page,
    path: '/setting',
    children: [
      AutoRoute(page: SettingLanguageRoute.page, path: 'language'),
      AutoRoute(page: SettingBuRoute.page, path: 'bu'),
      AutoRoute(page: SettingProfileRoute.page, path: 'profile'),
      RedirectRoute(path: '*', redirectTo: 'language'),
    ],
    guards: [AuthGuard()],
  );
  final AutoRoute _projectTab = AutoRoute(
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
  );

  final AutoRoute _contactTab = AutoRoute(
    page: ContactRoute.page,
    path: '/project/:projectId/contact/:id',
    guards: [AuthGuard()],
  );
  final AutoRoute _leadTab = AutoRoute(
    page: LeadTab.page,
    path: '/project/:projectId/lead/:id',
    children: [
      AutoRoute(page: LeadRoute.page, path: ''),
      AutoRoute(page: CalendarRoute.page, path: 'calendar'),
      AutoRoute(page: ActivityLogRoute.page, path: 'activities'),
      AutoRoute(page: BrochureRoute.page, path: 'brochure'),
    ],
    guards: [AuthGuard()],
  );
  final AutoRoute _opportunityTab = AutoRoute(
    page: OpportunityTap.page,
    path: '/project/:projectId/opportunity/:id',
    children: [
      AutoRoute(page: OpportunityRoute.page, path: ''),
      AutoRoute(page: OpportunityProgressRoute.page, path: 'progress'),
      AutoRoute(page: OpportunityCloseJobRoute.page, path: 'close_job'),
      AutoRoute(
        page: OpportunityQuestionnaireRoute.page,
        path: 'questionnaire',
      ),
    ],
    guards: [AuthGuard()],
  );

  final List<AutoRoute> _leadRoutes = [
    AutoRoute(
      page: SendBrochureRoute.page,
      path: '/project/:projectId/:stage/:id/brochure/send',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: AddActivityRoute.page,
      path: '/project/:projectId/:stage/:refId/activity/add/:timestamp',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: ActivityRoute.page,
      path: '/project/:projectId/:stage/:refId/activity/:id',
      guards: [AuthGuard()],
    ),
  ];

  final List<AutoRoute> _opportunityRoutes = [
    AutoRoute(
      page: EditOpportunityRoute.page,
      path: '/project/:projectId/opportunity/:id/edit',
      guards: [AuthGuard()],
    ),
  ];

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
        _settingTab,
        ..._leadRoutes,
        _contactTab,
        _leadTab,
        ..._opportunityRoutes,
        _opportunityTab,
        _projectTab,
        AutoRoute(page: QRRoute.page, path: '/qr'),
        RedirectRoute(path: '*', redirectTo: '/'),
      ];
}
