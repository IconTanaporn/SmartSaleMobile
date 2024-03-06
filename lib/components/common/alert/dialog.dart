import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../utils/utils.dart';
import '../shader_mask/fade_list_mask.dart';
import '../text/text.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String detail;
  final String? nextText;
  final Function()? onNext;

  const CustomAlertDialog({
    Key? key,
    this.title = '',
    this.detail = '',
    this.nextText,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      title: title != ''
          ? CustomText(
              title,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            )
          : null,
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      content: (detail != '')
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (detail != '')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CustomText(
                      detail,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            )
          : null,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: IconFrameworkUtils.getWidth(0.45),
          child: CustomButton(
            onClick: onNext,
            text: nextText ?? Language.translate('common.alert.confirm'),
          ),
        ),
      ],
    );
  }
}

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String detail;
  final String? nextText;
  final String? cancelText;
  final Function()? onNext;
  final Function()? onCancel;
  final bool disable;
  final Widget? child;

  const CustomConfirmDialog({
    Key? key,
    this.title = '',
    this.detail = '',
    this.nextText,
    this.cancelText,
    this.onNext,
    this.onCancel,
    this.disable = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nextStepButton = CustomButton(
      onClick: onNext ??
          () => Navigator.of(context, rootNavigator: true)
              .pop(AlertDialogValue.confirm),
      text: nextText ?? Language.translate('common.alert.confirm'),
      disable: disable,
    );

    Widget cancelButton = CustomButton(
      onClick: onCancel ??
          () => Navigator.of(context, rootNavigator: true)
              .pop(AlertDialogValue.cancel),
      text: cancelText ?? Language.translate('common.alert.cancel'),
      backgroundColor: AppColor.white,
      textColor: AppColor.black,
    );

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      title: title != ''
          ? CustomText(
              title,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            )
          : null,
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      actionsOverflowButtonSpacing: 10,
      content: (detail != '' || child != null)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (detail != '')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CustomText(
                      detail,
                      textAlign: TextAlign.center,
                    ),
                  ),
                child ?? Container(),
              ],
            )
          : null,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: IconFrameworkUtils.getWidth(0.2),
          child: cancelButton,
        ),
        SizedBox(
          width: IconFrameworkUtils.getWidth(0.2),
          child: nextStepButton,
        ),
      ],
    );
  }
}

//==== Custom Alert Confirm Checkbox ====
class CustomAlertConfirmCheckbox extends StatefulWidget {
  final String title;
  final List itemList;
  final String textNext;
  final String textCancel;
  final Function(dynamic) onNext;
  final Function()? onCancel;
  final bool enableAll;

  const CustomAlertConfirmCheckbox({
    Key? key,
    required this.onNext,
    required this.onCancel,
    required this.title,
    required this.itemList,
    required this.textNext,
    required this.textCancel,
    this.enableAll = false,
  }) : super(key: key);
  @override
  State<CustomAlertConfirmCheckbox> createState() =>
      _CustomAlertConfirmCheckboxState();
}

class _CustomAlertConfirmCheckboxState
    extends State<CustomAlertConfirmCheckbox> {
  List itemList = [];

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;
  }

  onChangeAll(bool? isCheck) {
    setState(() {
      for (var i = 0; i < itemList.length; i++) {
        itemList[i]['isCheck'] = isCheck;
      }
    });
  }

  onChange(String name, bool isCheck) {
    int index = itemList.indexWhere((item) => item['name'] == name);
    setState(() {
      itemList[index]['isCheck'] = isCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget nextStepButton = CustomButton(
      onClick: () => widget.onNext(itemList),
      text: widget.textNext,
    );

    Widget cancelButton = CustomButton(
      onClick: widget.onCancel,
      text: widget.textCancel,
      backgroundColor: AppColor.white,
      textColor: AppColor.black,
    );

    Widget checkboxListTile(
      bool value,
      String title,
      void Function(bool?) onChanged,
    ) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              border: Border.all(
                width: 2,
                color: value ? AppColor.red : AppColor.grey5,
              ),
            ),
            child: CheckboxListTile(
              value: value,
              onChanged: onChanged,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(horizontal: -3, vertical: -4),
              title: CustomText(
                title,
                color: value ? AppColor.red : AppColor.black2,
              ),
              activeColor: AppColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(200),
              ),
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            widget.title,
            fontSize: FontSize.title,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(
              maxHeight: IconFrameworkUtils.getHeight(0.5),
            ),
            child: FadeListMask(
              bottom: true,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.enableAll
                        ? checkboxListTile(
                            itemList.fold(true, (value, element) {
                              return value && element['isCheck'];
                            }),
                            'ทั้งหมด',
                            (isCheck) {
                              onChangeAll(isCheck);
                            },
                          )
                        : Container(),
                    ...itemList.mapIndexed<Widget>((i, item) {
                      return checkboxListTile(
                        item['isCheck'] ?? false,
                        item['name'] ?? '',
                        (isCheck) {
                          onChange(item['name'], isCheck!);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.25),
                child: cancelButton,
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.25),
                child: nextStepButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//==== End Custom Alert Confirm Checkbox ====
