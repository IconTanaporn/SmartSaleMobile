import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';

import '../../../../config/constant.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onClick;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final double? radius;
  final double borderWidth;
  final double fontSize;
  final double height;
  final bool disable;
  final Widget? child;

  const CustomButton({
    Key? key,
    required this.onClick,
    this.text = '',
    this.textColor = Colors.white,
    this.backgroundColor = AppColor.red,
    this.borderColor = AppColor.red,
    this.borderWidth = 1.0,
    this.fontSize = FontSize.normal,
    this.height = ButtonSize.normal,
    this.radius,
    this.disable = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: AppColor.grey5,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: AppColor.grey4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? height / 2),
            side: BorderSide(
              color: disable ? AppColor.grey4 : borderColor,
              width: borderWidth,
            ),
          ),
        ),
        onPressed: disable ? null : onClick,
        child: child ??
            CustomText(
              text,
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
