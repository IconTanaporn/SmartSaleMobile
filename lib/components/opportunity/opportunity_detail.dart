import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/models/opportunity.dart';

import '../../../config/constant.dart';
import '../../utils/utils.dart';
import '../common/table/description.dart';

class OpportunityProfile extends StatelessWidget {
  final OpportunityDetail opp;

  const OpportunityProfile({
    Key? key,
    required this.opp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColor.grey5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Descriptions(fontSize: FontSize.normal, colon: '', rows: [
          ['module.opportunity.project', opp.projectName],
          ['module.opportunity.date', opp.createDate],
          ['module.opportunity.status', opp.status],
          [
            'module.opportunity.budget',
            IconFrameworkUtils.currencyFormat(
                double.tryParse(opp.budget.replaceAll(',', '')) ?? 0)
          ],
          ['module.opportunity.comment', opp.comment],
        ]),
      ),
    );
  }
}
