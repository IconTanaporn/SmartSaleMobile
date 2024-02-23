import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_sale_mobile/api/api_controller.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';

import '../components/common/background/defualt_background.dart';
import '../components/common/input/search_input.dart';
import '../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../components/common/text/text.dart';
import '../components/project/project_list.dart';
import '../config/asset_path.dart';
import '../config/constant.dart';
import '../config/language.dart';
import '../providers/auth_provider.dart';
import '../utils/utils.dart';

final projectListProvider = FutureProvider.autoDispose((ref) async {
  List list = await ApiController.projectList();
  return list
      .map<Project>((data) => Project(
            id: data['id'],
            location: data['sub_title'],
            name: data['name'],
            imgSource: data['image'],
            startPrice: data['start_price'],
          ))
      .toList();
});

final searchProvider = StateProvider((ref) => '');

final filteredProject = Provider.autoDispose<List<Project>>((ref) {
  final projects = ref.watch(projectListProvider).value;
  final keyword = ref.watch(searchProvider);

  if (keyword.isEmpty) {
    return projects ?? [];
  } else if (projects?.isNotEmpty ?? false) {
    return projects!
        .where((Project project) =>
            project.name.toLowerCase().contains(keyword.toLowerCase()) ||
            project.location.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  return [];
});

@RoutePage()
class HomePage extends ConsumerWidget {
  final search = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(context, ref) {
    final projectList = ref.watch(projectListProvider);
    final filteredList = ref.watch(filteredProject);

    onRefresh() {
      return ref.refresh(projectListProvider.future);
    }

    onSelectProject(id) {
      context.router.navigateNamed('/project/$id');
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetPath.logoFull),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: CustomText(
                  Language.translate('screen.setting.title'),
                  fontSize: FontSize.title,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  context.router.navigateNamed('/setting');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: CustomText(
                  Language.translate('screen.setting.logout.title'),
                  fontSize: FontSize.title,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () async {
                  final value = await IconFrameworkUtils.showConfirmDialog(
                    title: Language.translate('screen.setting.logout.title'),
                    detail: Language.translate(
                        'screen.setting.logout.confirm_logout'),
                  );
                  if (value == AlertDialogValue.confirm) {
                    ref.read(authControllerProvider).signOut();
                    context.router.popUntilRoot();
                    context.router.replaceNamed('/login');
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      PackageInfo? info = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            'Version ${info?.version ?? ''}.${info?.buildNumber ?? ''}',
                            fontSize: FontSize.px14,
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultBackgroundImage(
        child: RefreshScrollView(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                CustomText(
                  Language.translate('screen.project_list.title'),
                  color: AppColor.red,
                  fontSize: FontSize.normal,
                  fontWeight: FontWeight.w500,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SearchInput(
                    controller: search,
                    onChanged: (keyword) =>
                        ref.read(searchProvider.notifier).state = keyword,
                    hintText: Language.translate(
                      'screen.project_list.search',
                    ),
                  ),
                ),
                projectList.when(
                  loading: () => const Center(child: Loading()),
                  error: (err, stack) => CustomText('Error: $err'),
                  data: (data) {
                    if (filteredList.isEmpty) {
                      return CustomText(
                        Language.translate('common.no_data'),
                      );
                    }
                    return AlignedGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      itemCount: filteredList.length,
                      itemBuilder: (context, i) {
                        Project project = filteredList[i];
                        return ProjectCard(
                          project: project,
                          onTap: () {
                            onSelectProject(project.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
