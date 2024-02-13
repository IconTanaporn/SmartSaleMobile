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
    ContactTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ContactTabPage(),
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
    LeadTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LeadTabPage(),
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
    OpportunityTab.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OpportunityTabPage(),
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
/// [ContactTabPage]
class ContactTab extends PageRouteInfo<void> {
  const ContactTab({List<PageRouteInfo>? children})
      : super(
          ContactTab.name,
          initialChildren: children,
        );

  static const String name = 'ContactTab';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [LeadTabPage]
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
/// [OpportunityTabPage]
class OpportunityTab extends PageRouteInfo<void> {
  const OpportunityTab({List<PageRouteInfo>? children})
      : super(
          OpportunityTab.name,
          initialChildren: children,
        );

  static const String name = 'OpportunityTab';

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
