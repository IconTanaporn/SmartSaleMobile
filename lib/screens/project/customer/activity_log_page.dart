import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/loading/loading.dart';
import '../../../components/common/refresh_indicator/refresh_list_view.dart';
import '../../../components/common/text/text.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../route/router.dart';
import '../../../utils/utils.dart';

const int pageSize = 20;

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

final pageProvider = StateProvider.autoDispose<int>((ref) => 0);
final hasNextPageProvider = StateProvider.autoDispose<bool>((ref) => true);
final filteredProvider = StateProvider.autoDispose<List<Activity>>((ref) => []);

final activityListProvider =
    FutureProvider.autoDispose.family<List<Activity>, String>((ref, id) async {
  final page = ref.watch(pageProvider);
  if (page == 0) {
    ref.read(filteredProvider.notifier).state.clear();
  }

  List list = await ApiController.customerActivity(id, page, pageSize);
  if (list.length < pageSize) {
    ref.read(hasNextPageProvider.notifier).state = false;
  }
  final activities = list
      .map((e) => Activity(
            e['id'],
            e['title'],
            e['description'],
            e['event_date'],
            e['date'],
          ))
      .toList();

  ref.read(filteredProvider.notifier).state.addAll(activities);

  return activities;
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
    final filteredList = ref.watch(filteredProvider);
    final hasNextPage = ref.watch(hasNextPageProvider);

    onRefresh() async {
      ref.read(pageProvider.notifier).state = 0;
      ref.read(hasNextPageProvider.notifier).state = true;
      return ref.refresh(activityListProvider(referenceId));
    }

    onReload() {
      return ref.refresh(activityListProvider(referenceId).future);
    }

    onClick(Activity data) {
      context.router.push(ActivityRoute(
        activity: data,
      ).copyWith(params: {
        'reference_id': referenceId,
        'id': data.id,
      }));
    }

    getNextPage() async {
      if (!activityList.isLoading) {
        await IconFrameworkUtils.delayed();
        ref.read(pageProvider.notifier).update((state) => state + 1);
      }
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
          isEmpty: !activityList.isLoading && filteredList.isEmpty,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: filteredList.length + (hasNextPage ? 1 : 0),
            itemBuilder: (context, i) {
              if (i >= filteredList.length) {
                return activityList.when(
                  skipLoadingOnRefresh: false,
                  loading: () => const Center(
                    child: Loading(),
                  ),
                  error: (err, stack) => IconButton(
                    onPressed: onReload,
                    icon: const Icon(Icons.refresh),
                  ),
                  data: (_) => VisibilityDetector(
                    onVisibilityChanged: (VisibilityInfo info) {
                      double visiblePercentage = info.visibleFraction * 100;
                      if (visiblePercentage == 100) {
                        getNextPage();
                      }
                    },
                    key: const Key('loading'),
                    child: const Loading(),
                  ),
                );
              }

              var data = filteredList;
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
          ),
        ),
      ),
    );
  }
}
