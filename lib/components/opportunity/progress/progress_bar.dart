import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../../common/text/text.dart';

class ProgressBar extends StatelessWidget {
  final double height = 40;
  final double progress;

  const ProgressBar({
    Key? key,
    required this.progress,
  }) : super(key: key);

  Color getColor() {
    if (progress >= 0 && progress <= 25) {
      return const Color(0xFFFF9F9F);
    } else if (progress > 25 && progress <= 50) {
      return const Color(0xFFFFE08F);
    } else if (progress > 50 && progress <= 99) {
      return const Color(0xFFA0BAFF);
    } else {
      return const Color(0xFFB1DFA9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.white,
          border: Border.all(
            color: AppColor.grey5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 2),
                      width: constraints.maxWidth / 100 * progress,
                      height: height,
                      decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    '$progress %',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
