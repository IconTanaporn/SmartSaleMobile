import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/search_input.dart';
import '../../../components/common/loading/loading.dart';
import '../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../components/common/shader_mask/fade_list_mask.dart';
import '../../../components/customer/contact_customer_dialog.dart';
import '../../../components/customer/customer_list.dart';
import '../../../utils/utils.dart';

const int pageSize = 10;

final searchProvider = StateProvider<String>((ref) => '');
final filterProvider = StateProvider<String>((ref) => '');
final pageProvider = StateProvider<int>((ref) => 0);
final hasNextPageProvider = StateProvider<bool>((ref) => true);

final filteredProvider = StateProvider<List<Customer>>((ref) => []);

final contactListProvider = FutureProvider.autoDispose((ref) async {
  final page = ref.watch(pageProvider);
  if (page == 0) {
    ref.read(filteredProvider.notifier).state.clear();
  }

  final filter = ref.read(filterProvider);
  final search = ref.read(searchProvider);

  List list = await ApiController.contactList(search, filter, page, pageSize);
  if (list.length < pageSize) {
    ref.read(hasNextPageProvider.notifier).state = false;
  }
  final contacts = list
      .map((e) => Customer(
            id: e['id'],
            name: e['name'],
            status: e['status_name'],
            mobile: e['mobile'],
            email: e['email'],
            trackAmount: e['tracking_amount'],
            lastUpdate: e['lastupdate'],
          ))
      .toList();

  ref.read(filteredProvider.notifier).state.addAll(contacts);

  return contacts;
});

@RoutePage()
class ContactListPage extends ConsumerWidget {
  ContactListPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    final contactList = ref.watch(contactListProvider);
    final filteredList = ref.watch(filteredProvider);
    final hasNextPage = ref.watch(hasNextPageProvider);

    onSelectContact(String id) {
      context.router.pushNamed('/project/$projectId/contact/$id');
    }

    Future onContactCustomer(Customer contact) async {
      await showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ContactCustomerDialog(
            email: contact.email,
            tel: contact.mobile,
            stage: 'contact',
            refId: contact.id,
          );
        },
      );
    }

    getNextPage() async {
      if (!contactList.isLoading) {
        await IconFrameworkUtils.delayed();
        ref.read(pageProvider.notifier).update((state) => state + 1);
      }
    }

    refresh() async {
      ref.read(pageProvider.notifier).state = 0;
      ref.read(hasNextPageProvider.notifier).state = true;
      return ref.refresh(contactListProvider.future);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('screen.contact_list.title')),
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
                    ref.read(searchProvider.notifier).state = keyword;
                    refresh();
                  },
                  hintText: Language.translate(
                    'screen.contact_list.search',
                  ),
                ),
              ),
              if (!contactList.isLoading && filteredList.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(Language.translate('common.no_data')),
                ),
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
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: filteredList.length + (hasNextPage ? 1 : 0),
                      itemBuilder: (context, i) {
                        List<Customer> data = filteredList;
                        if (i >= data.length) {
                          return contactList.when(
                            skipLoadingOnRefresh: false,
                            loading: () => const Center(
                              child: Loading(),
                            ),
                            error: (err, stack) => IconButton(
                              onPressed: () =>
                                  ref.refresh(contactListProvider.future),
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
                        Customer customer = data[i];
                        return CustomerCard(
                          contact: customer,
                          onTap: () {
                            onSelectContact(customer.id);
                          },
                          onLongPress: () {
                            onContactCustomer(customer);
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
