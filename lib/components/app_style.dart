import 'package:flutter/material.dart';

import '../config/constant.dart';

class AppStyle {
  AppStyle._();

  static TextStyle styleText({
    fontFamily = 'DBHeaventRounded',
    double fontSize = FontSize.normal,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static InputDecoration inputDecoration({
    EdgeInsetsGeometry? contentPadding,
    String? labelText,
    bool? filled = true,
    bool isCollapsed = false,
    isLoading = false,
    String? hintText,
    Widget? suffixIcon,
    String? suffixText,
    double? radius,
    Color? fillColor,
    Color? borderColor,
    String? helperText,
    String? errorText,
  }) {
    return InputDecoration(
      contentPadding:
          contentPadding ?? const EdgeInsets.fromLTRB(12, 12, 12, 12),
      suffix: isLoading ? const CircularProgressIndicator() : null,
      suffixIcon: suffixIcon,
      suffixText: suffixText,
      labelText: labelText,
      labelStyle: styleText(
        fontSize: FontSize.title,
        color: AppColor.grey3,
      ),
      errorStyle: styleText(
        color: AppColor.red,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 15),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 15),
        ),
        borderSide: BorderSide(color: borderColor ?? AppColor.red),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(radius ?? 15),
        ),
        borderSide: BorderSide(color: borderColor ?? Colors.grey, width: 0.0),
      ),
      filled: filled,
      fillColor: fillColor ?? Colors.white,
      isCollapsed: isCollapsed,
      hintText: hintText,
      counterText: '',
      helperText: helperText,
      errorText: errorText,
    );
  }
}
