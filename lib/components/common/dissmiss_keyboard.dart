import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          IconFrameworkUtils.unFocus();
        }
      },
      child: child,
    );
  }
}
