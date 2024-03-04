import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/opportunity/progress/progress_bar.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'opportunity_page.dart';

final selectedProvider = StateProvider<int>((ref) => -1);

class Progress {
  final String id;
  final String name;
  final double percent;
  final bool isCheck;

  Progress(
    this.id,
    this.name,
    this.percent,
    this.isCheck,
  );
}

final progressProvider =
    FutureProvider.autoDispose.family<List<Progress>, String>((ref, id) async {
  List list = await ApiController.opportunityProcessList(id);
  return list
      .map((data) => Progress(
            IconFrameworkUtils.getValue(data, 'id'),
            IconFrameworkUtils.getValue(data, 'name'),
            IconFrameworkUtils.getNumber(data, 'percent'),
            data['ischeck'] ?? false,
          ))
      .toList();
});

final _updateProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, id) async {
  try {
    final opp = ref.read(opportunityProvider);

    await ApiController.opportunityProcessUpdate(opp.oppId, id);

    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    IconFrameworkUtils.showError(e.message);
    IconFrameworkUtils.log(
      'Opportunity Progress',
      'Update Provider',
      e.message,
    );
  }
  return false;
});

@RoutePage()
class OpportunityProgressPage extends ConsumerWidget {
  const OpportunityProgressPage({
    @PathParam.inherit('id') this.oppId = '',
    super.key,
  });

  final String oppId;

  @override
  Widget build(context, ref) {
    final opportunity = ref.watch(opportunityProvider);
    final progressList = ref.watch(progressProvider(oppId));
    final selectedIndex = ref.watch(selectedProvider);

    final double? progress = progressList.value?.foldIndexed(
      0,
      (i, total, e) =>
          (total ?? 0) + ((e.isCheck || i <= selectedIndex) ? e.percent : 0),
    );

    onRefresh() async {
      ref.read(selectedProvider.notifier).state = -1;
      return ref.refresh(progressProvider(oppId));
    }

    onSave() async {
      IconFrameworkUtils.startLoading();

      final progressList = await ref.read(progressProvider(oppId).future);

      // TODO: รอ api แก้ แล้วยิง api แค่ครั้งเดียว
      bool isSuccess = true;
      for (int i = 0; i <= selectedIndex; i++) {
        var p = progressList[i];
        if (!p.isCheck) {
          isSuccess =
              await ref.read(_updateProvider(progressList[i].id).future);
        }
      }

      await IconFrameworkUtils.delayed();
      IconFrameworkUtils.stopLoading();

      if (isSuccess) {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.success'),
          detail: Language.translate('common.alert.save_complete'),
        );
        return onRefresh();
      }
    }

    bool checkValidate() {
      return selectedIndex != -1;
    }

    Future setSelectedProcess(bool check, Progress process, int i) async {
      if (selectedIndex == i && !check) {
        ref.read(selectedProvider.notifier).state = -1;
      } else {
        ref.read(selectedProvider.notifier).state = i;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.opportunity.progress.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomText(
                            '${Language.translate('screen.opportunity.progress.sub_title')}: ',
                            color: AppColor.red,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 10.0),
                          CustomText(
                            opportunity.contactName ?? '',
                            color: AppColor.blue,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ProgressBar(
                          progress: progress ?? 0,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: AppColor.white,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: AppColor.grey5,
                        ),
                      ),
                    ),
                    child: progressList.when(
                      // skipLoadingOnRefresh: false,
                      error: (err, stack) => IconButton(
                        onPressed: onRefresh,
                        icon: const Icon(Icons.refresh),
                      ),
                      loading: () => const Loading(),
                      data: (data) {
                        if (data.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: CustomText(
                                Language.translate('common.no_data')),
                          );
                        }
                        return Column(
                          children: data.mapIndexed<Widget>((i, item) {
                            return Column(
                              children: [
                                CheckboxListTile(
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: item.isCheck || selectedIndex >= i,
                                  title: CustomText(
                                    item.name,
                                    fontSize: FontSize.title,
                                  ),
                                  enabled: !item.isCheck,
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  activeColor: AppColor.red,
                                  onChanged: (val) {
                                    if (!data[i].isCheck && val != null) {
                                      setSelectedProcess(val, item, i);
                                    }
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  width: IconFrameworkUtils.getWidth(0.6),
                  child: CustomButton(
                    onClick: onSave,
                    text: Language.translate('common.save'),
                    disable: !(checkValidate()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
