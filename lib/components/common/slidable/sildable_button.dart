import 'package:flutter/material.dart';

import '../../../config/constant.dart';

class SlidableButton extends StatelessWidget {
  final Color iconColor, color;
  final void Function()? onPressed;
  final String iconPath;

  const SlidableButton({
    Key? key,
    this.onPressed,
    this.iconColor = AppColor.white,
    this.color = AppColor.grey3,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const BeveledRectangleBorder(),
          backgroundColor: color,
          padding: const EdgeInsets.all(10),
        ),
        child: Image.asset(
          iconPath,
          height: 20,
          color: iconColor,
        ),
      ),
    );
  }
}
