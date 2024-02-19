import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';

import '../../api/api_controller.dart';
import '../../config/asset_path.dart';
import '../../config/constant.dart';
import '../../config/language.dart';
import '../../route/router.dart';

final projectProvider = FutureProvider.family<dynamic, String>((ref, id) async {
  var data = await ApiController.conceptDetail(id);
  return data;
});

@RoutePage()
class ProjectPage extends ConsumerWidget {
  const ProjectPage({
    // @PathParam('id') this.projectId = '',
    super.key,
  });

  // final String projectId;

  @override
  Widget build(context, ref) {
    return AutoTabsScaffold(
      routes: [
        WalkInTab(),
        ContactListRoute(),
        LeadListRoute(),
        OpportunityListRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
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
              label: Language.translate('screen.project.menu.walk_in'),
              icon: Image.asset(
                AssetPath.iconWalkIn,
                color: (tabsRouter.activeIndex == 0)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.project.menu.contact'),
              icon: Image.asset(
                AssetPath.iconContact,
                color: (tabsRouter.activeIndex == 1)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.project.menu.lead'),
              icon: Image.asset(
                AssetPath.iconLead,
                color: (tabsRouter.activeIndex == 2)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.project.menu.opportunity'),
              icon: Image.asset(
                AssetPath.iconOpportunity,
                color: (tabsRouter.activeIndex == 3)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
