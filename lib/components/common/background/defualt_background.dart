import 'package:flutter/cupertino.dart';

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
      child: child,
    );
  }
}
