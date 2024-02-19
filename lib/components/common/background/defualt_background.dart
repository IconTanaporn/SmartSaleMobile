import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/config/constant.dart';

import '../../../config/asset_path.dart';

class DefaultBackgroundImage extends StatelessWidget {
  final Widget? child;

  const DefaultBackgroundImage({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPath.backgroundDefault),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(color: AppColor.transparent, child: child),
    );
  }
}
