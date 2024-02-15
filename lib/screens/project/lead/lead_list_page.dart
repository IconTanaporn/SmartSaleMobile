import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/search_input.dart';
import '../../../components/common/loading/loading.dart';
import '../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../components/contact/contact_list.dart';

final searchProvider = StateProvider<String>((ref) => '');
final filterProvider = StateProvider<String>((ref) => '');
final pageProvider = StateProvider<int>((ref) => 0);

final contactListProvider = FutureProvider.autoDispose((ref) async {
  final search = ref.watch(searchProvider);
  final filter = ref.watch(filterProvider);
  final page = ref.watch(pageProvider);

  List list = await ApiController.leadList(search, filter, page);
  return list
      .map((e) => Contact(
            id: e['id'],
            name: e['name'],
            status: e['status_name'],
            mobile: e['mobile'],
            trackAmount: e['tracking_amount'],
            lastUpdate: e['lastupdate'],
          ))
      .toList();
});

final filteredProvider = FutureProvider.autoDispose<List<Contact>>((ref) async {
  List<Contact> list = ref.watch(contactListProvider).value ?? [];
  final page = ref.read(pageProvider);

  List<Contact> filtered = [];

  if (page != 0) {
    filtered.addAll(ref.state.value ?? []);
  }

  filtered.addAll(list);

  return filtered;
});

@RoutePage()
class LeadListPage extends ConsumerWidget {
  LeadListPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    final contactList = ref.watch(contactListProvider);
    final filteredList = ref.watch(filteredProvider);

    onSelectContact(id) {
      context.router.pushNamed('/project/$projectId/lead/$id');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('screen.lead_list.title')),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: RefreshScrollView(
          onRefresh: () async {
            ref.read(pageProvider.notifier).state = 0;
            return ref.refresh(contactListProvider.future);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SearchInput(
                    controller: search,
                    onChanged: (keyword) {
                      ref.read(pageProvider.notifier).state = 0;
                      ref.read(searchProvider.notifier).state = keyword;
                    },
                    hintText: Language.translate(
                      'screen.lead_list.search',
                    ),
                  ),
                ),
                contactList.when(
                  loading: () => const Center(child: Loading()),
                  error: (err, stack) => CustomText('Error: $err'),
                  data: (data) {
                    List data = filteredList.value ?? [];
                    if (data.isEmpty) {
                      return CustomText(
                        Language.translate('common.no_data'),
                      );
                    }
                    return AlignedGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        Contact contact = data[i];
                        return ContactCard(
                          contact: contact,
                          onTap: () {
                            onSelectContact(contact.id);
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
