import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/screens/project/leads/lead/lead_page.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/common/key_model.dart';
import '../../../../models/lead.dart';
import '../../../../providers/master_data/customer_provider.dart';
import '../../../../utils/utils.dart';

final _sourceProvider = StateProvider.autoDispose<KeyModel?>((ref) => null);

final _initProvider = FutureProvider.autoDispose((ref) async {
  await IconFrameworkUtils.delayed(milliseconds: 0);
  final lead = ref.read(leadProvider);

  final sourceList = await ref.read(sourceListProvider.future);
  ref.read(_sourceProvider.notifier).state = sourceList.firstWhereOrNull(
    (e) => e.name == lead.source,
  );
});

final _updateProvider = FutureProvider.autoDispose
    .family<bool, LeadDetail>((ref, updateData) async {
  final source = ref.read(_sourceProvider);

  IconFrameworkUtils.startLoading();
  try {
    await ApiController.leadUpdate({
      'id': updateData.id,
      'firstname': updateData.firstName,
      'lastname': updateData.lastName,
      'mobile': updateData.mobile,
      'line_id': updateData.lineId,
      'email': updateData.email,
      'source_id': source?.id ?? '',
      'source_name': source?.name ?? '',
    });

    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('common.alert.save_complete'),
    );
    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.fail'),
      detail: e.message,
    );
    IconFrameworkUtils.log(
      'Edit Lead',
      'Update Provider',
      e.message,
    );
  }
  return false;
});

@RoutePage()
class EditLeadPage extends ConsumerWidget {
  EditLeadPage({
    @PathParam.inherit('id') this.leadId = '',
    super.key,
  });

  final String leadId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validate(key, value) {
    return IconFrameworkUtils.contactValidate(key, value);
  }

  @override
  Widget build(context, ref) {
    ref.watch(_initProvider);
    final lead = ref.watch(leadProvider);

    final sourceList = ref.watch(sourceListProvider);
    final source = ref.watch(_sourceProvider);

    final firstname = TextEditingController(text: lead.firstName);
    final lastname = TextEditingController(text: lead.lastName);
    final mobile = TextEditingController(text: lead.mobile);
    final email = TextEditingController(text: lead.email);
    final lineId = TextEditingController(text: lead.lineId);

    Future onSave() async {
      if (_formKey.currentState!.validate()) {
        final isSuccess = await ref.read(_updateProvider(LeadDetail(
          id: leadId,
          firstName: firstname.text,
          lastName: lastname.text,
          mobile: mobile.text,
          lineId: lineId.text,
          email: email.text,
        )).future);

        if (isSuccess) {
          context.router.pop();
          return ref.refresh(leadDetailProvider(leadId));
        }
      } else {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.alert'),
          detail: Language.translate('common.input.alert.check_validate'),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.lead.edit.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          Language.translate('screen.lead.edit.sub_title'),
                          color: AppColor.red,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InputText(
                      controller: firstname,
                      labelText: Language.translate('module.contact.firstname'),
                      validator: (value) => validate('firstname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: lastname,
                      labelText: Language.translate('module.contact.lastname'),
                      validator: (value) => validate('lastname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      controller: mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: lineId,
                      labelText: Language.translate('module.contact.line'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      labelText: Language.translate('module.contact.email'),
                    ),
                    const SizedBox(height: 15),
                    InputDropdown(
                      labelText: Language.translate('module.contact.source'),
                      value: source,
                      items: sourceList.value ?? [],
                      isLoading: sourceList.isLoading,
                      onChanged: (v) =>
                          ref.read(_sourceProvider.notifier).state = v,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: IconFrameworkUtils.getWidth(0.45),
                        child: CustomButton(
                          onClick: onSave,
                          text: Language.translate('common.save'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
