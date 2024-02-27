import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/customer/contact_customer_dialog.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'contact_page.dart';

final questionnaireProvider =
    FutureProvider.autoDispose.family<String, String>((ref, contactId) async {
  var data = await ApiController.questionnaire(contactId: contactId);
  return data['questionnaire_url'];
});

@RoutePage(name: 'ContactTab')
class ContactTapPage extends ConsumerWidget {
  const ContactTapPage({super.key});

  @override
  Widget build(context, ref) {
    final contact = ref.watch(contactProvider);

    toEditContact() {
      context.router.pushNamed('/contact/${contact.id}/edit');
    }

    toQuestionnaire() async {
      IconFrameworkUtils.startLoading();
      final url = await ref.read(questionnaireProvider(contact.id).future);
      IconFrameworkUtils.stopLoading();

      context.router.push(QRRoute(
        url: url,
        title: Language.translate('module.project.questionnaire.title'),
        detail: '${contact.firstName} ${contact.lastName}',
      ));
    }

    onContactCustomer() async {
      await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ContactCustomerDialog(
            line: contact.lineId,
            email: contact.email,
            tel: contact.mobile,
            stage: 'contact',
            refId: contact.id,
            onEmpty: toEditContact,
          );
        },
      );
    }

    return AutoTabsScaffold(
      routes: [
        ContactRoute(),
        ActivityLogRoute(),
        BrochureRoute(stage: 'contact'),
      ],
      transitionBuilder: (context, child, animation) => child,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (i) {
            switch (i) {
              case 3:
                toQuestionnaire();
                break;
              case 4:
                onContactCustomer();
                break;
              default:
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
              label: Language.translate('screen.project.menu.contact'),
              icon: Image.asset(
                AssetPath.iconLead,
                color: (tabsRouter.activeIndex == 0)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.contact.menu.activity_log'),
              icon: Image.asset(
                AssetPath.iconActivityLog,
                color: (tabsRouter.activeIndex == 1)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.contact.menu.brochure'),
              icon: Image.asset(
                AssetPath.iconBrochure,
                color: (tabsRouter.activeIndex == 2)
                    ? AppColor.blue
                    : AppColor.grey2,
                height: 20,
              ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.contact.menu.questionnaire'),
              icon: contact.id == ''
                  ? const Loading(size: 20)
                  : Image.asset(
                      AssetPath.iconQuestionnaire,
                      color: AppColor.grey2,
                      height: 20,
                    ),
            ),
            BottomNavigationBarItem(
              label: Language.translate('screen.contact.menu.contact_customer'),
              icon: contact.id == ''
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
