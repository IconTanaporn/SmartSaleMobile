import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/app_style.dart';

import '../../../../../components/common/background/defualt_background.dart';
import '../../../../../components/common/loading/loading.dart';
import '../../../../../config/constant.dart';
import '../../../../../config/language.dart';
import '../../../../../providers/master_data/address_provider.dart';
import 'edit_address_page.dart';

@RoutePage(name: 'EditAddressTab')
class EditAddressTabPage extends ConsumerWidget {
  const EditAddressTabPage({super.key});

  @override
  Widget build(context, ref) {
    final typeList = ref.watch(addressTypeListProvider);

    onRefresh() {
      return ref.refresh(addressTypeListProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.contact.address.title'),
        ),
        centerTitle: true,
      ),
      body: typeList.when(
        error: (err, stack) =>
            IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
        loading: () => const Loading(),
        data: (data) {
          return DefaultTabController(
            length: data.length,
            child: DefaultBackgroundImage(
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    indicatorColor: AppColor.red,
                    labelColor: AppColor.red,
                    labelStyle: AppStyle.styleText(
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: AppColor.red,
                    unselectedLabelStyle: AppStyle.styleText(),
                    tabs: data.map((e) => Tab(text: e.name)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children:
                          data.map((e) => EditAddressPage(type: e)).toList(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
