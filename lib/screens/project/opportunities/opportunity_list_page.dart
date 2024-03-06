import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/components/opportunity/opportunity_list.dart';
import 'package:smart_sale_mobile/config/asset_path.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/search_input.dart';
import '../../../components/common/loading/loading.dart';
import '../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../components/common/shader_mask/fade_list_mask.dart';
import '../../../components/customer/filter_drawer.dart';
import '../../../utils/utils.dart';

const int _pageSize = 10;

final _searchProvider = StateProvider.autoDispose<String>((ref) => '');
final _filterProvider = StateProvider<KeyModel>((ref) => KeyModel());
final _pageProvider = StateProvider.autoDispose<int>((ref) => 0);
final _hasNextPageProvider = StateProvider.autoDispose<bool>((ref) => true);

final _filterListProvider = FutureProvider((ref) async {
  List list = await ApiController.opportunitySearchFilter();
  final filters =
      list.map((item) => KeyModel(id: item['id'], name: item['name'])).toList();
  ref.read(_filterProvider.notifier).state = filters.first;
  return filters;
});

final _filteredProvider =
    StateProvider.autoDispose<List<Opportunity>>((ref) => []);

final _opportunityListProvider = FutureProvider.autoDispose
    .family<List<Opportunity>, String>((ref, projectId) async {
  final page = ref.watch(_pageProvider);
  final search = ref.watch(_searchProvider);
  final filter = ref.watch(_filterProvider);

  List list = await ApiController.opportunitySearchList(
      projectId, search, filter.id, page, _pageSize);

  final opportunities = list
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

  if (page == 0) {
    ref.read(_filteredProvider.notifier).state.clear();
  }
  ref.read(_filteredProvider.notifier).state.addAll(opportunities);
  if (list.length < _pageSize) {
    ref.read(_hasNextPageProvider.notifier).state = false;
  }

  return opportunities;
});

@RoutePage()
class OpportunityListPage extends ConsumerWidget {
  OpportunityListPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    final opportunityList = ref.watch(_opportunityListProvider(projectId));
    final filteredList = ref.watch(_filteredProvider);
    final hasNextPage = ref.watch(_hasNextPageProvider);

    onSelectOpp(id) {
      context.router.pushNamed('/project/$projectId/opportunity/$id');
    }

    getNextPage() async {
      await IconFrameworkUtils.delayed();
      ref.read(_pageProvider.notifier).update((state) => state + 1);
    }

    onRefresh() async {
      ref.read(_pageProvider.notifier).state = 0;
      ref.read(_hasNextPageProvider.notifier).state = true;
      return ref.refresh(_opportunityListProvider(projectId).future);
    }

    onChangedFilter(KeyModel key) {
      ref.read(_filterProvider.notifier).state = key;
      onRefresh();
    }

    onChangedKeyword(keyword) {
      ref.read(_searchProvider.notifier).state = keyword;
      onRefresh();
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(Language.translate('screen.opportunity_list.title')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              AssetPath.iconFilter,
              height: 18,
            ),
            onPressed: () => _key.currentState!.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        onChanged: onChangedFilter,
        selectedProvider: _filterProvider,
        listProvider: _filterListProvider,
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
                  onChanged: onChangedKeyword,
                  hintText: Language.translate(
                    'screen.opportunity_list.search',
                  ),
                ),
              ),
              if (!opportunityList.isLoading && filteredList.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(Language.translate('common.no_data')),
                ),
              Expanded(
                child: FadeListMask(
                  child: RefreshScrollView(
                    onRefresh: onRefresh,
                    child: AlignedGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: filteredList.length + (hasNextPage ? 1 : 0),
                      itemBuilder: (context, i) {
                        List<Opportunity> data = filteredList;
                        if (i >= data.length) {
                          return opportunityList.when(
                            skipLoadingOnRefresh: false,
                            loading: () => const Center(
                              child: Loading(),
                            ),
                            error: (err, stack) => IconButton(
                              onPressed: () => ref.refresh(
                                  _opportunityListProvider(projectId).future),
                              icon: const Icon(Icons.refresh),
                            ),
                            data: (_) => VisibilityDetector(
                              onVisibilityChanged: (VisibilityInfo info) {
                                double visiblePercentage =
                                    info.visibleFraction * 100;
                                if (visiblePercentage == 100) {
                                  getNextPage();
                                }
                              },
                              key: const Key('loading'),
                              child: const Loading(),
                            ),
                          );
                        }
                        Opportunity opp = data[i];
                        return OpportunityCard(
                          opportunity: opp,
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
