import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';
import '../common/table/description.dart';
import '../common/text/text.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final Function()? onTap;

  const OpportunityCard({
    Key? key,
    required this.opportunity,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int days = opportunity.dayLeft();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    opportunity.name,
                    lineOfNumber: 3,
                  ),
                  CustomText(
                    opportunity.lastUpdate,
                    color: AppColor.blue,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Descriptions(
                      rows: [
                        ['module.contact.mobile', opportunity.mobile],
                        [
                          'module.contact.tracking_amount',
                          '${opportunity.trackingAmount} ${Language.translate('common.unit.times')}',
                        ],
                        ['module.opportunity.project', opportunity.projectName],
                        ['module.opportunity.status', opportunity.statusName]
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: opportunity.dayLeftColor(days),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 60,
                    ),
                    child: Column(
                      children: [
                        CustomText(
                          Language.translate(
                              'screen.opportunity_list.day_left.top'),
                          fontSize: FontSize.px10,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                        CustomText(
                          days < 0
                              ? '0'
                              : days > 999
                                  ? '999+'
                                  : days.toString(),
                          fontSize: FontSize.px20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                        CustomText(
                          Language.translate(
                              'screen.opportunity_list.day_left.bottom'),
                          fontSize: FontSize.px10,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Opportunity {
  final String id;
  final String name;
  final String projectId;
  final String projectName;
  final String contactId;
  final String contactName;
  final String mobile;
  final String statusId;
  final String statusName;
  final String createDate;
  final String lastUpdate;
  final String expDate;
  final int trackingAmount;
  final List salePersons;

  Opportunity({
    this.id = '',
    this.name = '',
    this.projectId = '',
    this.projectName = '',
    this.contactId = '',
    this.contactName = '',
    this.lastUpdate = '',
    this.createDate = '',
    this.statusId = '',
    this.statusName = '',
    this.expDate = '',
    this.mobile = '',
    this.trackingAmount = 0,
    this.salePersons = const [],
  });

  int dayLeft({String? date}) {
    var formattedDate = IconFrameworkUtils.dateFormat.parse(date ?? expDate);
    return formattedDate.difference(DateTime.now()).inDays;
  }

  Color dayLeftColor(int days) {
    if (days <= 7) {
      return AppColor.red;
    } else if (days <= 15) {
      return AppColor.yellow;
    } else if (days <= 30) {
      return AppColor.blue;
    }
    return AppColor.green;
  }
}
