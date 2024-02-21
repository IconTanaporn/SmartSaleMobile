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

class Brochure {
  final String id, name, project, url;

  Brochure(this.id, this.name, this.project, this.url);
}

final selectedProvider = StateProvider.autoDispose<Brochure?>((ref) => null);

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

  ref.read(selectedProvider.notifier).state = brochures.first;
  return brochures;
});

@RoutePage()
class BrochurePage extends ConsumerWidget {
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
    final selected = ref.watch(selectedProvider);

    onRefresh() async {
      return ref.refresh(brochureListProvider(projectId));
    }

    onSelect(Brochure data) {
      ref.read(selectedProvider.notifier).state = data;
    }

    toPreviewBrochure(Brochure data) {
      context.router.push(QRRoute(
        url: data.url,
        title: data.project,
        detail: data.name,
      ));
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
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          final item = data[i];
                          final bool isSelected = selected?.id == item.id;
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: isSelected,
                              selected: isSelected,
                              activeColor: AppColor.red,
                              tileColor: AppColor.white,
                              selectedTileColor: AppColor.red.withOpacity(0.2),
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
                                onSelect(item);
                              },
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: AppColor.grey5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
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
