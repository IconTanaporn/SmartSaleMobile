import 'package:flutter/material.dart';

import '../../../config/language.dart';
import '../text/text.dart';

class RefreshListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final bool isEmpty;
  final Widget child;

  const RefreshListView({
    Key? key,
    required this.onRefresh,
    required this.isEmpty,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: !isEmpty
          ? child
          : ListView(
              children: [
                CustomText(
                  Language.translate('common.no_data'),
                )
              ],
            ),
    );
  }
}
