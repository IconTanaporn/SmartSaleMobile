import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';
import 'package:smart_sale_mobile/components/common/table/description.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/components/opportunity/opportunity_detail.dart';
import 'package:smart_sale_mobile/models/opportunity.dart';
import 'package:smart_sale_mobile/utils/utils.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';

final opportunityProvider = FutureProvider.autoDispose
    .family<OpportunityDetail, String>((ref, id) async {
  var data = await ApiController.opportunityDetail(id);
  return OpportunityDetail(
    oppId: IconFrameworkUtils.getValue(data, 'id'),
    oppName: IconFrameworkUtils.getValue(data, 'name'),
    comment: IconFrameworkUtils.getValue(data, 'comment'),
    budget: IconFrameworkUtils.getValue(data, 'budget'),
    projectId: IconFrameworkUtils.getValue(data, 'project_id'),
    projectName: IconFrameworkUtils.getValue(data, 'project_name'),
    status: IconFrameworkUtils.getValue(data, 'status'),
    createDate: IconFrameworkUtils.getValue(data, 'createdate'),
    expDate: IconFrameworkUtils.getValue(data, 'expdate'),
    contactName: IconFrameworkUtils.getValue(data, 'contact_name'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
  );
});

@RoutePage()
class OpportunityPage extends ConsumerWidget {
  const OpportunityPage({
    @PathParam('id') this.contactId = '',
    super.key,
  });

  final String contactId;

  @override
  Widget build(context, ref) {
    final opportunity = ref.watch(opportunityProvider(contactId));

    onRefresh() async {
      return ref.refresh(opportunityProvider(contactId));
    }

    toEditOpp() {
      //
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.opportunity.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: RefreshScrollView(
          onRefresh: onRefresh,
          child: SafeArea(
            child: Column(
              children: [
                opportunity.when(
                    error: (err, stack) => IconButton(
                          onPressed: onRefresh,
                          icon: const Icon(Icons.refresh),
                        ),
                    loading: () => const Loading(),
                    data: (data) {
                      final int dayLeft = data.dayLeft();

                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColor.white,
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: AppColor.grey5,
                              width: 2,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  data.contactName,
                                  color: AppColor.blue,
                                  fontSize: FontSize.px20,
                                  fontWeight: FontWeight.w500,
                                  lineOfNumber: 1,
                                ),
                                const SizedBox(width: 25),
                                if (data.canEdit)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: data.dayLeftColor(),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: CustomText(
                                      Language.translate(
                                        'screen.opportunity.day_left',
                                        translationParams: {
                                          'day': '${dayLeft > 0 ? dayLeft : 0}'
                                        },
                                      ),
                                      fontSize: FontSize.px14,
                                      color: AppColor.white,
                                    ),
                                  ),
                              ],
                            ),
                            Descriptions(
                              rows: [
                                ['module.contact.mobile', data.mobile],
                                ['screen.opportunity.start', data.createDate],
                                ['screen.opportunity.exp', data.expDate],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                const SizedBox(height: 16),
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
                            Language.translate('screen.opportunity.sub_title'),
                            color: AppColor.red,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: toEditOpp,
                          icon: Image.asset(
                            AssetPath.iconEdit,
                            height: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                opportunity.when(
                  skipLoadingOnRefresh: false,
                  error: (err, stack) => IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  loading: () => const Loading(),
                  data: (data) => OpportunityProfile(
                    opp: data,
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
