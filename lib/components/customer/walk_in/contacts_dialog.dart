import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../utils/utils.dart';
import '../../common/alert/dialog.dart';
import '../../common/shader_mask/fade_list_mask.dart';
import '../../common/table/description.dart';
import '../../common/text/text.dart';

final contactProvider = StateProvider.autoDispose<DupContact?>((ref) => null);

class DupContactsDialog extends ConsumerWidget {
  final List<DupContact> list;

  const DupContactsDialog({
    super.key,
    required this.list,
  });

  @override
  Widget build(context, ref) {
    final contact = ref.watch(contactProvider);

    void onSelect(DupContact value) {
      ref.read(contactProvider.notifier).state = value;
    }

    return CustomConfirmDialog(
      onNext: () {
        Navigator.of(context, rootNavigator: true).pop(contact);
      },
      onCancel: () {
        Navigator.of(context, rootNavigator: true).pop(AlertDialogValue.cancel);
      },
      title: Language.translate('module.contact.duplicate.title'),
      detail: Language.translate('module.contact.duplicate.sub_title'),
      nextText: Language.translate('common.alert.confirm'),
      cancelText: Language.translate('common.alert.cancel'),
      child: Flexible(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: IconFrameworkUtils.getHeight(0.4),
            maxWidth: IconFrameworkUtils.getWidth(0.66),
          ),
          child: FadeListMask(
            bottom: true,
            child: SingleChildScrollView(
              child: Wrap(
                children: list.map((e) {
                  bool isSelected = e.id == contact?.id;

                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      width: IconFrameworkUtils.getWidth(1),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: isSelected ? AppColor.red : AppColor.grey5,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        onTap: () => onSelect(e),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (c) => onSelect(e),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  activeColor: AppColor.red,
                                ),
                                Flexible(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          e.name,
                                          fontSize: FontSize.normal,
                                        ),
                                        Descriptions(
                                          colors: const [
                                            AppColor.grey3,
                                            AppColor.black2,
                                          ],
                                          rows: [
                                            if (e.mobile != '')
                                              [
                                                'module.contact.mobile',
                                                e.mobile
                                              ],
                                            if (e.email != '')
                                              ['module.contact.email', e.email],
                                            if (e.citizenId != '')
                                              [
                                                'module.contact.citizen_id',
                                                e.citizenId
                                              ],
                                            if (e.passportId != '')
                                              [
                                                'module.contact.passport_id',
                                                e.passportId
                                              ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DupContact {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String citizenId;
  final String passportId;

  DupContact(
    this.id,
    this.name, {
    this.mobile = '',
    this.email = '',
    this.citizenId = '',
    this.passportId = '',
  });
}
