import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_sale_mobile/utils/utils.dart';

class MyObserver extends AutoRouterObserver {
  final String _tag = 'RouteObserver';
  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      IconFrameworkUtils.log(
        _tag,
        'New route pushed',
        route.settings.name.toString(),
      );
      if (route.data != null) {
        if (route.data!.pathParams.isNotEmpty) {
          IconFrameworkUtils.log(
            _tag,
            'Params',
            route.data!.pathParams.toString(),
          );
        }
      }
      // GoogleAnalytics.logScreens(
      //   '/',
      //   'Splash',
      // );
    } else {
      IconFrameworkUtils.log(
        _tag,
        'New route pushed',
        'Dialog',
      );
    }
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    IconFrameworkUtils.log(
      _tag,
      'Tab route visited',
      route.name.toString(),
    );
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    IconFrameworkUtils.log(
      _tag,
      'Tab route re-visited',
      route.name.toString(),
    );
  }
}
