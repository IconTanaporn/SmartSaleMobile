import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../../config/constant.dart';
import '../../../utils/utils.dart';
import '../input/input.dart';
import '../shader_mask/fade_list_mask.dart';
import '../text/text.dart';
import 'dialog.dart';

class InputTextAreaDialog extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String detail;
  final String? inputLabel;
  final String? nextText;
  final String? cancelText;
  final bool required;
  final int minLines;
  final Function()? onNext;
  final Function()? onCancel;
  final Function(String value)? onChanged;

  InputTextAreaDialog({
    Key? key,
    this.controller,
    this.title = '',
    this.detail = '',
    this.inputLabel,
    this.nextText,
    this.cancelText,
    this.required = true,
    this.minLines = 3,
    this.onNext,
    this.onCancel,
    this.onChanged,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    next() {
      if (_formKey.currentState?.validate() ?? false) {
        if (onNext != null) onNext!();
      }
    }

    return CustomConfirmDialog(
      title: title,
      detail: detail,
      nextText: nextText,
      cancelText: cancelText,
      onNext: next,
      onCancel: onCancel,
      child: Form(
        key: _formKey,
        child: InputTextArea(
          controller: controller,
          labelText: inputLabel,
          onChanged: onChanged,
          required: required,
          minLines: minLines,
        ),
      ),
    );
  }
}

class CheckboxDialog extends StatefulWidget {
  final String title;
  final List itemList;
  final String? nextText;
  final String? cancelText;
  final Function(dynamic) onNext;
  final Function()? onCancel;
  final bool enableAll;

  const CheckboxDialog({
    Key? key,
    required this.title,
    required this.itemList,
    required this.onNext,
    this.onCancel,
    this.nextText,
    this.cancelText,
    this.enableAll = false,
  }) : super(key: key);
  @override
  State<CheckboxDialog> createState() => _CheckboxDialogState();
}

class _CheckboxDialogState extends State<CheckboxDialog> {
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

    return CustomConfirmDialog(
      title: widget.title,
      nextText: widget.nextText,
      cancelText: widget.cancelText,
      onNext: () => widget.onNext(itemList),
      onCancel: widget.onCancel,
      child: Container(
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
                        Language.translate('common.all'),
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
    );
  }
}
