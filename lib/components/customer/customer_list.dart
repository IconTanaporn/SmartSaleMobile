import 'package:flutter/material.dart';

import '../../config/constant.dart';
import '../../config/language.dart';
import '../common/table/description.dart';
import '../common/text/text.dart';

class CustomerCard extends StatelessWidget {
  final Customer contact;
  final Function()? onTap;

  const CustomerCard({
    Key? key,
    required this.contact,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: CustomText(
                                contact.name,
                                lineOfNumber: 3,
                              ),
                            ),
                            Visibility(
                              visible: contact.status != '',
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColor.red,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 12,
                                  ),
                                  child: CustomText(
                                    contact.status,
                                    color: AppColor.white,
                                    fontSize: FontSize.px10,
                                    fontWeight: FontWeight.w500,
                                    lineOfNumber: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CustomText(
                      contact.lastUpdate,
                      color: AppColor.blue,
                    ),
                  ],
                ),
              ),
              Descriptions(
                colors: const [AppColor.blue, AppColor.black2],
                rows: [
                  ['module.contact.mobile', contact.mobile],
                  [
                    'module.contact.tracking_amount',
                    '${contact.trackAmount} ${Language.translate('common.unit.times')}'
                  ],
                  ['module.contact.source', contact.source],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String mobile;
  final String source;
  final String status;
  final String lastUpdate;
  final int trackAmount;

  Customer({
    this.id = '',
    this.name = '',
    this.mobile = '',
    this.source = '',
    this.status = '',
    this.lastUpdate = '',
    this.trackAmount = 0,
  });
}
