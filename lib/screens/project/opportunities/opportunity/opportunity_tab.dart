import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/route/router.dart';
import 'package:smart_sale_mobile/screens/project/opportunities/opportunity/opportunity_page.dart';

import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';

@RoutePage(name: 'OpportunityTap')
class OpportunityTapPage extends ConsumerWidget {
  const OpportunityTapPage({super.key});

  @override
  Widget build(context, ref) {
    final opp = ref.watch(opportunityProvider);
    final canEdit = opp.canEdit;

    return AutoTabsScaffold(
      routes: [
        OpportunityRoute(),
        OpportunityProgressRoute(),
        OpportunityQuestionnaireRoute(),
        OpportunityCloseJobRoute(),
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
              label: Language.translate('screen.project.menu.opportunity'),
              icon: Image.asset(
                AssetPath.iconOpportunity,
                color: (tabsRouter.activeIndex == 0)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.opportunity.menu.progress'),
              icon: Image.asset(
                AssetPath.iconProgress,
                color: (tabsRouter.activeIndex == 1)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label:
                  Language.translate('screen.opportunity.menu.questionnaire'),
              icon: Image.asset(
                AssetPath.iconQuestionnaire,
                color: (tabsRouter.activeIndex == 2)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            if (canEdit)
              BottomNavigationBarItem(
                label: Language.translate('screen.opportunity.menu.close_job'),
                icon: Image.asset(
                  AssetPath.iconCloseJob,
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
