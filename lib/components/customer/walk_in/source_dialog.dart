import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/alert/dialog.dart';

import '../../../config/asset_path.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../common/text/text.dart';

enum WalkInSourceType { walkIn, virtualWalkIn }

class SelectSourceDialog extends StatefulWidget {
  const SelectSourceDialog({Key? key}) : super(key: key);

  @override
  State<SelectSourceDialog> createState() => _SelectSourceDialogState();
}

class _SelectSourceDialogState extends State<SelectSourceDialog> {
  WalkInSourceType sourceType = WalkInSourceType.walkIn;

  void onSelect(WalkInSourceType type) {
    setState(() {
      sourceType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomConfirmDialog(
      onNext: () {
        Navigator.of(context, rootNavigator: true).pop(
          sourceType == WalkInSourceType.walkIn ? 'walkin' : 'virtual_walkin',
        );
      },
      title: Language.translate('screen.walk_in.source_type.title'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WalkInSourceTypeButton(
            sourceType: WalkInSourceType.walkIn,
            selectedType: sourceType,
            onSelect: onSelect,
          ),
          WalkInSourceTypeButton(
            sourceType: WalkInSourceType.virtualWalkIn,
            selectedType: sourceType,
            onSelect: onSelect,
          ),
        ],
      ),
    );
  }
}

class WalkInSourceTypeButton extends StatelessWidget {
  final WalkInSourceType sourceType;
  final WalkInSourceType selectedType;
  final Function(WalkInSourceType type)? onSelect;

  const WalkInSourceTypeButton({
    Key? key,
    required this.sourceType,
    required this.selectedType,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = sourceType == selectedType;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 142 / 2,
      height: 155 / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          color: isSelected ? AppColor.blue : AppColor.grey5,
          width: isSelected ? 3 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: onSelect == null ? null : () => onSelect!(sourceType),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                sourceType == WalkInSourceType.walkIn
                    ? AssetPath.iconWalkIn
                    : AssetPath.iconVirtualWalkIn,
                color: AppColor.blue,
                height: 25,
              ),
              const SizedBox(height: 4),
              Center(
                child: CustomText(
                  sourceType == WalkInSourceType.walkIn
                      ? Language.translate('screen.walk_in.source_type.walk_in')
                      : Language.translate(
                          'screen.walk_in.source_type.virtual_walk_in'),
                  color: AppColor.blue,
                  fontSize: sourceType == WalkInSourceType.walkIn
                      ? FontSize.px16
                      : FontSize.px12,
                  lineOfNumber: 2,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
