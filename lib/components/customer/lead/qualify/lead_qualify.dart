import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../common/text/text.dart';

class LeadQualifyMenu extends ConsumerWidget {
  final Function()? onOpen;

  const LeadQualifyMenu({super.key, this.onOpen});

  @override
  Widget build(context, ref) {
    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CustomText(
              Language.translate('screen.lead.qualify.title'),
              fontSize: FontSize.title,
              fontWeight: FontWeight.w500,
              color: AppColor.red,
            ),
            const SizedBox(width: 8),
            Image.asset(
              AssetPath.iconDropdown,
              width: 15,
            ),
          ],
        ),
      ),
    );
  }
}
