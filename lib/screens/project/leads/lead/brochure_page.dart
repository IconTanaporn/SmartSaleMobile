import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/common/refresh_indicator/refresh_list_view.dart';
import '../../../../components/common/shader_mask/fade_list_mask.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../route/router.dart';
import '../../../../utils/utils.dart';

class Brochure {
  final String id, name, project, url;

  Brochure(this.id, this.name, this.project, this.url);
}

final selectedBrochureProvider =
    StateProvider.autoDispose<List<Brochure>>((ref) => []);

final brochureListProvider = FutureProvider.autoDispose
    .family<List<Brochure>, String>((ref, projectId) async {
  List list = await ApiController.brochureList(projectId);
  final brochures = list
      .map((e) => Brochure(
            e['brochure_id'],
            e['brochure_name'],
            e['project_name'],
            e['lsfile'],
          ))
      .toList();

  ref.read(selectedBrochureProvider.notifier).state = [brochures.first];
  return brochures;
});

@RoutePage()
class BrochurePage extends ConsumerWidget {
  static const int brochureMax = 1;

  const BrochurePage({
    @PathParam.inherit('id') this.referenceId = '',
    @PathParam.inherit('projectId') this.projectId = '',
    super.key,
  });

  final String referenceId;
  final String projectId;

  @override
  Widget build(context, ref) {
    final brochureList = ref.watch(brochureListProvider(projectId));
    final selected = ref.watch(selectedBrochureProvider);

    onRefresh() async {
      return ref.refresh(brochureListProvider(projectId));
    }

    onSelect(Brochure data, bool? select) {
      if (select == true) {
        if (selected.length >= brochureMax) {
          selected.remove(selected.first);
        }
        selected.add(data);
      } else {
        selected.remove(data);
      }

      /// to refresh screen
      ref.read(selectedBrochureProvider.notifier).state = [...selected];
    }

    toPreviewBrochure(Brochure data) {
      context.router.push(QRRoute(
        url: data.url,
        title: data.project,
        detail: data.name,
      ));
    }

    onSend() {
      context.router
          .pushNamed('/project/$projectId/lead/$referenceId/brochure/send');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.brochure.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  Language.translate('screen.brochure.sub_title'),
                  color: AppColor.red,
                  fontSize: FontSize.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: FadeListMask(
                child: RefreshListView(
                  onRefresh: onRefresh,
                  isEmpty: !brochureList.isLoading &&
                      brochureList.value != null &&
                      brochureList.value!.isEmpty,
                  child: brochureList.when(
                    loading: () => const Center(
                      child: Loading(),
                    ),
                    error: (err, stack) => IconButton(
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh),
                    ),
                    data: (data) {
                      return ListView.separated(
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: 10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        itemCount: data.length + 1,
                        itemBuilder: (context, i) {
                          if (i >= data.length) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 30),
                                  width: IconFrameworkUtils.getWidth(0.45),
                                  child: CustomButton(
                                    onClick: onSend,
                                    text: Language.translate(
                                        'screen.brochure.send_email'),
                                    disable: selected.isEmpty,
                                  ),
                                ),
                              ],
                            );
                          }

                          final item = data[i];
                          final bool isSelected = selected.contains(item);

                          return Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.grey5),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Material(
                              color: isSelected
                                  ? AppColor.red.withOpacity(0.2)
                                  : AppColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: isSelected,
                                selected: isSelected,
                                activeColor: AppColor.red,
                                title: CustomText(item.name),
                                secondary: CustomButton(
                                  onClick: () => toPreviewBrochure(item),
                                  text: Language.translate(
                                      'screen.brochure.preview'),
                                  radius: 10,
                                  backgroundColor: AppColor.blue,
                                  borderColor: AppColor.blue,
                                  height: ButtonSize.small,
                                  fontSize: FontSize.px14,
                                ),
                                onChanged: (val) {
                                  onSelect(item, val);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
