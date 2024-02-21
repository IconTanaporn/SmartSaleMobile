import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../app_style.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final Function(CalendarFormat)? onFormatChanged;
  final Function(DateTime, DateTime)? onDaySelected;
  final Function(DateTime)? onPageChanged;
  final List Function(DateTime)? eventLoader;

  const CustomCalendar({
    Key? key,
    required this.focusedDay,
    this.onDaySelected,
    this.onFormatChanged,
    this.onPageChanged,
    this.eventLoader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: TableCalendar(
        locale: Language.currentLanguage,
        focusedDay: focusedDay,
        daysOfWeekHeight: 20,
        rowHeight: 45,
        firstDay: DateTime(DateTime.now().year - 50),
        lastDay: DateTime(DateTime.now().year + 50),
        onFormatChanged: onFormatChanged,
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        weekendDays: const [],
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppStyle.styleText(
            color: AppColor.red,
            fontSize: FontSize.px20,
            fontWeight: FontWeight.w500,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 12),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColor.red,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColor.red,
          ),
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 0.54,
              colors: [
                AppColor.red2,
                AppColor.red,
              ],
            ),
            shape: BoxShape.circle,
          ),
          todayDecoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppColor.grey,
                AppColor.grey4,
              ],
            ),
            shape: BoxShape.circle,
          ),
          defaultTextStyle: AppStyle.styleText(color: AppColor.black2),
          outsideTextStyle: AppStyle.styleText(color: AppColor.grey),
          todayTextStyle: AppStyle.styleText(color: AppColor.white),
          selectedTextStyle: AppStyle.styleText(color: AppColor.white),
          cellMargin: const EdgeInsets.all(8),
          markersAnchor: -0.2,
          markerMargin: const EdgeInsets.symmetric(horizontal: 0.8),
          markerDecoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 0.54,
              colors: [
                AppColor.red2,
                AppColor.red,
              ],
            ),
            color: AppColor.red,
            shape: BoxShape.circle,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppStyle.styleText(
            color: AppColor.blue,
          ),
        ),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(focusedDay, date);
        },
        eventLoader: eventLoader,
      ),
    );
  }
}
