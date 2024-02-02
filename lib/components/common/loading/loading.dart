import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_sale_mobile/config/constant.dart';

class Loading extends StatelessWidget {
  final bool isLoading;

  const Loading({
    this.isLoading = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitCircle(
            color: AppColor.white,
            size: 50,
          )
        : Container();
  }
}
