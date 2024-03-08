import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/default_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import '../../contacts/contact/contact_page.dart';
import 'opportunity_page.dart';

class UpdateData {
  final String id, budget, comment;
  UpdateData({
    this.id = '',
    this.budget = '',
    this.comment = '',
  });
}

final _updateProvider = FutureProvider.autoDispose
    .family<bool, UpdateData>((ref, updateData) async {
  final data = ref.read(opportunityProvider);

  IconFrameworkUtils.startLoading();
  try {
    await ApiController.opportunityUpdate(
      updateData.id,
      data.oppName,
      data.projectId,
      data.contactId,
      updateData.budget,
      updateData.comment,
    );
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
class EditOpportunityPage extends ConsumerWidget {
  EditOpportunityPage({
    @PathParam.inherit('id') this.oppId = '',
    super.key,
  });

  final String oppId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(context, ref) {
    final opportunity = ref.watch(opportunityProvider);
    final TextEditingController budget = TextEditingController(
      text: opportunity.budget ?? '',
    );
    final TextEditingController comment = TextEditingController(
      text: opportunity.comment ?? '',
    );

    onSave() async {
      if (_formKey.currentState!.validate()) {
        final isSuccess = await ref.read(_updateProvider(UpdateData(
          id: oppId,
          budget: budget.text,
          comment: comment.text,
        )).future);

        if (isSuccess) {
          context.router.pop();
          if (opportunity.contactId != '') {
            ref.refresh(oppListProvider(opportunity.contactId));
          }
          return ref.refresh(opportunityDetailProvider(oppId));
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
          Language.translate('screen.opportunity.edit.title'),
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
                          Language.translate(
                              'screen.opportunity.edit.sub_title'),
                          color: AppColor.red,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InputText(
                      labelText:
                          Language.translate('module.opportunity.project'),
                      initialValue: opportunity.projectName,
                      disabled: true,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      labelText:
                          Language.translate('module.opportunity.budget'),
                      controller: budget,
                      keyboardType: TextInputType.number,
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputTextArea(
                      controller: comment,
                      labelText:
                          Language.translate('module.opportunity.comment'),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: IconFrameworkUtils.getWidth(0.6),
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
