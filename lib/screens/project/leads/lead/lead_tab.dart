import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../../../../components/common/loading/loading.dart';
import '../../../../components/customer/contact_customer_dialog.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'lead_page.dart';

@RoutePage(name: 'LeadTab')
class LeadTapPage extends ConsumerWidget {
  const LeadTapPage({super.key});

  @override
  Widget build(context, ref) {
    final lead = ref.watch(leadProvider);

    toEditLead() {
      context.router.pushNamed('/lead/${lead.id}/edit');
    }

    onContactCustomer() async {
      await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ContactCustomerDialog(
            line: lead.lineId,
            email: lead.email,
            tel: lead.mobile,
            stage: 'lead',
            refId: lead.id,
            onEmpty: toEditLead,
          );
        },
      );
    }

    return AutoTabsScaffold(
      routes: [
        LeadRoute(),
        CalendarRoute(),
        ActivityLogRoute(),
        BrochureRoute(stage: 'lead'),
      ],
      transitionBuilder: (context, child, animation) => child,
      bottomNavigationBuilder: (context, tabsRouter) {
        bool isLoading = lead.id == '';
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (i) {
            if (i == 4) {
              if (!isLoading) {
                onContactCustomer();
              }
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
              icon: isLoading
                  ? const Loading(size: 20)
                  : Image.asset(
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
