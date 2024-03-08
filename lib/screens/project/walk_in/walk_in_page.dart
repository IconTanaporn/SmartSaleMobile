import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/api/api_controller.dart';
import 'package:smart_sale_mobile/components/common/alert/dialog.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../../api/api_client.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/input.dart';
import '../../../components/customer/walk_in/contacts_dialog.dart';
import '../../../config/constant.dart';
import '../../../route/router.dart';
import '../../../utils/utils.dart';

class CreateContactInput {
  final String firstname, lastname, mobile, email, source;

  CreateContactInput(
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.source,
  );
}

class CreateContactResponse {
  final String? customerId, oppId;
  final List? dup;

  CreateContactResponse({this.customerId, this.oppId, this.dup});
}

final _createContactProvider = FutureProvider.autoDispose
    .family<CreateContactResponse?, CreateContactInput>((ref, input) async {
  try {
    IconFrameworkUtils.startLoading();
    final data = await ApiController.quickCreateContact(input.firstname,
        input.lastname, input.mobile, input.email, input.source);
    IconFrameworkUtils.stopLoading();

    return CreateContactResponse(
      customerId: data['id'],
      oppId: data['opp_id'],
    );
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();

    if (e.isDuplicate()) {
      return CreateContactResponse(
        dup: e.body,
      );
    } else {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.save_fail'),
        detail: e.message,
      );
    }
  }
});

final _questionnaireProvider = FutureProvider.autoDispose
    .family<dynamic, CreateContactResponse>((ref, input) async {
  final data = await ApiController.questionnaire(
      contactId: input.customerId, oppId: input.oppId);
  return data['questionnaire_url'];
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

  @override
  Widget build(context, ref) {
    Future onSave() async {
      if (_formKey.currentState?.validate() ?? false) {
        final firstname = _firstname.text.trim();
        final lastname = _lastname.text.trim();
        final mobile = _mobile.text.trim();
        final email = _email.text.trim();

        // final source = await selectSourceType();
        // String source = 'walkin';
        final source = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomAlertDialog();
          },
        );
        if (source != AlertDialogValue.cancel) {
          final CreateContactResponse? response =
              await ref.watch(_createContactProvider(CreateContactInput(
            firstname,
            lastname,
            mobile,
            email,
            source,
          )).future);

          if (response?.customerId != null) {
            final url =
                await ref.read(_questionnaireProvider(response!).future);

            if (url != null) {
              await context.router.push(QRRoute(
                url: url,
                title: Language.translate('module.project.questionnaire.title'),
                detail: '$firstname $lastname',
                isPreview: true,
              ));
            }

            context.navigateNamedTo(
              '/project/$projectId/contact/${response.customerId}',
            );
          }

          if (response?.dup != null) {
            final value = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return DupContactsDialog(
                  list: response!.dup!
                      .map((e) => DupContact(
                            e['id'] ?? '',
                            e['name'] ?? '',
                            mobile: e['mobile'] ?? '',
                            email: e['email'] ?? '',
                            citizenId: e['citizen_id'] ?? '',
                            passportId: e['passport_id'] ?? '',
                          ))
                      .toList(),
                );
              },
            );

            if (value is DupContact) {
              DupContact dupContact = value;
              context.router
                  .pushNamed('/project/$projectId/contact/${dupContact.id}');
            }
          }
        }
      } else {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.alert'),
          detail: Language.translate('common.input.alert.check_validate'),
        );
      }
    }

    onReset() {
      _firstname.clear();
      _lastname.clear();
      _mobile.clear();
      _email.clear();
      _formKey.currentState!.reset();
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
