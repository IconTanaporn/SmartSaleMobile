import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/api/api_controller.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:smart_sale_mobile/screens/project/project_page.dart';
import 'package:smart_sale_mobile/screens/project/walk_in/walk_in_tab.dart';

import '../../../api/api_client.dart';
import '../../../components/common/background/default_background.dart';
import '../../../components/common/input/input.dart';
import '../../../components/customer/walk_in/contacts_dialog.dart';
import '../../../components/customer/walk_in/source_dialog.dart';
import '../../../config/constant.dart';
import '../../../route/router.dart';
import '../../../utils/utils.dart';

class _Input {
  final String firstname, lastname, mobile, email, source;

  _Input(
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.source,
  );
}

final _createContactProvider = FutureProvider.autoDispose
    .family<CreateContactResponse, _Input>((ref, input) async {
  try {
    IconFrameworkUtils.startLoading();

    final project = ref.read(projectProvider);
    final data = await ApiController.quickCreateContact(
      project.id,
      input.firstname,
      input.lastname,
      input.mobile,
      input.email,
      input.source,
    );

    IconFrameworkUtils.stopLoading();
    return CreateContactResponse(
      customerId: IconFrameworkUtils.getValue(data, 'id'),
      oppId: IconFrameworkUtils.getValue(data, 'opp_id'),
      isSuccess: true,
    );
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();

    if (!e.isDuplicate()) {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.save_fail'),
        detail: e.message,
      );
    }

    return CreateContactResponse(
      duplicateList: e.body,
      isSuccess: false,
    );
  }
});

@RoutePage()
class WalkInPage extends ConsumerWidget {
  WalkInPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();

  String? validate(key, value) {
    return IconFrameworkUtils.contactValidate(key, value);
  }

  onReset() {
    _firstname.clear();
    _lastname.clear();
    _mobile.clear();
    _email.clear();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(context, ref) {
    toContact(id) {
      context.navigateNamedTo('/project/$projectId/contact/$id');
    }

    Future onSuccess(firstname, lastname, id, oppId) async {
      final url = await ref
          .read(questionnaireProvider(QuestionnaireInput(id, oppId)).future);

      if (url != null) {
        await context.router.push(QRRoute(
          url: url,
          title: Language.translate('module.project.questionnaire.title'),
          detail: '$firstname $lastname',
          isPreview: true,
        ));
      }

      toContact(id);
    }

    Future onDuplicate(List list) async {
      final value = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DupContactsDialog(
            list: list
                .map((e) => DupContact(
                      IconFrameworkUtils.getValue(e, 'id'),
                      IconFrameworkUtils.getValue(e, 'name'),
                      mobile: IconFrameworkUtils.getValue(e, 'mobile'),
                      email: IconFrameworkUtils.getValue(e, 'email'),
                      citizenId: IconFrameworkUtils.getValue(e, 'citizen_id'),
                      passportId: IconFrameworkUtils.getValue(e, 'passport_id'),
                    ))
                .toList(),
          );
        },
      );

      if (value is DupContact) {
        toContact(value.id);
      }
    }

    Future onCreateContact(String source) async {
      final firstname = _firstname.text.trim();
      final lastname = _lastname.text.trim();

      final response = await ref.watch(_createContactProvider(_Input(
        firstname,
        lastname,
        _mobile.text.trim(),
        _email.text.trim(),
        source,
      )).future);

      if (response.isSuccess) {
        onReset();
        await onSuccess(
          firstname,
          lastname,
          response.customerId,
          response.oppId,
        );
      } else if (response.duplicateList.isNotEmpty) {
        onReset();
        await onDuplicate(response.duplicateList);
      }
    }

    Future onSave() async {
      if (_formKey.currentState?.validate() ?? false) {
        final source = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const SelectSourceDialog();
          },
        );

        if (source != AlertDialogValue.cancel) {
          await onCreateContact(source);
        }
      } else {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.alert'),
          detail: Language.translate('common.input.alert.check_validate'),
        );
      }
    }

    return Scaffold(
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          Language.translate('screen.walk_in.sub_title'),
                          color: AppColor.red,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InputText(
                      controller: _firstname,
                      labelText: Language.translate('module.contact.firstname'),
                      validator: (value) => validate('firstname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _lastname,
                      labelText: Language.translate('module.contact.lastname'),
                      validator: (value) => validate('lastname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      controller: _mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      labelText: Language.translate('module.contact.email'),
                      validator: (value) => validate('email', value),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: IconFrameworkUtils.getWidth(0.3),
                          child: CustomButton(
                            text: Language.translate('common.cancel'),
                            backgroundColor: AppColor.grey,
                            borderColor: AppColor.grey,
                            onClick: onReset,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: IconFrameworkUtils.getWidth(0.3),
                          child: CustomButton(
                            text: Language.translate('common.save'),
                            onClick: onSave,
                          ),
                        )
                      ],
                    ),
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
