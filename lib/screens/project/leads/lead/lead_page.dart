import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/components/customer/lead/lead_profile.dart';
import 'package:smart_sale_mobile/components/customer/lead/qualify/qualify_drawer.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../../components/customer/lead/qualify/lead_qualify.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/lead.dart';
import '../../../../utils/utils.dart';

final leadProvider = StateProvider.autoDispose((ref) => LeadDetail());

final leadDetailProvider =
    FutureProvider.autoDispose.family<LeadDetail, String>((ref, id) async {
  final data = await ApiController.leadDetail(id);
  final lead = LeadDetail(
    id: id,
    prefix: IconFrameworkUtils.getValue(data, 'prefix_name'),
    trackingAmount: IconFrameworkUtils.getValue(data, 'tracking_amount'),
    firstName: IconFrameworkUtils.getValue(data, 'firstname'),
    lastName: IconFrameworkUtils.getValue(data, 'lastname'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
    email: IconFrameworkUtils.getValue(data, 'email'),
    lineId: IconFrameworkUtils.getValue(data, 'line_id'),
    source: IconFrameworkUtils.getValue(data, 'source_name'),
    status: IconFrameworkUtils.getValue(data, 'status_name'),
  );
  ref.read(leadProvider.notifier).state = lead;
  return lead;
});

@RoutePage()
class LeadPage extends ConsumerWidget {
  LeadPage({
    @PathParam('projectId') this.projectId = '',
    @PathParam('id') this.contactId = '',
    super.key,
  });

  final String projectId, contactId;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(context, ref) {
    final lead = ref.watch(leadDetailProvider(contactId));

    Future onRefresh() async {
      return ref.refresh(leadDetailProvider(contactId));
    }

    toEditLead() {
      context.router.pushNamed('/lead/$contactId/edit');
    }

    void onQualify() {
      _key.currentState!.openEndDrawer();
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          Language.translate('screen.lead.title'),
        ),
        centerTitle: true,
        actions: [
          Container(),
        ],
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: const QualifyDrawer(),
      body: DefaultBackgroundImage(
        child: RefreshScrollView(
          onRefresh: onRefresh,
          child: SafeArea(
            child: Column(
              children: [
                Material(
                  color: AppColor.white,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: AppColor.grey5),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          child: CustomText(
                            Language.translate('screen.contact.sub_title'),
                            color: AppColor.red,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        LeadQualifyMenu(
                          onOpen: onQualify,
                        ),
                      ],
                    ),
                  ),
                ),
                lead.when(
                  error: (err, stack) => IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  loading: () => const Loading(),
                  data: (data) => LeadProfile(
                    lead: data,
                    onEdit: toEditLead,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
