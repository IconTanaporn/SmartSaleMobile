import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_sale_mobile/config/constant.dart';

class Loading extends StatelessWidget {
  final bool isLoading;
  final double size;
  final Color? color;

  const Loading({
    this.isLoading = true,
    this.size = 50,
    this.color = AppColor.red2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(2),
            child: SpinKitCircle(
              color: color,
              size: size,
            ),
          )
        : Container();
  }
}
