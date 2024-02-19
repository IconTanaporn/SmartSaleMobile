import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../../../../api/api_controller.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/opportunity.dart';
import '../../../../utils/utils.dart';

final opportunityProvider = FutureProvider.autoDispose
    .family<OpportunityDetail, String>((ref, id) async {
  var data = await ApiController.opportunityDetail(id);
  return OpportunityDetail(
    oppId: IconFrameworkUtils.getValue(data, 'id'),
    oppName: IconFrameworkUtils.getValue(data, 'name'),
    comment: IconFrameworkUtils.getValue(data, 'comment'),
    budget: IconFrameworkUtils.getValue(data, 'budget'),
    projectId: IconFrameworkUtils.getValue(data, 'project_id'),
    projectName: IconFrameworkUtils.getValue(data, 'project_name'),
    status: IconFrameworkUtils.getValue(data, 'status'),
    createDate: IconFrameworkUtils.getValue(data, 'createdate'),
    expDate: IconFrameworkUtils.getValue(data, 'expdate'),
    contactId: IconFrameworkUtils.getValue(data, 'contact_id'),
    contactName: IconFrameworkUtils.getValue(data, 'contact_name'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
  );
});

@RoutePage(name: 'OpportunityTap')
class OpportunityTapPage extends ConsumerWidget {
  const OpportunityTapPage({
    // @PathParam('id') this.oppId = '',
    super.key,
  });

  // final String oppId;

  @override
  Widget build(context, ref) {
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
