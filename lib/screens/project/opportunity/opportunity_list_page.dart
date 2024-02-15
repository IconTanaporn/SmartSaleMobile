import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/components/opportunity/opportunity_list.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/search_input.dart';
import '../../../components/common/loading/loading.dart';
import '../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../components/common/shader_mask/fade_list_mask.dart';
import '../../../utils/utils.dart';

const int pageSize = 10;

final searchProvider = StateProvider<String>((ref) => '');
final filterProvider = StateProvider<String>((ref) => '');
final pageProvider = StateProvider<int>((ref) => 0);
final hasNextPageProvider = StateProvider<bool>((ref) => true);

final opportunityListProvider = FutureProvider.autoDispose
    .family<List<Opportunity>, String>((ref, projectId) async {
  final search = ref.watch(searchProvider);
  final filter = ref.watch(filterProvider);
  final page = ref.watch(pageProvider);

  List list = await ApiController.opportunitySearchList(
      projectId, search, filter, page, pageSize);
  if (list.length < pageSize) {
    ref.read(hasNextPageProvider.notifier).state = false;
  }
  return list
      .map((e) => Opportunity(
            id: e['id'],
            name: e['contact_name'],
            statusName: e['status_name'],
            mobile: e['mobile'],
            trackingAmount: e['tracking_amount'],
            lastUpdate: e['lastupdate'],
            createDate: e['createdate'],
            expDate: e['expdate'],
            projectName: e['project_name'],
          ))
      .toList();
});

final filteredProvider = FutureProvider.autoDispose
    .family<List<Opportunity>, String>((ref, projectId) async {
  List<Opportunity> list =
      ref.watch(opportunityListProvider(projectId)).value ?? [];
  final page = ref.read(pageProvider);

  List<Opportunity> filtered = [];

  if (page != 0) {
    filtered.addAll(ref.state.value ?? []);
  }

  filtered.addAll(list);

  return filtered;
});

@RoutePage()
class OpportunityListPage extends ConsumerWidget {
  OpportunityListPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    final opportunityList = ref.watch(opportunityListProvider(projectId));
    final filteredList = ref.watch(filteredProvider(projectId));
    final hasNextPage = ref.watch(hasNextPageProvider);

    onSelectOpp(id) {
      context.router.pushNamed('/project/$projectId/opportunity/$id');
    }

    getNextPage() async {
      await IconFrameworkUtils.delayed();
      ref.read(pageProvider.notifier).update((state) => state + 1);
    }

    refresh() async {
      ref.read(pageProvider.notifier).state = 0;
      ref.read(hasNextPageProvider.notifier).state = true;
      return ref.refresh(opportunityListProvider(projectId).future);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('screen.opportunity_list.title')),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SearchInput(
                  controller: search,
                  onChanged: (keyword) {
                    ref.read(pageProvider.notifier).state = 0;
                    ref.read(searchProvider.notifier).state = keyword;
                  },
                  hintText: Language.translate(
                    'screen.opportunity_list.search',
                  ),
                ),
              ),
              Loading(
                isLoading:
                    opportunityList.value == null && opportunityList.isLoading,
              ),
              if (!opportunityList.isLoading &&
                  (filteredList.value?.isEmpty ?? false))
                CustomText(Language.translate('common.no_data')),
              Expanded(
                child: FadeListMask(
                  child: RefreshScrollView(
                    onRefresh: refresh,
                    child: AlignedGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      itemCount: (filteredList.value?.length ?? 0) +
                          ((!opportunityList.isLoading && hasNextPage) ? 1 : 0),
                      itemBuilder: (context, i) {
                        List<Opportunity> data = filteredList.value ?? [];
                        if (i >= data.length) {
                          return VisibilityDetector(
                            onVisibilityChanged: (VisibilityInfo info) {
                              double visiblePercentage =
                                  info.visibleFraction * 100;
                              if (visiblePercentage == 100) {
                                getNextPage();
                              }
                            },
                            key: const Key('loading'),
                            child: const Loading(),
                          );
                        }
                        Opportunity opp = data[i];
                        return OpportunityCard(
                          contact: opp,
                          onTap: () {
                            onSelectOpp(opp.id);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
