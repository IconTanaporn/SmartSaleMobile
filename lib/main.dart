import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/dissmiss_keyboard.dart';
import 'package:smart_sale_mobile/config/constant.dart';
import 'package:smart_sale_mobile/route/auth_guard.dart';
import 'package:smart_sale_mobile/route/observer.dart';
import 'package:smart_sale_mobile/route/router.dart';
import 'package:smart_sale_mobile/utils/utils.dart';

import 'config/language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    IconFrameworkUtils.log(
      'CameraDescription',
      'Error in fetching the cameras',
      e.toString(),
    );
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authService = AuthService();

  final _rootRouter = RootRoutes();

  @override
  Widget build(BuildContext context) {
    navigatorKey = _rootRouter.navigatorKey;
    return DismissKeyboard(
      child: MaterialApp.router(
        routerConfig: _rootRouter.config(
          deepLinkBuilder: (_) => const DeepLink([SplashRoute()]),
          navigatorObservers: () => [MyObserver()],
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColor.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          iconTheme: const IconThemeData(
            color: AppColor.black2,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.white,
            iconTheme: IconThemeData(
              color: AppColor.black2,
            ),
          ),
        ),
        localizationsDelegates: [
          Language.flutterI18nDelegate,
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          // GlobalMaterialLocalizations.delegate,
          // GlobalCupertinoLocalizations.delegate,
        ],
        // supportedLocales: const [
        //   Locale('en', 'US'),
        //   Locale('th', 'TH'),
        // ],
      ),
    );
  }
}
