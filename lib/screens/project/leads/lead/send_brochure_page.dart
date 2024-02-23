import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/api/api_client.dart';
import 'package:smart_sale_mobile/screens/project/leads/lead/lead_page.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/button/button.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'brochure_page.dart';

class SendBrochure {
  final List<Brochure> list;
  final String email;
  SendBrochure(this.list, this.email);
}

final sendBrochureProvider =
    FutureProvider.autoDispose.family<bool, SendBrochure>((ref, input) async {
  try {
    IconFrameworkUtils.startLoading();
    await ApiController.brochureSend(input.list.first.id, input.email);
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('screen.brochure.alert.success'),
    );
    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.fail'),
      detail: e.toString(),
    );
  }

  return false;
});

@RoutePage()
class SendBrochurePage extends ConsumerWidget {
  const SendBrochurePage({
    @PathParam.inherit('id') this.referenceId = '',
    @PathParam.inherit('stage') this.stage = '',
    @PathParam.inherit('projectId') this.projectId = '',
    super.key,
  });

  final String referenceId;
  final String stage;
  final String projectId;

  @override
  Widget build(context, ref) {
    final selected = ref.watch(selectedBrochureProvider);

    final customer = ref.watch(stage == 'lead' ? leadProvider : leadProvider);

    final TextEditingController email = TextEditingController(
      text: customer.email,
    );

    onSend() async {
      final success = await ref.read(sendBrochureProvider(
        SendBrochure(selected, email.text),
      ).future);

      if (success) {
        context.router.pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.brochure.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                Language.translate('screen.brochure.email'),
                fontSize: FontSize.title,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              InputText(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                labelText:
                    Language.translate('screen.brochure.input.email.label'),
                errorText: email.text.isNotEmpty
                    ? null
                    : Language.translate('screen.brochure.input.email.error'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.45),
                child: CustomButton(
                  onClick: onSend,
                  text: Language.translate('common.confirm'),
                  disable: email.text.isEmpty,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
