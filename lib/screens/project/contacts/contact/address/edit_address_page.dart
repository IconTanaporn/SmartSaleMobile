import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';
import 'package:smart_sale_mobile/screens/project/contacts/contact/contact_page.dart';

import '../../../../../api/api_client.dart';
import '../../../../../api/api_controller.dart';
import '../../../../../components/common/input/input.dart';
import '../../../../../components/common/loading/loading.dart';
import '../../../../../components/common/text/text.dart';
import '../../../../../config/constant.dart';
import '../../../../../config/language.dart';
import '../../../../../providers/master_data/address_provider.dart';
import '../../../../../utils/utils.dart';

final _zipcode = TextEditingController();

class AddressDetail {
  final String id, contactId;
  final String houseNumber, village, road, soi, zipCode, fullAddress, city;
  final KeyModel? country, province, district, subDistrict;
  Map<String, dynamic>? data;

  AddressDetail({
    this.id = '',
    this.contactId = '',
    this.houseNumber = '',
    this.village = '',
    this.road = '',
    this.soi = '',
    this.zipCode = '',
    this.city = '',
    this.country,
    this.province,
    this.district,
    this.subDistrict,
    this.fullAddress = '',
    this.data,
  });

  get isThai => _isThai();

  bool _isThai() {
    String countryName = country?.name ?? '';
    bool isThai = countryName.contains('ไทย') ||
        countryName.toLowerCase().contains('thai') ||
        countryName == '';

    return isThai;
  }
}

final _addressDetailProvider =
    FutureProvider.autoDispose.family<AddressDetail, String>((ref, id) async {
  final contact = ref.read(contactProvider);
  var data = await ApiController.addressDetail(contact.id, id);

  final address = AddressDetail(
    houseNumber: IconFrameworkUtils.getValue(data, 'address_no'),
    village: IconFrameworkUtils.getValue(data, 'village'),
    soi: IconFrameworkUtils.getValue(data, 'soi'),
    road: IconFrameworkUtils.getValue(data, 'road'),
    zipCode: IconFrameworkUtils.getValue(data, 'zipcode'),
    province: KeyModel(
      id: IconFrameworkUtils.getValue(data, 'province_id'),
      name: IconFrameworkUtils.getValue(data, 'province'),
    ),
    district: KeyModel(
      id: IconFrameworkUtils.getValue(data, 'district_id'),
      name: IconFrameworkUtils.getValue(data, 'district'),
    ),
    subDistrict: KeyModel(
      id: IconFrameworkUtils.getValue(data, 'subdistrict_id'),
      name: IconFrameworkUtils.getValue(data, 'subdistrict'),
    ),
    country: KeyModel(
      id: IconFrameworkUtils.getValue(data, 'country'),
      name: IconFrameworkUtils.getValue(data, 'country'),
    ),
    city: IconFrameworkUtils.getValue(data, 'City'),
    fullAddress: IconFrameworkUtils.getValue(data, 'full_address'),
  );

  _zipcode.text = address.zipCode;
  ref.read(zipcodeProvider.notifier).state = address.zipCode;

  final provinceList = await ref.read(provinceListProvider.future);
  ref.read(provinceProvider.notifier).state = provinceList.firstWhereOrNull(
    (e) => e.name == address.province?.name,
  );
  final districtList = await ref.read(districtListProvider.future);
  ref.read(districtProvider.notifier).state = districtList.firstWhereOrNull(
    (e) => e.name == address.district?.name,
  );
  final subDistrictList = await ref.read(subDistrictListProvider.future);
  ref.read(subDistrictProvider.notifier).state =
      subDistrictList.firstWhereOrNull(
    (e) => e.name == address.subDistrict?.name,
  );

  return address;
});

final _updateProvider = FutureProvider.autoDispose
    .family<bool, AddressDetail>((ref, updateData) async {
  IconFrameworkUtils.startLoading();
  try {
    final contact = ref.read(contactProvider);

    await ApiController.addressUpdate(contact.id, updateData.id, {
      'address_no': updateData.houseNumber,
      'village': updateData.village,
      'soi': updateData.soi,
      'road': updateData.road,
      'province': updateData.province?.name ?? '',
      'district': updateData.district?.name ?? '',
      'sub_district': updateData.subDistrict?.name ?? '',
      'zipcode': updateData.zipCode,
      'country': 'ไทย',
    });

    IconFrameworkUtils.stopLoading();
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.success'),
      detail: Language.translate('common.alert.save_complete'),
    );
    return true;
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();
    IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.fail'),
      detail: e.message,
    );
    IconFrameworkUtils.log(
      'Edit Address',
      'Update Provider',
      e.message,
    );
  }
  return false;
});

@RoutePage()
class EditAddressPage extends ConsumerWidget {
  EditAddressPage({
    @PathParam.inherit('id') this.contactId = '',
    this.type,
    super.key,
  });

  final String contactId;
  final KeyModel? type;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(context, ref) {
    final address = ref.watch(_addressDetailProvider(type?.id ?? ''));

    final provinceList = ref.watch(provinceListProvider);
    final districtList = ref.watch(districtListProvider);
    final subDistrictList = ref.watch(subDistrictListProvider);
    ref.watch(zipcodeListProvider);

    final province = ref.watch(provinceProvider);
    final district = ref.watch(districtProvider);
    final subDistrict = ref.watch(subDistrictProvider);

    Future<bool> copyAddressByCurrent(AddressDetail updateData) async {
      final list = await ref.read(addressTypeListProvider.future);
      List itemList = list
          .map((e) => {'id': e.id, 'name': e.name, 'isCheck': false})
          .where((e) => e['id'] != type?.id)
          .toList();

      final List items = await IconFrameworkUtils.showConfirmCheckboxDialog(
        title: Language.translate(
          'screen.contact.edit_address.copy_address',
          translationParams: {'label': type?.name ?? ''},
        ),
        itemList: itemList,
        enableAll: true,
      );

      items.add({
        'id': type?.id ?? '',
        'name': type?.name ?? '',
        'isCheck': true,
      });

      for (var item in items) {
        if (item['isCheck']) {
          var copyData = AddressDetail(
            id: item['id'],
            contactId: contactId,
            houseNumber: updateData.houseNumber,
            village: updateData.village,
            soi: updateData.soi,
            road: updateData.road,
            province: updateData.province,
            district: updateData.district,
            subDistrict: updateData.subDistrict,
            zipCode: updateData.zipCode,
            fullAddress: updateData.fullAddress,
            city: updateData.city,
            country: updateData.country,
          );
          bool isSuccess = await ref.read(_updateProvider(copyData).future);

          if (!isSuccess) return false;
        }
      }

      return true;
    }

    onRefresh() {
      return ref.refresh(_addressDetailProvider(type?.id ?? ''));
    }

    return address.when(
      error: (err, stack) =>
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
      loading: () => const Loading(),
      data: (data) {
        final addressNo = TextEditingController(text: data.houseNumber);
        final village = TextEditingController(text: data.village);
        final soi = TextEditingController(text: data.soi);
        final road = TextEditingController(text: data.road);

        Future onSave() async {
          if (_formKey.currentState!.validate()) {
            final updateData = AddressDetail(
              id: type?.id ?? '',
              contactId: contactId,
              houseNumber: addressNo.text,
              village: village.text,
              soi: soi.text,
              road: road.text,
              province: province,
              district: district,
              subDistrict: subDistrict,
              zipCode: _zipcode.text,
            );
            final isSuccess = await copyAddressByCurrent(updateData);

            if (isSuccess) {
              context.router.pop();
              return ref.refresh(contactDetailProvider(contactId));
            }
          } else {
            await IconFrameworkUtils.showAlertDialog(
              title: Language.translate('common.alert.alert'),
              detail: Language.translate('common.input.alert.check_validate'),
            );
          }
        }

        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    type?.name ?? '',
                    color: AppColor.red,
                    fontSize: FontSize.title,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 16),
                  InputText(
                    controller: addressNo,
                    labelText: Language.translate('module.address.address_no'),
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    controller: village,
                    labelText: Language.translate('module.address.village'),
                    required: false,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    controller: soi,
                    labelText: Language.translate('module.address.soi'),
                    required: false,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    controller: road,
                    labelText: Language.translate('module.address.road'),
                    required: false,
                  ),
                  const SizedBox(height: 15),
                  InputText(
                    controller: _zipcode,
                    labelText: Language.translate('module.address.zipcode'),
                    onChanged: (value) {
                      ref.read(zipcodeProvider.notifier).state = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  InputDropdown(
                    labelText: Language.translate('module.address.province'),
                    value: province,
                    items: provinceList.value ?? [],
                    onChanged: (value) =>
                        ref.read(provinceProvider.notifier).state = value,
                    isLoading: provinceList.isLoading,
                  ),
                  const SizedBox(height: 15),
                  InputDropdown(
                    labelText: Language.translate('module.address.district'),
                    value: district,
                    items: districtList.value ?? [],
                    onChanged: (value) =>
                        ref.read(districtProvider.notifier).state = value,
                    isLoading: districtList.isLoading,
                  ),
                  const SizedBox(height: 15),
                  InputDropdown(
                    labelText:
                        Language.translate('module.address.sub_district'),
                    value: subDistrict,
                    items: subDistrictList.value ?? [],
                    onChanged: (value) {
                      final data = subDistrictList.value!
                          .firstWhere((e) => e.id == value.id);
                      ref.read(subDistrictProvider.notifier).state = data;
                      _zipcode.text = data.zipcode;
                    },
                    isLoading: subDistrictList.isLoading,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: IconFrameworkUtils.getWidth(0.45),
                      child: CustomButton(
                        onClick: onSave,
                        text: Language.translate('common.save'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
