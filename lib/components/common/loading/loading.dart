import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_sale_mobile/config/constant.dart';

class Loading extends StatelessWidget {
  final bool isLoading;
  final double size;

  const Loading({
    this.isLoading = true,
    this.size = 50,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SpinKitCircle(
            color: AppColor.red2,
            size: size,
          )
        : Container();
  }
}
