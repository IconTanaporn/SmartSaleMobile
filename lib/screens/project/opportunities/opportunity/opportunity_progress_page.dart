import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/opportunity/progress/progress_bar.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';
import 'opportunity_tab.dart';

final selectedProvider = StateProvider<int>((ref) => -1);

class Progress {
  final int id;
  final String name;
  final int percent;
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
      .map((e) => Progress(
            e['id'],
            e['name'],
            e['percent'],
            e['ischeck'],
          ))
      .toList();
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
    final opportunity = ref.watch(opportunityProvider(oppId));
    final progressList = ref.watch(progressProvider(oppId));
    final selectedIndex = ref.watch(selectedProvider);

    final double progress = progressList.value?.foldIndexed(
          0,
          (i, total, e) =>
              (total ?? 0) +
              ((e.isCheck || i <= selectedIndex) ? e.percent : 0),
        ) ??
        0;

    onRefresh() async {
      return ref.refresh(progressProvider(oppId));
    }

    onSave() {
      //
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
                            opportunity.value?.contactName ?? '',
                            color: AppColor.blue,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ProgressBar(
                          progress: progress,
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
