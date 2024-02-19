import 'dart:ui';

import '../config/constant.dart';
import '../utils/utils.dart';

class OpportunityDetail {
  final String oppId,
      oppName,
      comment,
      budget,
      projectId,
      projectName,
      status,
      createDate,
      expDate,
      contactId,
      contactName,
      mobile;

  const OpportunityDetail({
    this.oppId = '',
    this.oppName = '',
    this.comment = '',
    this.budget = '',
    this.projectId = '',
    this.projectName = '',
    this.status = '',
    this.createDate = '',
    this.expDate = '',
    this.contactId = '',
    this.contactName = '',
    this.mobile = '',
  });

  // TODO: รอแก้ status - 'อยู่ระหว่างการดำเนินงาน'
  bool get canEdit => status == 'อยู่ระหว่างการดำเนินงาน';

  int dayLeft({String? date}) {
    var formattedDate = IconFrameworkUtils.dateFormat.parse(date ?? expDate);
    return formattedDate.difference(DateTime.now()).inDays;
  }

  Color dayLeftColor({int? days}) {
    int dayLefts = days ?? dayLeft();
    if (dayLefts <= 7) {
      return AppColor.red;
    } else if (dayLefts <= 15) {
      return AppColor.yellow;
    } else if (dayLefts <= 30) {
      return AppColor.blue;
    }
    return AppColor.green;
  }
}
