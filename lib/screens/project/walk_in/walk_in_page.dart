import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/input.dart';
import '../../../config/constant.dart';
import '../../../utils/utils.dart';

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
    onSave() {
      if (_formKey.currentState?.validate() ?? false) {
        // print(prefix?.name);
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
                    const SizedBox(height: 10),
                    InputText(
                      controller: _lastname,
                      labelText: Language.translate('module.contact.lastname'),
                      validator: (value) => validate('lastname', value),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      controller: _mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      labelText: Language.translate('module.contact.email'),
                      validator: (value) => validate('email', value),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.6),
                      child: CustomButton(
                        text: Language.translate('common.save'),
                        onClick: onSave,
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
