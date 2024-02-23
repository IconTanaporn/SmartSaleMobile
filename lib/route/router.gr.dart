// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$RootRoutes extends RootStackRouter {
  // ignore: unused_element
  _$RootRoutes({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ActivityLogRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ActivityLogRouteArgs>(
          orElse: () => ActivityLogRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ActivityLogPage(
          referenceId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    BrochureRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<BrochureRouteArgs>(
          orElse: () => BrochureRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BrochurePage(
          referenceId: pathParams.getString(
            'id',
            '',
          ),
          projectId: pathParams.getString(
            'projectId',
            '',
          ),
          key: args.key,
        ),
      );
    },
    CalendarRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CalendarRouteArgs>(
          orElse: () => CalendarRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarPage(
          referenceId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    ContactListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ContactListRouteArgs>(
          orElse: () => ContactListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ContactListPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
    ContactRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ContactRouteArgs>(
          orElse: () => ContactRouteArgs(
                  contactId: pathParams.getString(
                'id',
                '',
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ContactPage(
          contactId: args.contactId,
          projectId: pathParams.getString(
            'projectId',
            '',
          ),
          key: args.key,
        ),
      );
    },
    CreateContactRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CreateContactRouteArgs>(
          orElse: () => CreateContactRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreateContactPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
    EditOpportunityRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EditOpportunityRouteArgs>(
          orElse: () => EditOpportunityRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditOpportunityPage(
          oppId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePage(key: args.key),
      );
    },
    LeadListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LeadListRouteArgs>(
          orElse: () => LeadListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LeadListPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
    LeadRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<LeadRouteArgs>(
          orElse: () => LeadRouteArgs(
                  contactId: pathParams.getString(
                'id',
                '',
              )));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LeadPage(
          contactId: args.contactId,
          key: args.key,
        ),
      );
    },
    LeadTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LeadTapPage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(
          key: args.key,
          onResult: args.onResult,
          showBackButton: args.showBackButton,
        ),
      );
    },
    OpportunityCloseJobRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OpportunityCloseJobRouteArgs>(
          orElse: () => OpportunityCloseJobRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OpportunityCloseJobPage(
          oppId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    OpportunityListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OpportunityListRouteArgs>(
          orElse: () => OpportunityListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OpportunityListPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
    OpportunityRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OpportunityRouteArgs>(
          orElse: () => OpportunityRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OpportunityPage(
          oppId: pathParams.getString(
            'id',
            '',
          ),
          projectId: pathParams.getString(
            'projectId',
            '',
          ),
          key: args.key,
        ),
      );
    },
    OpportunityProgressRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OpportunityProgressRouteArgs>(
          orElse: () => OpportunityProgressRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OpportunityProgressPage(
          oppId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    OpportunityQuestionnaireRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OpportunityQuestionnaireRouteArgs>(
          orElse: () => OpportunityQuestionnaireRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OpportunityQuestionnairePage(
          oppId: pathParams.getString(
            'id',
            '',
          ),
          key: args.key,
        ),
      );
    },
    OpportunityTap.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OpportunityTapPage(),
      );
    },
    ProjectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProjectPage(),
      );
    },
    QRRoute.name: (routeData) {
      final args =
          routeData.argsAs<QRRouteArgs>(orElse: () => const QRRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: QRPage(
          url: args.url,
          title: args.title,
          detail: args.detail,
          key: args.key,
        ),
      );
    },
    SendBrochureRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<SendBrochureRouteArgs>(
          orElse: () => SendBrochureRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SendBrochurePage(
          referenceId: pathParams.getString(
            'id',
            '',
          ),
          stage: pathParams.getString(
            'stage',
            '',
          ),
          projectId: pathParams.getString(
            'projectId',
            '',
          ),
          key: args.key,
        ),
      );
    },
    SettingBuRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingBuPage(),
      );
    },
    SettingLanguageRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingLanguagePage(),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingPage(),
      );
    },
    SettingProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingProfilePage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    WalkInRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args =
          routeData.argsAs<WalkInRouteArgs>(orElse: () => WalkInRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WalkInPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
    WalkInTab.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args =
          routeData.argsAs<WalkInTabArgs>(orElse: () => WalkInTabArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WalkInTabPage(
          projectId: pathParams.getString('id'),
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [ActivityLogPage]
class ActivityLogRoute extends PageRouteInfo<ActivityLogRouteArgs> {
  ActivityLogRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ActivityLogRoute.name,
          args: ActivityLogRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ActivityLogRoute';

  static const PageInfo<ActivityLogRouteArgs> page =
      PageInfo<ActivityLogRouteArgs>(name);
}

class ActivityLogRouteArgs {
  const ActivityLogRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ActivityLogRouteArgs{key: $key}';
  }
}

/// generated route for
/// [BrochurePage]
class BrochureRoute extends PageRouteInfo<BrochureRouteArgs> {
  BrochureRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          BrochureRoute.name,
          args: BrochureRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'BrochureRoute';

  static const PageInfo<BrochureRouteArgs> page =
      PageInfo<BrochureRouteArgs>(name);
}

class BrochureRouteArgs {
  const BrochureRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'BrochureRouteArgs{key: $key}';
  }
}

/// generated route for
/// [CalendarPage]
class CalendarRoute extends PageRouteInfo<CalendarRouteArgs> {
  CalendarRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CalendarRoute.name,
          args: CalendarRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const PageInfo<CalendarRouteArgs> page =
      PageInfo<CalendarRouteArgs>(name);
}

class CalendarRouteArgs {
  const CalendarRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CalendarRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ContactListPage]
class ContactListRoute extends PageRouteInfo<ContactListRouteArgs> {
  ContactListRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ContactListRoute.name,
          args: ContactListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ContactListRoute';

  static const PageInfo<ContactListRouteArgs> page =
      PageInfo<ContactListRouteArgs>(name);
}

class ContactListRouteArgs {
  const ContactListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'ContactListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [ContactPage]
class ContactRoute extends PageRouteInfo<ContactRouteArgs> {
  ContactRoute({
    String contactId = '',
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ContactRoute.name,
          args: ContactRouteArgs(
            contactId: contactId,
            key: key,
          ),
          rawPathParams: {'id': contactId},
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static const PageInfo<ContactRouteArgs> page =
      PageInfo<ContactRouteArgs>(name);
}

class ContactRouteArgs {
  const ContactRouteArgs({
    this.contactId = '',
    this.key,
  });

  final String contactId;

  final Key? key;

  @override
  String toString() {
    return 'ContactRouteArgs{contactId: $contactId, key: $key}';
  }
}

/// generated route for
/// [CreateContactPage]
class CreateContactRoute extends PageRouteInfo<CreateContactRouteArgs> {
  CreateContactRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CreateContactRoute.name,
          args: CreateContactRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CreateContactRoute';

  static const PageInfo<CreateContactRouteArgs> page =
      PageInfo<CreateContactRouteArgs>(name);
}

class CreateContactRouteArgs {
  const CreateContactRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'CreateContactRouteArgs{key: $key}';
  }
}

/// generated route for
/// [EditOpportunityPage]
class EditOpportunityRoute extends PageRouteInfo<EditOpportunityRouteArgs> {
  EditOpportunityRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          EditOpportunityRoute.name,
          args: EditOpportunityRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EditOpportunityRoute';

  static const PageInfo<EditOpportunityRouteArgs> page =
      PageInfo<EditOpportunityRouteArgs>(name);
}

class EditOpportunityRouteArgs {
  const EditOpportunityRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'EditOpportunityRouteArgs{key: $key}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [LeadListPage]
class LeadListRoute extends PageRouteInfo<LeadListRouteArgs> {
  LeadListRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LeadListRoute.name,
          args: LeadListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LeadListRoute';

  static const PageInfo<LeadListRouteArgs> page =
      PageInfo<LeadListRouteArgs>(name);
}

class LeadListRouteArgs {
  const LeadListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LeadListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [LeadPage]
class LeadRoute extends PageRouteInfo<LeadRouteArgs> {
  LeadRoute({
    String contactId = '',
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LeadRoute.name,
          args: LeadRouteArgs(
            contactId: contactId,
            key: key,
          ),
          rawPathParams: {'id': contactId},
          initialChildren: children,
        );

  static const String name = 'LeadRoute';

  static const PageInfo<LeadRouteArgs> page = PageInfo<LeadRouteArgs>(name);
}

class LeadRouteArgs {
  const LeadRouteArgs({
    this.contactId = '',
    this.key,
  });

  final String contactId;

  final Key? key;

  @override
  String toString() {
    return 'LeadRouteArgs{contactId: $contactId, key: $key}';
  }
}

/// generated route for
/// [LeadTapPage]
class LeadTab extends PageRouteInfo<void> {
  const LeadTab({List<PageRouteInfo>? children})
      : super(
          LeadTab.name,
          initialChildren: children,
        );

  static const String name = 'LeadTab';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    void Function(bool)? onResult,
    bool showBackButton = true,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
            showBackButton: showBackButton,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.onResult,
    this.showBackButton = true,
  });

  final Key? key;

  final void Function(bool)? onResult;

  final bool showBackButton;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult, showBackButton: $showBackButton}';
  }
}

/// generated route for
/// [OpportunityCloseJobPage]
class OpportunityCloseJobRoute
    extends PageRouteInfo<OpportunityCloseJobRouteArgs> {
  OpportunityCloseJobRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OpportunityCloseJobRoute.name,
          args: OpportunityCloseJobRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OpportunityCloseJobRoute';

  static const PageInfo<OpportunityCloseJobRouteArgs> page =
      PageInfo<OpportunityCloseJobRouteArgs>(name);
}

class OpportunityCloseJobRouteArgs {
  const OpportunityCloseJobRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpportunityCloseJobRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OpportunityListPage]
class OpportunityListRoute extends PageRouteInfo<OpportunityListRouteArgs> {
  OpportunityListRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OpportunityListRoute.name,
          args: OpportunityListRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OpportunityListRoute';

  static const PageInfo<OpportunityListRouteArgs> page =
      PageInfo<OpportunityListRouteArgs>(name);
}

class OpportunityListRouteArgs {
  const OpportunityListRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpportunityListRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OpportunityPage]
class OpportunityRoute extends PageRouteInfo<OpportunityRouteArgs> {
  OpportunityRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OpportunityRoute.name,
          args: OpportunityRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OpportunityRoute';

  static const PageInfo<OpportunityRouteArgs> page =
      PageInfo<OpportunityRouteArgs>(name);
}

class OpportunityRouteArgs {
  const OpportunityRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpportunityRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OpportunityProgressPage]
class OpportunityProgressRoute
    extends PageRouteInfo<OpportunityProgressRouteArgs> {
  OpportunityProgressRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OpportunityProgressRoute.name,
          args: OpportunityProgressRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OpportunityProgressRoute';

  static const PageInfo<OpportunityProgressRouteArgs> page =
      PageInfo<OpportunityProgressRouteArgs>(name);
}

class OpportunityProgressRouteArgs {
  const OpportunityProgressRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpportunityProgressRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OpportunityQuestionnairePage]
class OpportunityQuestionnaireRoute
    extends PageRouteInfo<OpportunityQuestionnaireRouteArgs> {
  OpportunityQuestionnaireRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          OpportunityQuestionnaireRoute.name,
          args: OpportunityQuestionnaireRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'OpportunityQuestionnaireRoute';

  static const PageInfo<OpportunityQuestionnaireRouteArgs> page =
      PageInfo<OpportunityQuestionnaireRouteArgs>(name);
}

class OpportunityQuestionnaireRouteArgs {
  const OpportunityQuestionnaireRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'OpportunityQuestionnaireRouteArgs{key: $key}';
  }
}

/// generated route for
/// [OpportunityTapPage]
class OpportunityTap extends PageRouteInfo<void> {
  const OpportunityTap({List<PageRouteInfo>? children})
      : super(
          OpportunityTap.name,
          initialChildren: children,
        );

  static const String name = 'OpportunityTap';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProjectPage]
class ProjectRoute extends PageRouteInfo<void> {
  const ProjectRoute({List<PageRouteInfo>? children})
      : super(
          ProjectRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProjectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [QRPage]
class QRRoute extends PageRouteInfo<QRRouteArgs> {
  QRRoute({
    String url = '',
    String title = '',
    String detail = '',
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          QRRoute.name,
          args: QRRouteArgs(
            url: url,
            title: title,
            detail: detail,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'QRRoute';

  static const PageInfo<QRRouteArgs> page = PageInfo<QRRouteArgs>(name);
}

class QRRouteArgs {
  const QRRouteArgs({
    this.url = '',
    this.title = '',
    this.detail = '',
    this.key,
  });

  final String url;

  final String title;

  final String detail;

  final Key? key;

  @override
  String toString() {
    return 'QRRouteArgs{url: $url, title: $title, detail: $detail, key: $key}';
  }
}

/// generated route for
/// [SendBrochurePage]
class SendBrochureRoute extends PageRouteInfo<SendBrochureRouteArgs> {
  SendBrochureRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SendBrochureRoute.name,
          args: SendBrochureRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SendBrochureRoute';

  static const PageInfo<SendBrochureRouteArgs> page =
      PageInfo<SendBrochureRouteArgs>(name);
}

class SendBrochureRouteArgs {
  const SendBrochureRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'SendBrochureRouteArgs{key: $key}';
  }
}

/// generated route for
/// [SettingBuPage]
class SettingBuRoute extends PageRouteInfo<void> {
  const SettingBuRoute({List<PageRouteInfo>? children})
      : super(
          SettingBuRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingBuRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingLanguagePage]
class SettingLanguageRoute extends PageRouteInfo<void> {
  const SettingLanguageRoute({List<PageRouteInfo>? children})
      : super(
          SettingLanguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingLanguageRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingPage]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingProfilePage]
class SettingProfileRoute extends PageRouteInfo<void> {
  const SettingProfileRoute({List<PageRouteInfo>? children})
      : super(
          SettingProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WalkInPage]
class WalkInRoute extends PageRouteInfo<WalkInRouteArgs> {
  WalkInRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          WalkInRoute.name,
          args: WalkInRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'WalkInRoute';

  static const PageInfo<WalkInRouteArgs> page = PageInfo<WalkInRouteArgs>(name);
}

class WalkInRouteArgs {
  const WalkInRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'WalkInRouteArgs{key: $key}';
  }
}

/// generated route for
/// [WalkInTabPage]
class WalkInTab extends PageRouteInfo<WalkInTabArgs> {
  WalkInTab({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          WalkInTab.name,
          args: WalkInTabArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'WalkInTab';

  static const PageInfo<WalkInTabArgs> page = PageInfo<WalkInTabArgs>(name);
}

class WalkInTabArgs {
  const WalkInTabArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'WalkInTabArgs{key: $key}';
  }
}
