import 'package:flutter/material.dart';

import '../../../config/asset_path.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../models/lead.dart';
import '../../common/table/description.dart';
import '../../common/text/text.dart';

class LeadProfile extends StatelessWidget {
  final LeadDetail lead;
  final Function()? onEdit;

  const LeadProfile({
    Key? key,
    required this.lead,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: AppColor.grey5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Descriptions(fontSize: FontSize.normal, colon: '', rows: [
                [
                  'screen.lead.info.status',
                  lead.status == ''
                      ? lead.status
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: lead.status.toLowerCase() == 'new'
                                ? AppColor.red
                                : AppColor.orange,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 16,
                            ),
                            child: CustomText(
                              lead.status,
                              color: AppColor.white,
                              fontSize: FontSize.px12,
                            ),
                          ),
                        ),
                ],
                [
                  'module.contact.firstname',
                  '${lead.prefix} ${lead.firstName}'
                ],
                ['module.contact.lastname', lead.lastName],
                ['module.contact.mobile', lead.mobile],
                ['module.contact.line', lead.lineId],
                ['module.contact.email', lead.email],
                ['module.contact.source', lead.source],
                [
                  'module.contact.tracking_amount',
                  '${lead.trackingAmount} ${Language.translate('common.unit.times')}'
                ],
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onEdit,
                icon: Image.asset(
                  AssetPath.iconEdit,
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
