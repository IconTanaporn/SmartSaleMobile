import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/asset_path.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../models/key_model.dart';
import '../../../utils/utils.dart';
import '../../app_style.dart';
import '../loading/loading.dart';
import '../text/text.dart';

class InputText extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? initialValue;
  final double? minValue;
  final double? maxValue;
  final String? hintText;
  final bool showLabel;
  final bool readOnly;
  final bool disabled;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final String? suffixText;
  final String? errorText;
  final double? radius;
  final Color? fillColor;
  final bool obscureText;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final TextAlign textAlign;
  final bool required;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const InputText({
    Key? key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.initialValue,
    this.minValue,
    this.maxValue,
    this.showLabel = true,
    this.readOnly = false,
    this.disabled = false,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    this.suffixIcon,
    this.suffixText,
    this.errorText,
    this.radius,
    this.fillColor,
    this.obscureText = false,
    this.contentPadding,
    this.borderColor,
    this.textAlign = TextAlign.start,
    this.validator,
    this.required = true,
    this.onTap,
  }) : super(key: key);

  static final debounce =
      IconFrameworkUtils.debounce(IconFrameworkUtils.inputNumberDelayed);

  void onChangedDebounce(String value) {
    if (keyboardType == TextInputType.number) {
      debounce.run(() {
        if (value == '') {
          if (onChanged != null) {
            onChanged!(value);
          }
        } else {
          final number = double.parse(value);
          final text = IconFrameworkUtils.numberFormat(number);
          controller?.value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(
              offset: text.length - 3,
            ),
          );

          if (onChanged != null) {
            onChanged!(number.toString());
          }
        }
      });
    } else {
      if (onChanged != null) {
        onChanged!(value);
      }
    }
  }

  String? onValidate(value) {
    if (!disabled) {
      if (required) {
        if (value == null || value.isEmpty) {
          return Language.translate(
            'common.input.validate.required',
            translationParams: {'label': labelText ?? ''},
          );
        }
      }
      final num = double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
      if (minValue != null) {
        if (minValue! > num) {
          return Language.translate(
            'common.input.validate.min',
            translationParams: {
              'label': labelText ?? '',
              'value': IconFrameworkUtils.numberFormat(minValue),
            },
          );
        }
      }
      if (maxValue != null) {
        if (maxValue! < num) {
          return Language.translate(
            'common.input.validate.max',
            translationParams: {
              'label': labelText ?? '',
              'value': IconFrameworkUtils.numberFormat(maxValue),
            },
          );
        }
      }

      if (validator != null) {
        return validator!(value);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign,
      obscureText: obscureText,
      initialValue: initialValue,
      controller: controller,
      decoration: AppStyle.inputDecoration(
        contentPadding: contentPadding,
        labelText: (labelText != null && showLabel)
            ? '$labelText${(required ? ' *' : '')}'
            : null,
        hintText: (labelText != null && !showLabel) ? labelText : hintText,
        suffixIcon: suffixIcon,
        radius: radius,
        fillColor: disabled ? AppColor.grey5 : fillColor,
        suffixText: suffixText,
        borderColor: borderColor,
        errorText: errorText,
      ),
      maxLength: keyboardType == TextInputType.number ? 20 : null,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              // _CustomTextInputFormatter.number,
            ]
          : null,
      style: AppStyle.styleText(
        fontSize: FontSize.normal,
        color: AppColor.grey2,
      ),
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChangedDebounce,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: !disabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: onValidate,
    );
  }
}

class InputTextArea extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? hintText;
  final bool readOnly;
  final bool disabled;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final double? radius;
  final Color? fillColor;
  final bool obscureText;
  final int minLines;
  final String? helperText;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool required;

  const InputTextArea({
    Key? key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.initialValue,
    this.readOnly = false,
    this.disabled = false,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    this.suffixIcon,
    this.radius,
    this.fillColor,
    this.obscureText = false,
    this.minLines = 6,
    this.helperText,
    this.errorText,
    this.validator,
    this.required = false,
  }) : super(key: key);

  String? onValidate(value) {
    if (required) {
      if (value == null || value.isEmpty) {
        return Language.translate(
          'common.input.validate.required',
          translationParams: {'label': labelText ?? ''},
        );
      }
    }
    if (validator != null) {
      return validator!(value);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: AppStyle.inputDecoration(
        labelText:
            labelText != null ? '$labelText${(required ? ' *' : '')}' : null,
        hintText: hintText,
        suffixIcon: suffixIcon,
        radius: radius,
        fillColor: disabled ? AppColor.grey5 : fillColor,
        helperText: helperText,
        errorText: errorText,
      ),
      minLines: minLines,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: AppStyle.styleText(
        fontSize: FontSize.title,
        color: AppColor.grey2,
      ),
      readOnly: readOnly,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: !disabled,
      validator: onValidate,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

class InputListTile extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? initialValue;
  final Function()? onTap;
  final Widget? trailing;
  final bool disabled;
  final bool required;
  final Color? fillColor;

  const InputListTile({
    Key? key,
    this.labelText,
    this.controller,
    this.initialValue,
    this.onTap,
    this.trailing,
    this.disabled = false,
    this.required = true,
    this.fillColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputText(
      controller: controller,
      initialValue: initialValue,
      labelText: labelText,
      onTap: disabled ? null : onTap,
      disabled: disabled,
      readOnly: true,
      required: required,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: trailing,
      ),
    );
  }
}

class InputDropdown extends StatelessWidget {
  final Function(KeyModel)? onChanged;
  final List<KeyModel> dataList;
  final KeyModel? value;
  final String? labelText;
  final String? hintText;
  final Color? fillColor;
  final bool disabled;
  final bool isLoading;
  final bool required;

  const InputDropdown({
    Key? key,
    required this.dataList,
    this.value,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.fillColor,
    this.disabled = false,
    this.isLoading = false,
    this.required = true,
  }) : super(key: key);

  String? onValidate(value) {
    if (required) {
      if (value == null) {
        return Language.translate(
          'common.input.validate.dropdown_required',
          translationParams: {'label': labelText ?? ''},
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: AppStyle.inputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        labelText:
            labelText != null ? '$labelText${(required ? ' *' : '')}' : null,
        isCollapsed: true,
        fillColor: disabled ? AppColor.grey5 : fillColor,
      ),
      iconSize: 45,
      borderRadius: BorderRadius.circular(15.0),
      value: value,
      items: dataList.map<DropdownMenuItem<KeyModel>>(
        (KeyModel data) {
          return DropdownMenuItem<KeyModel>(
            value: data,
            child: CustomText(
              data.name,
              lineOfNumber: 1,
              fontSize: FontSize.title,
              color: AppColor.grey2,
            ),
          );
        },
      ).toList(),
      onChanged: disabled
          ? null
          : (KeyModel? keyData) =>
              {if (keyData != null && keyData != value) onChanged!(keyData)},
      hint: CustomText(
        hintText ?? '',
        color: Colors.grey,
        fontSize: FontSize.title,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: onValidate,
      icon: isLoading
          ? const Loading()
          : Image.asset(
              AssetPath.iconDropdown,
              height: 40,
              color: dataList.isNotEmpty && !disabled
                  ? AppColor.red
                  : AppColor.grey4,
            ),
    );
  }
}
