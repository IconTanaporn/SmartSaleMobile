import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../config/constant.dart';
import '../../../utils/utils.dart';
import 'error_image.dart';

class ImageNetwork extends StatelessWidget {
  final String imageSource;
  final BoxFit? fit;
  final double radius;
  final double? width, height;

  const ImageNetwork(
    this.imageSource, {
    this.fit,
    this.radius = 0,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageSource == ''
          ? ErrorImage(
              text: 'No image',
              radius: radius,
              width: width,
              height: height,
            )
          : Image.network(
              imageSource,
              fit: fit,
              width: width,
              height: height,
              cacheWidth: (width == null || width == double.infinity)
                  ? (IconFrameworkUtils.getWidth(1) *
                          MediaQuery.of(context).devicePixelRatio)
                      .round()
                  : (width! * MediaQuery.of(context).devicePixelRatio).round(),
              cacheHeight: (height == null || height == double.infinity)
                  ? null
                  : (height! * MediaQuery.of(context).devicePixelRatio).round(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: width,
                  height: height,
                  child: SpinKitCircle(
                    color: AppColor.white,
                    size: width ?? 50,
                  ),
                );
              },
              errorBuilder: (c, o, t) => ErrorImage(
                radius: radius,
                width: width,
                height: height,
              ),
            ),
    );
  }
}
