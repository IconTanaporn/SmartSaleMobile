import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/shader_mask/fade_list_mask.dart';
import 'package:smart_sale_mobile/components/common/table/description.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/calendar/calendar.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/common/refresh_indicator/refresh_list_view.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../utils/utils.dart';

class Activity {
  final String title, event, subEvent, unixTime, date, displayTime, description;

  Activity({
    this.title = '',
    this.event = '',
    this.subEvent = '',
    this.unixTime = '',
    this.date = '',
    this.displayTime = '',
    this.description = '',
  });

  _getDateFromUnix() {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      (double.tryParse(unixTime)?.toInt() ?? 0) * 1000,
    );

    return IconFrameworkUtils.formatDate(date);
  }

  String get dateFromUnix => _getDateFromUnix();
}

final monthProvider = StateProvider.autoDispose((ref) => DateTime.now());
final dayProvider = StateProvider.autoDispose((ref) => DateTime.now());

final calendarProvider = FutureProvider.autoDispose
    .family<Map<String, List<Activity>>, String>((ref, id) async {
  final formatDate = IconFrameworkUtils.apiDateFormat;

  final selectedDay = ref.watch(monthProvider);
  DateTime firstDayOfMonth = DateTime(selectedDay.year, selectedDay.month);
  DateTime lastDayOfMonth =
      DateTime(selectedDay.year, selectedDay.month + 1, 0);

  String startDate = formatDate.format(
    firstDayOfMonth.add(const Duration(days: -7)),
  );
  String endDate = formatDate.format(
    lastDayOfMonth.add(const Duration(days: 7)),
  );
  List list = await ApiController.calendar('l', id, startDate, endDate);

  final activities = list
      .map((e) => Activity(
            title: IconFrameworkUtils.getValue(e, 'title'),
            event: IconFrameworkUtils.getValue(e, 'event_name'),
            subEvent: IconFrameworkUtils.getValue(e, 'subevent_name'),
            unixTime: IconFrameworkUtils.getValue(e, 'unixtime'),
            date: IconFrameworkUtils.getValue(e, 'date'),
            displayTime: IconFrameworkUtils.getValue(e, 'display_time'),
            description: IconFrameworkUtils.getValue(e, 'description'),
          ))
      .toList();
  return groupBy(activities, (Activity item) {
    // TODO: wait api update to use date [dd/MM/yyyy]
    return item.dateFromUnix;
  });
});

@RoutePage()
class CalendarPage extends ConsumerWidget {
  static final debounce = IconFrameworkUtils.debounce(600);

  const CalendarPage({
    @PathParam.inherit('id') this.referenceId = '',
    @PathParam.inherit('projectId') this.projectId = '',
    super.key,
  });

  final String referenceId;
  final String projectId;

  @override
  Widget build(context, ref) {
    final activities = ref.watch(calendarProvider(referenceId));
    final selectedDay = ref.watch(dayProvider);

    onRefresh() async {
      return ref.refresh(calendarProvider(referenceId));
    }

    void onDaySelected(DateTime selectDay, DateTime focusDay) {
      ref.read(dayProvider.notifier).state = selectDay;
    }

    void onPageChanged(DateTime selectDay) {
      ref.read(dayProvider.notifier).state = selectDay;
      debounce.run(() {
        ref.read(monthProvider.notifier).state = selectDay;
      });
    }

    List<Activity> eventLoader(DateTime date) {
      final formatDate = IconFrameworkUtils.dateFormat;

      final stringDate = formatDate.format(date);
      return activities.value?[stringDate] ?? [];
    }

    toAddActivity() {
      var now = DateTime.now();
      final dateTime = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        now.hour,
        now.minute,
      );

      String timestamp = dateTime.millisecondsSinceEpoch.toString();

      // TODO: calendar stage (l,c,o)
      String stage = 'lead';
      context.router.pushNamed(
        '/project/$projectId/$stage/$referenceId/activity/add/$timestamp',
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.calendar.title'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: toAddActivity,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: DefaultBackgroundImage(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomCalendar(
                focusedDay: selectedDay,
                onDaySelected: onDaySelected,
                onPageChanged: onPageChanged,
                eventLoader: eventLoader,
              ),
            ),
            const Divider(height: 0),
            Flexible(
              child: activities.when(
                loading: () => const Center(child: Loading()),
                error: (err, stack) => IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
                data: (data) {
                  final events = eventLoader(selectedDay);

                  return FadeListMask(
                    child: RefreshListView(
                      isEmpty: events.isEmpty,
                      onRefresh: onRefresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        itemCount: events.length + 1,
                        itemBuilder: (_, i) {
                          if (i == 0) {
                            return CustomText(
                              IconFrameworkUtils.formatDate(selectedDay),
                              color: AppColor.red,
                              fontWeight: FontWeight.w500,
                            );
                          }

                          final event = events[i - 1];
                          return SafeArea(
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    border: Border.all(color: AppColor.grey5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Descriptions(
                                    colon: '',
                                    fontSize: FontSize.normal,
                                    rows: [
                                      [
                                        'module.activity.time',
                                        event.displayTime
                                      ],
                                      ['module.activity.event', event.event],
                                      [
                                        'module.activity.sub_event',
                                        event.subEvent
                                      ],
                                      [
                                        'module.activity.description',
                                        event.description
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
