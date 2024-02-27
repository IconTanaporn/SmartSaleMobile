import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';

final statusProvider = StateProvider<KeyModel>((ref) => KeyModel());
final reasonProvider = StateProvider<KeyModel>((ref) => KeyModel());

final statusListProvider = FutureProvider<List<KeyModel>>((ref) async {
  List list = await ApiController.closeJobStatusList();
  List<KeyModel> status = list
      .map((e) => KeyModel(
            id: e['id'],
            name: e['name'],
          ))
      .toList();
  ref.read(statusProvider.notifier).state = status.last;
  return status;
});

final reasonListProvider = FutureProvider<List<KeyModel>>((ref) async {
  KeyModel status = ref.watch(statusProvider);
  if (status.id == '') {
    return [];
  }
  List list = await ApiController.closeJobReasonList(status.id);
  List<KeyModel> reasons = list
      .map((e) => KeyModel(
            id: e['id'],
            name: e['name'],
          ))
      .toList();
  ref.read(reasonProvider.notifier).state = reasons.first;

  return reasons;
});

@RoutePage()
class OpportunityCloseJobPage extends ConsumerWidget {
  OpportunityCloseJobPage({
    @PathParam.inherit('id') this.oppId = '',
    super.key,
  });

  final String oppId;
  final TextEditingController _comment = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(context, ref) {
    final statusList = ref.watch(statusListProvider);
    final reasonList = ref.watch(reasonListProvider);
    final status = ref.watch(statusProvider);
    final reason = ref.watch(reasonProvider);

    onRefresh() {
      return ref.refresh(statusListProvider);
    }

    setReason(v) {
      ref.read(reasonProvider.notifier).state = v;
    }

    onSave() async {
      if (_formKey.currentState!.validate()) {
        bool isSuccess = false;
        // final isSuccess = await ref.read(_updateProvider(UpdateData(
        //   id: oppId,
        //   budget: budget.text,
        //   comment: comment.text,
        // )).future);

        if (isSuccess) {
          // context.router.pop();
          // if (opportunity.value?.contactId != '') {
          //   ref.refresh(oppListProvider(opportunity.value!.contactId));
          // }
          // return ref.refresh(opportunityProvider(oppId));
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
          Language.translate('screen.opportunity.close_job.title'),
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
                  children: [
                    Row(
                      children: [
                        CustomText(
                          '${Language.translate('module.opportunity.status')} :',
                          color: AppColor.blue,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEB5757).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: statusList.when(
                            error: (err, stack) => IconButton(
                              onPressed: onRefresh,
                              icon: const Icon(Icons.refresh),
                            ),
                            loading: () => const Loading(size: 10),
                            data: (data) {
                              if (status.name == '') {
                                return const Loading(size: 10);
                              }

                              return Row(
                                children: [
                                  Image.asset(
                                    AssetPath.iconCloseJob,
                                    color: const Color(0xFFEB5757),
                                    height: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    status.name,
                                    color: const Color(0xFFEB5757),
                                    fontSize: FontSize.normal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    InputDropdown(
                      labelText: Language.translate(
                          'module.opportunity.close_job.reason'),
                      value: reason,
                      items: reasonList.value ?? [],
                      onChanged: setReason,
                      isLoading: reasonList.isLoading,
                    ),
                    const SizedBox(height: 15),
                    InputTextArea(
                      controller: _comment,
                      labelText:
                          Language.translate('module.opportunity.comment'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.6),
                      child: CustomButton(
                        onClick: onSave,
                        text: Language.translate('common.save'),
                      ),
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
