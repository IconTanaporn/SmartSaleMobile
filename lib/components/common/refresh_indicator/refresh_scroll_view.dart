import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class RefreshScrollView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget? child;

  const RefreshScrollView({
    Key? key,
    required this.onRefresh,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              minHeight: IconFrameworkUtils.getHeight(0.95),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
