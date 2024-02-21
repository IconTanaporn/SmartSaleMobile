import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../../../../api/api_controller.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/lead.dart';
import '../../../../utils/utils.dart';

final leadProvider =
    FutureProvider.autoDispose.family<LeadDetail, String>((ref, id) async {
  var data = await ApiController.leadDetail(id);
  return LeadDetail(
    id: id,
    prefix: IconFrameworkUtils.getValue(data, 'prefix_name'),
    trackingAmount: IconFrameworkUtils.getValue(data, 'tracking_amount'),
    firstName: IconFrameworkUtils.getValue(data, 'firstname'),
    lastName: IconFrameworkUtils.getValue(data, 'lastname'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
    email: IconFrameworkUtils.getValue(data, 'email'),
    lineId: IconFrameworkUtils.getValue(data, 'line_id'),
    source: IconFrameworkUtils.getValue(data, 'source_name'),
    status: IconFrameworkUtils.getValue(data, 'status_name'),
  );
});

@RoutePage(name: 'LeadTab')
class LeadTapPage extends ConsumerWidget {
  const LeadTapPage({
    // @PathParam('id') this.leadId = '',
    super.key,
  });

  // final String leadId;

  @override
  Widget build(context, ref) {
    return AutoTabsScaffold(
      routes: [
        LeadRoute(),
        CalendarRoute(),
        ActivityLogRoute(),
        BrochureRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (i) {
            if (i == 4) {
              IconFrameworkUtils.showAlertDialog(title: 'Contact Customer');
            } else {
              tabsRouter.setActiveIndex(i);
            }
          },
          selectedItemColor: AppColor.blue,
          unselectedItemColor: AppColor.grey2,
          selectedLabelStyle: AppStyle.styleText(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: AppStyle.styleText(),
          items: [
            BottomNavigationBarItem(
              label: Language.translate('screen.project.menu.lead'),
              icon: Image.asset(
                AssetPath.iconLead,
                color: (tabsRouter.activeIndex == 0)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.lead.menu.calendar'),
              icon: Image.asset(
                AssetPath.iconCalendar,
                color: (tabsRouter.activeIndex == 1)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.lead.menu.activity_log'),
              icon: Image.asset(
                AssetPath.iconActivityLog,
                color: (tabsRouter.activeIndex == 2)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.lead.menu.brochure'),
              icon: Image.asset(
                AssetPath.iconBrochure,
                color: (tabsRouter.activeIndex == 3)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.lead.menu.contact_customer'),
              icon: Image.asset(
                AssetPath.iconContactCustomer,
                color: AppColor.grey2,
                height: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
