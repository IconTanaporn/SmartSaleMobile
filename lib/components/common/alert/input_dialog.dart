import 'package:flutter/material.dart';

import '../input/input.dart';
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
