import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../text/text.dart';

class ErrorImage extends StatelessWidget {
  final String text;
  final double radius;
  final double? width;
  final double? height;

  const ErrorImage({
    this.text = 'Error load image',
    this.radius = 0,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.grey2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: AppColor.red,
            size: 40,
          ),
          const SizedBox(height: 8),
          CustomText(
            text,
            color: AppColor.white,
          ),
        ],
      ),
    );
  }
}
