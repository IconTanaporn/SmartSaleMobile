import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../../../utils/utils.dart';
import 'input.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? hintText;

  const SearchInput({
    Key? key,
    required this.controller,
    this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  static final debounce = IconFrameworkUtils.debounce(500);

  void onChanged(String query) {
    debounce.run(() {
      if (widget.onChanged != null) {
        widget.onChanged!(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      required: false,
      contentPadding: const EdgeInsets.fromLTRB(30, 10, 40, 10),
      controller: widget.controller,
      hintText: widget.hintText,
      textInputAction: TextInputAction.search,
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.search,
          color: AppColor.black2,
        ),
      ),
      onChanged: onChanged,
      radius: 40,
      borderColor: AppColor.grey,
    );
  }
}
