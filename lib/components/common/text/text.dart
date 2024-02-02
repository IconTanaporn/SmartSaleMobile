import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/config/constant.dart';

import '../../app_style.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final int lineOfNumber;
  final TextAlign? textAlign;
  final double? lineHeight;

  const CustomText(
    this.text, {
    Key? key,
    this.fontSize = FontSize.normal,
    this.color = AppColor.black2,
    this.fontWeight = FontWeight.normal,
    this.lineOfNumber = 0,
    this.textAlign,
    this.lineHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    return Text(
      text,
      maxLines: (lineOfNumber == 0) ? defaultTextStyle.maxLines : lineOfNumber,
      overflow: (lineOfNumber == 0)
          ? defaultTextStyle.overflow
          : TextOverflow.ellipsis,
      style: AppStyle.styleText(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: lineHeight,
      ),
      textAlign: textAlign,
    );
  }
}
