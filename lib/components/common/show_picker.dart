import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../utils/utils.dart';

class ShowPicker {
  ShowPicker._();

  static Future<DateTime> selectDate(DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: navigatorKey.currentContext!,
      initialDate: initialDate,
      firstDate: DateTime(initialDate.year - 100),
      lastDate: DateTime(initialDate.year + 100),
      locale: Language.currentLocate,
    );

    if (picked != null) {
      return DateTime(
        picked.year,
        picked.month,
        picked.day,
        initialDate.hour,
        initialDate.minute,
      );
    }

    return initialDate;
  }

  static Future<DateTime> selectTime(DateTime initialDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (picked != null) {
      return DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        picked.hour,
        picked.minute,
      );
    }

    return initialDate;
  }
}
