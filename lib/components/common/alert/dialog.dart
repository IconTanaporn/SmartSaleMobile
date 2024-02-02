import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';

import '../../../config/constant.dart';
import '../../../utils/utils.dart';
import '../text/text.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String detail;
  final String nextText;
  final Function()? onNext;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.detail = '',
    required this.nextText,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomText(
                title,
                fontSize: FontSize.title,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
          if (detail != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomText(
                detail,
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: IconFrameworkUtils.getWidth(0.45),
            child: CustomButton(
              onClick: onNext,
              text: nextText,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String detail;
  final String nextText;
  final String cancelText;
  final Function()? onNext;
  final Function()? onCancel;
  final bool disable;
  final Widget? child;

  const CustomConfirmDialog({
    Key? key,
    this.title = '',
    this.detail = '',
    required this.nextText,
    required this.cancelText,
    this.onNext,
    this.onCancel,
    this.disable = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nextStepButton = CustomButton(
      onClick: onNext,
      text: nextText,
      disable: disable,
    );

    Widget cancelButton = CustomButton(
      onClick: onCancel,
      text: cancelText,
      backgroundColor: AppColor.white,
      textColor: AppColor.black,
    );

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomText(
                title,
                fontSize: FontSize.title,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
            ),
          if (detail != '')
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomText(
                detail,
                textAlign: TextAlign.center,
              ),
            ),
          child ?? Container(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.2),
                child: cancelButton,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.2),
                child: nextStepButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//==== Custom Alert Confirm Checkbox ====
class CustomAlertConfirmCheckbox extends StatefulWidget {
  final String dialogTitle;
  final List dialogItemList;
  final String textButtonNextStep;
  final String textButtonCancel;
  final Function(dynamic) pressNextStepButton;
  final Function()? pressCancelButton;
  final bool enableAll;

  const CustomAlertConfirmCheckbox({
    Key? key,
    required this.pressNextStepButton,
    required this.pressCancelButton,
    required this.dialogTitle,
    required this.dialogItemList,
    required this.textButtonNextStep,
    required this.textButtonCancel,
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
    itemList = widget.dialogItemList;
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
      onClick: () => widget.pressNextStepButton(itemList),
      text: widget.textButtonNextStep,
    );

    Widget cancelButton = CustomButton(
      onClick: widget.pressCancelButton,
      text: widget.textButtonCancel,
      backgroundColor: Colors.white,
      textColor: Colors.black,
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
                color: value ? AppColor.red : AppColor.grey,
              ),
            ),
            child: CheckboxListTile(
              value: value,
              onChanged: onChanged,
              controlAffinity: ListTileControlAffinity.leading,
              title: CustomText(
                title,
                fontSize: FontSize.px28,
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
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            widget.dialogTitle,
            fontSize: FontSize.title,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(
              maxHeight: IconFrameworkUtils.getHeight(0.4),
            ),
            // child: FadeListMask(
            //   child: SingleChildScrollView(
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Expanded(
            //           child: Column(
            //             children: [
            //               widget.enableAll
            //                   ? checkboxListTile(
            //                 itemList.fold(true, (value, element) {
            //                   return value && element['isCheck'];
            //                 }),
            //                 'ทั้งหมด',
            //                     (isCheck) {
            //                   onChangeAll(isCheck);
            //                 },
            //               )
            //                   : Container(),
            //               ...itemList.mapIndexed<Widget>((i, item) {
            //                 if (i % 2 == (widget.enableAll ? 0 : 1)) {
            //                   return checkboxListTile(
            //                     item['isCheck'] ?? false,
            //                     item['name'] ?? '',
            //                         (isCheck) {
            //                       onChange(item['name'], isCheck!);
            //                     },
            //                   );
            //                 }
            //                 return Container();
            //               }).toList(),
            //             ],
            //           ),
            //         ),
            //         Expanded(
            //           child: Column(
            //             children: [
            //               ...itemList.mapIndexed<Widget>((i, item) {
            //                 if (i % 2 == (widget.enableAll ? 1 : 0)) {
            //                   return checkboxListTile(
            //                     item['isCheck'] ?? false,
            //                     item['name'] ?? '',
            //                         (isCheck) {
            //                       onChange(item['name'], isCheck!);
            //                     },
            //                   );
            //                 }
            //                 return Container();
            //               }).toList(),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.2),
                child: cancelButton,
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: IconFrameworkUtils.getWidth(0.2),
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
