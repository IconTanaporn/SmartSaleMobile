import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/loading/loading.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/components/customer/contact/contact_opportunity_card.dart';
import 'package:smart_sale_mobile/utils/utils.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/refresh_indicator/refresh_scroll_view.dart';
import '../../../../components/customer/contact/contact_profile.dart';
import '../../../../config/asset_path.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/contact.dart';

final expandProvider = StateProvider.autoDispose<bool>((ref) => false);

final contactProvider = StateProvider.autoDispose((ref) => ContactDetail());

final contactDetailProvider =
    FutureProvider.autoDispose.family<ContactDetail, String>((ref, id) async {
  var data = await ApiController.contactDetail(id);
  var contact = ContactDetail(
    id: id,
    prefix: IconFrameworkUtils.getValue(data, 'prefix_name'),
    trackingAmount: IconFrameworkUtils.getValue(data, 'tracking_amount'),
    firstName: IconFrameworkUtils.getValue(data, 'firstname'),
    lastName: IconFrameworkUtils.getValue(data, 'lastname'),
    citizenId: IconFrameworkUtils.getValue(data, 'citizen_id'),
    passportId: IconFrameworkUtils.getValue(data, 'passport_id'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
    nationality: IconFrameworkUtils.getValue(data, 'nationality_name'),
    birthday: IconFrameworkUtils.getValue(data, 'birth_date'),
    email: IconFrameworkUtils.getValue(data, 'email'),
    lineId: IconFrameworkUtils.getValue(data, 'line_id'),
    weChat: IconFrameworkUtils.getValue(data, 'wechat'),
    zipCode: IconFrameworkUtils.getValue(data, 'zipcode'),
    province: IconFrameworkUtils.getValue(data, 'province'),
    district: IconFrameworkUtils.getValue(data, 'district'),
    subDistrict: IconFrameworkUtils.getValue(data, 'subdistrict'),
    houseNumber: IconFrameworkUtils.getValue(data, 'address_no'),
    village: IconFrameworkUtils.getValue(data, 'village'),
    soi: IconFrameworkUtils.getValue(data, 'soi'),
    road: IconFrameworkUtils.getValue(data, 'road'),
    address: IconFrameworkUtils.getValue(data, 'full_address'),
    country: IconFrameworkUtils.getValue(data, 'country'),
    city: IconFrameworkUtils.getValue(data, 'city'),
    source: IconFrameworkUtils.getValue(data, 'source_name'),
  );
  ref.read(contactProvider.notifier).state = contact;

  return contact;
});

final oppListProvider = FutureProvider.autoDispose
    .family<List<ContactOpportunity>, String>((ref, id) async {
  List list = await ApiController.opportunityListByContact(id);
  return list.map<ContactOpportunity>((item) {
    return ContactOpportunity(
      id: item['id'],
      name: item['name'],
      comment: item['comment'],
      projectId: item['project_id'],
      projectName: item['project_name'],
      budget: item['budget'],
      status: item['status'],
      contactId: item['contact_id'],
      contactName: item['contact_name'],
      mobile: item['mobile'],
      email: item['email'],
      createDate: item['createdate'],
      lastUpdate: item['lastupdate'],
      expDate: item['expdate'],
      salePersons: item['sale_person'],
    );
  }).toList();
});

@RoutePage()
class ContactPage extends ConsumerWidget {
  const ContactPage({
    @PathParam('id') this.contactId = '',
    @PathParam.inherit('projectId') this.projectId = '',
    super.key,
  });

  final String contactId;
  final String projectId;

  @override
  Widget build(context, ref) {
    final expand = ref.watch(expandProvider);
    final contact = ref.watch(contactDetailProvider(contactId));
    final oppList = ref.watch(oppListProvider(contactId));

    onRefresh() async {
      return ref.refresh(contactDetailProvider(contactId));
    }

    onTapExpand() {
      ref.read(expandProvider.notifier).update((state) => !state);
    }

    Future onClickOpportunity(id) async {
      context.router.pushNamed('/project/$projectId/opportunity/$id');
    }

    Future onClickEditOpportunity(id) async {
      await context.router
          .pushNamed('/project/$projectId/opportunity/$id/edit');
    }

    Future onClickDeleteOpportunity(id) async {
      context.router.pushNamed('/project/$projectId/opportunity/$id/close_job');
    }

    toEditContact() {
      //
    }

    toCreateOpp() {
      context.router
          .pushNamed('/project/$projectId/contact/$contactId/opportunity/add');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.contact.title'),
        ),
        centerTitle: true,
      ),
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
                        IconButton(
                          onPressed: toEditContact,
                          icon: Image.asset(
                            AssetPath.iconEdit,
                            height: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                contact.when(
                  error: (err, stack) => IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  loading: () => const Loading(),
                  data: (data) => Column(
                    children: [
                      ContactProfile(
                        expand: expand,
                        contact: data,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColor.white,
                          border: Border.symmetric(
                            horizontal: BorderSide(color: AppColor.grey5),
                          ),
                        ),
                        child: Material(
                          color: AppColor.white,
                          child: InkWell(
                            onTap: onTapExpand,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    Language.translate(
                                        'screen.contact.info.${!expand ? 'expand' : 'hide'}'),
                                    fontSize: FontSize.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const SizedBox(width: 10),
                                  Image.asset(
                                    !expand
                                        ? 'assets/images/icons/arrow-expand.png'
                                        : 'assets/images/icons/arrow-short.png',
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            Language.translate(
                                'screen.contact.opportunity.title'),
                            color: AppColor.red,
                            fontSize: FontSize.title,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: ButtonSize.normal,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColor.blue2,
                              AppColor.blue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: kElevationToShadow[2],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: toCreateOpp,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Center(
                                child: CustomText(
                                  Language.translate(
                                      'screen.contact.opportunity.create_button'),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                oppList.when(
                  error: (err, stack) => IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh),
                  ),
                  loading: () => const Loading(),
                  data: (data) {
                    if (data.isEmpty) {
                      return CustomText(
                        Language.translate('common.no_data'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ContactOpportunityCard(
                            opportunity: data[index],
                            onClick: () => onClickOpportunity(data[index].id),
                            onClickEdit: () =>
                                onClickEditOpportunity(data[index].id),
                            onClickDelete: () =>
                                onClickDeleteOpportunity(data[index].id),
                          ),
                        );
                      },
                    );
                  },
                ),
                // opportunityList.isNotEmpty ? opportunity : const EmptyList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
