import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';

import '../../config/asset_path.dart';
import '../../config/constant.dart';
import '../../config/language.dart';
import '../../route/router.dart';

@RoutePage()
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(context, ref) {
    return AutoTabsRouter(
      routes: const [
        SettingLanguageRoute(),
        SettingBuRoute(),
        SettingProfileRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            selectedItemColor: AppColor.blue,
            unselectedItemColor: AppColor.grey2,
            selectedLabelStyle: AppStyle.styleText(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: AppStyle.styleText(),
            items: [
              BottomNavigationBarItem(
                label: Language.translate('screen.setting.language.title'),
                icon: Image.asset(
                  AssetPath.iconSettingLanguage,
                  color: (tabsRouter.activeIndex == 0)
                      ? AppColor.blue
                      : AppColor.grey2,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: Language.translate('screen.setting.bu.title'),
                icon: Image.asset(
                  AssetPath.iconSettingBu,
                  color: (tabsRouter.activeIndex == 1)
                      ? AppColor.blue
                      : AppColor.grey2,
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: Language.translate('screen.setting.profile.title'),
                icon: Image.asset(
                  AssetPath.iconSettingProfile,
                  color: (tabsRouter.activeIndex == 2)
                      ? AppColor.blue
                      : AppColor.grey2,
                  height: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
