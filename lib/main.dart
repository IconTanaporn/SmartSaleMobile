import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/components/common/dissmiss_keyboard.dart';
import 'package:smart_sale_mobile/config/constant.dart';
import 'package:smart_sale_mobile/providers/auth_provider.dart';
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

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final authService = AuthService();
  final rootRouter = RootRoutes();

  MyApp({super.key});

  @override
  Widget build(context) {
    return ProviderScope(
      child: MainApp(authService, rootRouter),
    );
  }
}

class MainApp extends ConsumerWidget {
  final AuthService authService;
  final RootRoutes rootRouter;

  const MainApp(
    this.authService,
    this.rootRouter, {
    super.key,
  });

  @override
  Widget build(context, ref) {
    user = ref.watch(authControllerProvider).auth;
    navigatorKey = rootRouter.navigatorKey;

    return DismissKeyboard(
      child: MaterialApp.router(
        routerConfig: rootRouter.config(
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
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.white,
            iconTheme: const IconThemeData(
              color: AppColor.red,
            ),
            titleTextStyle: AppStyle.styleText(
              fontSize: FontSize.title,
              fontWeight: FontWeight.bold,
              color: AppColor.black2,
            ),
          ),
        ),
        localizationsDelegates: [
          Language.flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('th', 'TH'),
        ],
      ),
    );
  }
}
