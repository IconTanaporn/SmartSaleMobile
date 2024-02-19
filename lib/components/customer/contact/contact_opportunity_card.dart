import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smart_sale_mobile/components/common/table/description.dart';

import '../../../config/asset_path.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../utils/utils.dart';
import '../../common/slidable/sildable_button.dart';
import '../../common/text/text.dart';
import '../../opportunity/opportunity_list.dart';

class ContactOpportunityCard extends StatelessWidget {
  final ContactOpportunity opportunity;
  final void Function()? onClick;

  const ContactOpportunityCard({
    Key? key,
    required this.opportunity,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool canEdit = opportunity.status == 'อยู่ระหว่างการดำเนินงาน';
    String expDate = opportunity.expDate;
    int dayLeft = expDate == '' ? 0 : Opportunity().dayLeft(date: expDate);

    return Slidable(
      endActionPane: !canEdit
          ? null
          : ActionPane(
              motion: const ScrollMotion(),
              children: [
                Expanded(
                  child: SlidableButton(
                    iconPath: AssetPath.iconEdit,
                    onPressed: () {
                      // if (onClick != null) {
                      //   onClick!();
                      // }
                      // Navigator.of(context)
                      //     .pushNamed(OpportunityEditScreen.screenId)
                      //     .then((_) {
                      //   Navigator.of(context).pop();
                      // });
                    },
                  ),
                ),
                Expanded(
                  child: SlidableButton(
                    color: AppColor.red,
                    iconPath: AssetPath.iconDelete,
                    onPressed: () {
                      // if (onClick != null) {
                      //   onClick!();
                      // }
                      // Navigator.of(context)
                      //     .pushNamed(OpportunityCloseJobScreen.screenId)
                      //     .then((_) {
                      //   Navigator.of(context).pop();
                      // });
                    },
                  ),
                ),
              ],
            ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: AppColor.grey5,
            ),
          ),
        ),
        child: Material(
          color: AppColor.transparent,
          child: InkWell(
            onTap: onClick,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: CustomText(
                          opportunity.projectName,
                          color: AppColor.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CustomText(
                        opportunity.createDate,
                        color: AppColor.blue,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Descriptions(colon: '', rows: [
                          [
                            'module.opportunity.budget',
                            IconFrameworkUtils.currencyFormat(double.tryParse(
                                    opportunity.budget.replaceAll(',', '')) ??
                                0)
                          ],
                          ['module.opportunity.budget', opportunity.status],
                          ['module.opportunity.comment', opportunity.comment],
                        ]),
                      ),
                      if (canEdit)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Opportunity().dayLeftColor(dayLeft),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
                                dayLeft < 0
                                    ? '0'
                                    : dayLeft > 999
                                        ? '999+'
                                        : dayLeft.toString(),
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
        ),
      ),
    );
  }
}

class ContactOpportunity {
  String id = '';
  String name = '';
  String comment = '';
  String projectId = '';
  String projectName = '';
  String budget = '';
  String status = '';
  String contactId = '';
  String contactName = '';
  String mobile = '';
  String email = '';
  String createDate = '';
  String lastUpdate = '';
  String expDate = '';
  List<dynamic> salePersons = [];

  ContactOpportunity({
    this.id = '',
    this.name = '',
    this.comment = '',
    this.projectId = '',
    this.projectName = '',
    this.budget = '',
    this.status = '',
    this.contactId = '',
    this.contactName = '',
    this.mobile = '',
    this.email = '',
    this.createDate = '',
    this.lastUpdate = '',
    this.expDate = '',
    this.salePersons = const [],
  });
}
