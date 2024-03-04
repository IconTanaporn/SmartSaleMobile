import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'contact_page.dart';

final _projectProvider = StateProvider.autoDispose<KeyModel?>((ref) => null);

final _projectListProvider = FutureProvider<List<KeyModel>>((ref) async {
  List list = await ApiController.opportunityList();

  return list
      .map((e) => KeyModel(id: e['project_id'], name: e['project_name']))
      .toList();
});

final _initProjectProvider =
    FutureProvider.autoDispose.family<void, String>((ref, id) async {
  var list = ref.watch(_projectListProvider).value;

  if (list != null && list.isNotEmpty) {
    var project = list.firstWhereOrNull((e) => e.id == id);
    if (project != null) {
      await IconFrameworkUtils.delayed(milliseconds: 100);
      ref.read(_projectProvider.notifier).state = project;
    }
  }
});

class CreateOppInput {
  final String contactId, budget, comment;

  CreateOppInput({
    this.contactId = '',
    this.budget = '',
    this.comment = '',
  });
}

final _createOpportunityProvider =
    FutureProvider.autoDispose.family<bool, CreateOppInput>((ref, input) async {
  final project = ref.read(_projectProvider);

  try {
    IconFrameworkUtils.startLoading();
    await ApiController.opportunityCreate(
      input.contactId,
      project?.id,
      input.budget,
      input.comment,
    );
    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('common.alert.save_complete'),
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
class AddOpportunityPage extends ConsumerWidget {
  AddOpportunityPage({
    @PathParam.inherit('projectId') this.projectId = '',
    @PathParam.inherit('id') this.contactId = '',
    super.key,
  });

  final String projectId, contactId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _budget = TextEditingController();
  final TextEditingController _comment = TextEditingController();

  @override
  Widget build(context, ref) {
    final projectList = ref.watch(_projectListProvider);
    ref.watch(_initProjectProvider(projectId));
    final project = ref.watch(_projectProvider);

    onSave() async {
      if (_formKey.currentState!.validate()) {
        final success =
            await ref.read(_createOpportunityProvider(CreateOppInput(
          contactId: contactId,
          budget: _budget.text,
          comment: _comment.text,
        )).future);

        if (success) {
          context.router.pop();
          return ref.refresh(oppListProvider(contactId));
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
          Language.translate('screen.opportunity.create.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        Language.translate(
                            'screen.opportunity.create.sub_title'),
                        color: AppColor.red,
                        fontSize: FontSize.title,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InputDropdown(
                    labelText: Language.translate('module.opportunity.project'),
                    value: project,
                    items: projectList.value ?? [],
                    isLoading: projectList.isLoading,
                    onChanged: (value) =>
                        ref.read(_projectProvider.notifier).state = value,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    labelText: Language.translate('module.opportunity.budget'),
                    controller: _budget,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  InputTextArea(
                    controller: _comment,
                    labelText: Language.translate('module.opportunity.comment'),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: IconFrameworkUtils.getWidth(0.45),
                    child: CustomButton(
                      onClick: onSave,
                      text: Language.translate('common.save'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
