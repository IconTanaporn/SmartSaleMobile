import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../utils/utils.dart';
import '../text/text.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String detail;
  final Widget? child;
  final List<Widget>? actions;

  const CustomDialog({
    Key? key,
    this.title = '',
    this.detail = '',
    this.child,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      title: title != ''
          ? CustomText(
              title,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            )
          : null,
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
      actionsOverflowButtonSpacing: 10,
      actions: actions,
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String detail;
  final String? nextText;
  final Function()? onNext;
  final Widget? child;

  const CustomAlertDialog({
    super.key,
    this.title = '',
    this.detail = '',
    this.nextText,
    this.onNext,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      detail: detail,
      actions: [
        SizedBox(
          width: IconFrameworkUtils.getWidth(0.45),
          child: CustomButton(
            onClick: onNext ??
                () => Navigator.of(context, rootNavigator: true)
                    .pop(AlertDialogValue.dialog),
            text: nextText ?? Language.translate('common.alert.confirm'),
          ),
        ),
      ],
      child: child,
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

    return CustomDialog(
      title: title,
      detail: detail,
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
      child: child,
    );
  }
}
