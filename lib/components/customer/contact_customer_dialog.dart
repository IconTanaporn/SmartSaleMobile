import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/screens/project/contacts/contact/contact_page.dart';
import 'package:smart_sale_mobile/screens/project/leads/lead/lead_page.dart';
import 'package:smart_sale_mobile/screens/project/opportunities/opportunity/opportunity_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/constant.dart';
import '../../../utils/utils.dart';
import '../../api/api_client.dart';
import '../../api/api_controller.dart';
import '../../config/asset_path.dart';
import '../../config/language.dart';
import '../../screens/project/project_page.dart';
import '../common/text/text.dart';

class CreateActivityInput {
  final String stage, type, refId;
  CreateActivityInput({
    this.refId = '',
    this.stage = '',
    this.type = '',
  });
}

final createActivityByTypeProvider =
    FutureProvider.family<bool, CreateActivityInput>((ref, input) async {
  final project = ref.read(projectProvider);

  try {
    IconFrameworkUtils.startLoading();
    await ApiController.createActivityByType(
      project.id,
      input.stage,
      input.type,
      input.refId,
    );

    IconFrameworkUtils.stopLoading();
    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showError(e.message);
  }

  return false;
});

class ContactCustomerDialog extends ConsumerWidget {
  final String? line, email, tel, stage, refId;
  final Function()? onEmpty;

  const ContactCustomerDialog({
    Key? key,
    this.line,
    this.email,
    this.tel,
    this.stage = '',
    this.refId = '',
    this.onEmpty,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    Future createActivity(type) async {
      bool isSuccess =
          await ref.read(createActivityByTypeProvider(CreateActivityInput(
        refId: refId ?? '',
        stage: stage.toString().characters.first ?? '',
        type: type,
      )).future);
      if (isSuccess) {
        switch (stage) {
          case 'contact':
            return ref.refresh(contactDetailProvider(refId ?? ''));
          case 'lead':
            return ref.refresh(leadDetailProvider(refId ?? ''));
          case 'opportunity':
            return ref.refresh(opportunityDetailProvider(refId ?? ''));
        }
      }
    }

    Future alertOnEmpty(String label) async {
      if (onEmpty == null) {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate(
            'module.contact.contact_customer.alert.no_$label',
          ),
        );
      } else {
        final value = await IconFrameworkUtils.showConfirmDialog(
          title: Language.translate(
            'module.contact.contact_customer.alert.no_$label',
          ),
        );
        if (value == AlertDialogValue.confirm) {
          onEmpty!();
        }
      }
    }

    Future onPressLine() async {
      if (line == '') {
        await alertOnEmpty('line');
      } else {
        final Uri lineUri = Uri(
          scheme: 'https',
          path: 'line.me/R/ti/p/~$line',
        );

        if (await canLaunchUrl(lineUri)) {
          await launchUrl(lineUri, mode: LaunchMode.externalApplication);
          await createActivity('line');
        } else {
          IconFrameworkUtils.showAlertDialog(
            title: Language.translate('common.alert.fail'),
            detail: 'Can not launch line.',
          );
        }
      }
    }

    Future onPressEmail() async {
      if (email == '') {
        await alertOnEmpty('email');
      } else {
        try {
          final Email mail = Email(
            recipients: [email!],
          );
          await FlutterEmailSender.send(mail);
          await createActivity('email');
        } catch (e) {
          IconFrameworkUtils.showAlertDialog(
            title: Language.translate('common.alert.fail'),
            detail: 'Can not launch email.',
          );
        }
      }
    }

    Future onPressTel() async {
      if (tel == '') {
        await alertOnEmpty('tel');
      } else {
        Uri telUri = Uri(scheme: 'tel', path: tel);

        if (await canLaunchUrl(telUri)) {
          await launchUrl(telUri);
          await createActivity('callout');
        } else {
          IconFrameworkUtils.showAlertDialog(
            title: Language.translate('common.alert.fail'),
            detail: 'Can not launch phone.',
          );
        }
      }
    }

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      content: SizedBox(
        width: IconFrameworkUtils.getWidth(0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: AppColor.grey4,
                child: IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    context.router.pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: AppColor.white,
                    size: 15,
                  ),
                ),
              ),
            ),
            CustomText(
              Language.translate('module.contact.contact_customer.title'),
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (line != null)
                  buttonContact(
                    context,
                    const Image(
                      image: AssetImage(AssetPath.lineLogo),
                      fit: BoxFit.fill,
                    ),
                    title: Language.translate(
                      'module.contact.contact_customer.line',
                    ),
                    onPressed: onPressLine,
                    color: Colors.green,
                  ),
                if (email != null)
                  buttonContact(
                    context,
                    const Icon(
                      Icons.email,
                      color: Colors.white,
                      size: 24,
                    ),
                    title: Language.translate(
                      'module.contact.contact_customer.email',
                    ),
                    color: AppColor.blue,
                    onPressed: onPressEmail,
                  ),
                if (tel != null)
                  buttonContact(
                    context,
                    const Icon(
                      Icons.phone,
                      color: AppColor.white,
                      size: 24,
                    ),
                    title: Language.translate(
                      'module.contact.contact_customer.telephone',
                    ),
                    color: AppColor.red,
                    onPressed: onPressTel,
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget buttonContact(
    context,
    Widget icon, {
    String title = '',
    void Function()? onPressed,
    Color? color,
  }) {
    const double radius = 10;
    const double size = 40;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(radius)),
                color: color ?? AppColor.red,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: icon,
            ),
            SizedBox(
              width: size,
              height: size,
              child: Material(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(radius)),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(radius)),
                  onTap: onPressed,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomText(title),
      ],
    );
  }
}
