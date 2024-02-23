import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/screens/project/leads/lead/lead_page.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../config/language.dart';
import '../../../../models/common/key_model.dart';
import '../../../../utils/utils.dart';

final sourceListProvider = FutureProvider<List<KeyModel>>((ref) async {
  List list = await ApiController.sourceListLead();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final sourcesProvider = Provider.autoDispose<KeyModel?>((ref) {
  final lead = ref.read(leadProvider);
  final sources = ref.watch(sourceListProvider).value;

  if (sources != null) {
    final source = sources.firstWhere(
      (e) => e.name == lead.source,
      orElse: () => KeyModel(),
    );
    if (source.id != '') return source;
  }

  return null;
});

final sourceProvider = StateProvider.autoDispose<KeyModel?>((ref) {
  return ref.watch(sourcesProvider);
});

class UpdateData {
  final String id, firstName, lastName;
  final String mobile, lineId, email;

  UpdateData({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.mobile = '',
    this.lineId = '',
    this.email = '',
  });
}

final _updateProvider = FutureProvider.autoDispose
    .family<bool, UpdateData>((ref, updateData) async {
  final source = ref.read(sourceProvider);

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
      'Edit Opportunity',
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
    final String label = Language.translate('module.contact.$key');
    final String errorText = Language.translate(
      'common.input.validate.default_validate',
      translationParams: {'label': label},
    );

    if (key == 'firstname' || key == 'lastname') {
      if (!IconFrameworkUtils.validateName(value)) {
        return errorText;
      }
    }
    if (key == 'mobile') {
      if (!IconFrameworkUtils.validatePhoneNumber(value)) {
        return errorText;
      }
    }
    if (key == 'email') {
      if (!IconFrameworkUtils.validateEmail(value)) {
        return errorText;
      }
    }

    return null;
  }

  @override
  Widget build(context, ref) {
    final lead = ref.watch(leadProvider);
    final sourceList = ref.watch(sourceListProvider);
    final source = ref.watch(sourceProvider);

    final TextEditingController firstname = TextEditingController(
      text: lead.firstName,
    );
    final TextEditingController lastname = TextEditingController(
      text: lead.lastName,
    );
    final TextEditingController mobile = TextEditingController(
      text: lead.mobile,
    );
    final TextEditingController email = TextEditingController(
      text: lead.email,
    );
    final TextEditingController lineId = TextEditingController(
      text: lead.lineId,
    );

    Future onSave() async {
      if (_formKey.currentState!.validate()) {
        final isSuccess = await ref.read(_updateProvider(UpdateData(
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
                    const SizedBox(height: 10),
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
                          ref.read(sourceProvider.notifier).state = v,
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
