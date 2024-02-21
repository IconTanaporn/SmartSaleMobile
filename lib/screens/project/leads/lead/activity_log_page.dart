import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/common/refresh_indicator/refresh_list_view.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';

class Activity {
  final String id, title, description;
  final String eventDate, date;

  Activity(
    this.id,
    this.title,
    this.description,
    this.eventDate,
    this.date,
  );
}

final activityListProvider =
    FutureProvider.autoDispose.family<List<Activity>, String>((ref, id) async {
  List list = await ApiController.customerActivity(id);
  return list
      .map((e) => Activity(
            e['id'],
            e['title'],
            e['description'],
            e['event_date'],
            e['date'],
          ))
      .toList();
});

@RoutePage()
class ActivityLogPage extends ConsumerWidget {
  const ActivityLogPage({
    @PathParam.inherit('id') this.referenceId = '',
    super.key,
  });

  final String referenceId;

  @override
  Widget build(context, ref) {
    final activityList = ref.watch(activityListProvider(referenceId));

    onRefresh() async {
      return ref.refresh(activityListProvider(referenceId));
    }

    onClick(Activity data) {
      // context.router.push(QRRoute(
      //   url: q.url,
      //   title: Language.translate('screen.opportunity.questionnaire.title'),
      //   detail: q.name,
      // ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.activity.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: RefreshListView(
          onRefresh: onRefresh,
          isEmpty: !activityList.isLoading &&
              activityList.value != null &&
              activityList.value!.isEmpty,
          child: activityList.when(
            loading: () => const Center(
              child: Loading(),
            ),
            error: (err, stack) => IconButton(
              onPressed: () =>
                  ref.refresh(activityListProvider(referenceId).future),
              icon: const Icon(Icons.refresh),
            ),
            data: (data) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: data.length,
                itemBuilder: (context, i) {
                  return Material(
                    color: AppColor.white,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: AppColor.grey5),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => onClick(data[i]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      (data[i].eventDate != '')
                                          ? data[i].eventDate
                                          : data[i].date ?? '',
                                      color: AppColor.red,
                                      fontSize: FontSize.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    CustomText(
                                      data[i].title,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_right_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
