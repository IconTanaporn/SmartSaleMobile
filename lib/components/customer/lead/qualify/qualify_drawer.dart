import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/common/key_model.dart';
import '../../../../route/router.dart';
import '../../../../screens/project/leads/lead/lead_page.dart';
import '../../../../screens/project/project_page.dart';
import '../../../../utils/utils.dart';
import '../../../common/loading/loading.dart';
import '../../../common/text/text.dart';
import '../../walk_in/contacts_dialog.dart';

final _qualifyListProvider = FutureProvider((ref) async {
  List list = await ApiController.leadQualifyList();
  return list
      .map((item) => KeyModel(id: item['id'], name: item['name']))
      .toList();
});

class QualifyInput {
  final String id, remark;
  final bool isQualify;
  QualifyInput({this.id = '', this.remark = '', this.isQualify = true});
}

final _updateQualifyProvider =
    FutureProvider.family<dynamic, QualifyInput>((ref, input) async {
  try {
    IconFrameworkUtils.startLoading();

    final lead = ref.read(leadProvider);
    final data = await ApiController.leadQualifyUpdate(
      lead.id,
      input.id,
      input.remark,
    );

    IconFrameworkUtils.stopLoading();

    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('common.alert.save_complete'),
    );

    if (input.isQualify && data['id'] is String) {
      return data['id'];
    } else {
      return true;
    }
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();

    if (e.isDuplicate()) {
      if (!input.isQualify) {
        return true;
      } else {
        final value = await showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return DupContactsDialog(
              list: e.body
                  .map((data) => DupContact(
                        data['id'] ?? '',
                        data['name'] ?? '',
                        mobile: data['mobile'] ?? '',
                        email: data['email'] ?? '',
                        citizenId: data['citizen_id'] ?? '',
                        passportId: data['passport_id'] ?? '',
                      ))
                  .toList(),
            );
          },
        );

        if (value is DupContact) {
          DupContact dupContact = value;
          return dupContact.id;
        } else {
          return true;
        }
      }
    } else {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.fail'),
        detail: e.message,
      );
    }
  }
});

class QualifyDrawer extends ConsumerWidget {
  const QualifyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    final qualifyList = ref.watch(_qualifyListProvider);

    onRefresh() {
      return ref.refresh(_qualifyListProvider);
    }

    Future toLeadList() async {
      context.router
          .popUntil((route) => route.settings.name == LeadListRoute.name);
    }

    Future toContactDetail(id) async {
      final project = ref.read(projectProvider);
      context.router
          .popUntil((route) => route.settings.name == LeadListRoute.name);
      context.router.navigateNamed('/project/${project.id}/contact/$id');
    }

    Future onUpdateQualify(
      String qualifyId,
      String remark,
      bool isQualify,
    ) async {
      final response = await ref.read(_updateQualifyProvider(QualifyInput(
        id: qualifyId,
        remark: remark,
        isQualify: isQualify,
      )).future);

      if (response is String) {
        await toContactDetail(response);
      } else {
        if (response == true) {
          await toLeadList();
        }
      }
    }

    Future onQualify(KeyModel key) async {
      String keyName = key.name.toLowerCase();
      String name = Language.translate('screen.lead.qualify.status.$keyName');

      if (keyName == 'qualify') {
        final value = await IconFrameworkUtils.showConfirmDialog(
          title: Language.translate(
            'screen.lead.qualify.alert.confirm_status',
            translationParams: {'status': name},
          ),
        );
        if (value == AlertDialogValue.confirm) {
          onUpdateQualify(key.id, '', true);
        }
      } else {
        TextEditingController input = TextEditingController();

        final value = await IconFrameworkUtils.showTextAreaDialog(
          controller: input,
          title: Language.translate(
            'screen.lead.qualify.alert.confirm_status',
            translationParams: {'status': name},
          ),
          inputLabel:
              Language.translate('screen.lead.qualify.input.reason.label'),
        );

        if (value == AlertDialogValue.confirm) {
          onUpdateQualify(key.id, input.text, false);
        }
      }
    }

    return Drawer(
      child: SafeArea(
        left: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: CustomText(
                Language.translate('screen.lead.qualify.title'),
                fontSize: FontSize.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: AppColor.grey5,
                thickness: 1,
                height: 1,
              ),
            ),
            qualifyList.when(
              error: (err, stack) => IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(8),
                child: Loading(),
              ),
              data: (data) {
                return Column(
                  children: data
                      .map((key) => ListTile(
                            title: CustomText(
                              Language.translate(
                                'screen.lead.qualify.status.${key.name.toLowerCase()}',
                              ),
                              fontSize: FontSize.title,
                            ),
                            onTap: () => onQualify(key),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
