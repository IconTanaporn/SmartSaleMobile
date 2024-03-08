import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';
import 'package:smart_sale_mobile/providers/auth_provider.dart';

import '../../api/api_controller.dart';
import '../../components/common/background/default_background.dart';
import '../../components/common/text/text.dart';
import '../../config/constant.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';

final buProvider = FutureProvider.autoDispose((ref) async {
  List list = await ApiController.saleBuList();
  return list
      .map((bu) => Bu(
            id: IconFrameworkUtils.getValue(bu, 'bu_id'),
            name: IconFrameworkUtils.getValue(bu, 'bu_name'),
            isDefault: bu['is_default'] == true,
          ))
      .toList();
});

@RoutePage()
class SettingBuPage extends ConsumerWidget {
  const SettingBuPage({super.key});

  @override
  Widget build(context, ref) {
    final buList = ref.watch(buProvider);
    final authController = ref.watch(authControllerProvider);
    final buId = authController.auth.buId;

    Future onChangeBu(String name, id) async {
      final value = await IconFrameworkUtils.showConfirmDialog(
        title: Language.translate('screen.setting.bu.change_bu'),
        detail: name,
      );

      if (value == AlertDialogValue.confirm) {
        if (context.mounted) {
          await authController.setBuId(id);
          if (context.mounted) {
            Phoenix.rebirth(context);
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.setting.bu.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: buList.when(
          loading: () => const Center(child: Loading()),
          error: (err, stack) => CustomText('Error: $err'),
          data: (data) {
            if (data.isEmpty) {
              return CustomText(
                Language.translate('common.no_data'),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, i) {
                final Bu bu = data[i];

                void onTap() {
                  onChangeBu(bu.name, bu.id);
                }

                return SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColor.grey5),
                        bottom: BorderSide(color: AppColor.grey5),
                      ),
                      color: AppColor.white,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                Radio<String>(
                                  value: bu.id,
                                  groupValue: buId,
                                  onChanged: (_) => onTap(),
                                  activeColor: AppColor.red,
                                ),
                                CustomText(
                                  bu.name ?? '',
                                ),
                                if (bu.isDefault)
                                  CustomText(
                                    '  [${Language.translate(
                                      'screen.setting.bu.default',
                                    )}]',
                                    color: AppColor.red,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Bu {
  final String id;
  final String name;
  final bool isDefault;

  Bu({
    this.id = '',
    this.name = '',
    this.isDefault = false,
  });
}
