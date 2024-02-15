import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';
import '../common/text/text.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity contact;
  final Function()? onTap;

  const OpportunityCard({
    Key? key,
    required this.contact,
    this.onTap,
  }) : super(key: key);

  dataRow(String label, String value) => DataRow(
        cells: <DataCell>[
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                Language.translate(label),
                color: AppColor.blue,
                fontSize: FontSize.px14,
              ),
              const SizedBox(width: 10),
              const CustomText(
                ':',
                color: AppColor.blue,
                fontSize: FontSize.px14,
              ),
            ],
          )),
          DataCell(Container(
            constraints: BoxConstraints(
              maxWidth: IconFrameworkUtils.getWidth(0.6),
              maxHeight: double.infinity,
            ),
            child: CustomText(
              value == '' ? '-' : value,
              fontSize: FontSize.px14,
              lineOfNumber: 2,
            ),
          )),
        ],
      );

  @override
  Widget build(BuildContext context) {
    int days = contact.dayLeft();

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
                    contact.name,
                    lineOfNumber: 3,
                  ),
                  CustomText(
                    contact.lastUpdate,
                    color: AppColor.blue,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: AppColor.transparent),
                    child: DataTable(
                      horizontalMargin: 0,
                      headingRowHeight: 0,
                      dividerThickness: 0,
                      dataRowHeight: FontSize.normal * 1.5,
                      columns: <DataColumn>[
                        DataColumn(label: Container()),
                        DataColumn(label: Container()),
                      ],
                      rows: <DataRow>[
                        dataRow(
                          'module.contact.mobile',
                          contact.mobile,
                        ),
                        dataRow(
                          'module.contact.tracking_amount',
                          '${contact.trackingAmount} ${Language.translate('common.unit.times')}',
                        ),
                        dataRow(
                          'module.opportunity.project',
                          contact.projectName,
                        ),
                        dataRow(
                          'module.opportunity.status',
                          contact.statusName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: contact.dayLeftColor(days),
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
