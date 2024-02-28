import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_controller.dart';
import '../../models/common/key_model.dart';
import '../../utils/utils.dart';

final provinceProvider = StateProvider<KeyModel?>((ref) => null);
final districtProvider = StateProvider<KeyModel?>((ref) => null);
final zipcodeProvider = StateProvider<String>((ref) => '');

class SubDistract extends KeyModel {
  final String zipcode;

  SubDistract({
    super.id = '',
    super.name = '',
    this.zipcode = '',
  });
}

final subDistrictProvider = StateProvider<SubDistract?>((ref) => null);

// ---------- [Master Data] ---------- //

final addressTypeListProvider = FutureProvider((ref) async {
  List list = await ApiController.addressTypeList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final countryListProvider = FutureProvider((ref) async {
  List list = await ApiController.countryList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final provinceListProvider = FutureProvider((ref) async {
  List list = await ApiController.provinceList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final districtListProvider = FutureProvider.autoDispose((ref) async {
  final province = ref.watch(provinceProvider);

  List list = [];

  if (province != null) {
    list = await ApiController.districtList(province.id);
  }

  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final subDistrictListProvider = FutureProvider.autoDispose((ref) async {
  final district = ref.watch(districtProvider);
  final province = ref.read(provinceProvider);

  List list = [];

  if (province != null && district != null) {
    list = await ApiController.subDistrictList(province.id, district.id);
  }

  return list
      .map((e) =>
          SubDistract(id: e['id'], name: e['name'], zipcode: e['postcode']))
      .toList();
});

final zipcodeListProvider = FutureProvider.autoDispose((ref) async {
  final zipcode = ref.watch(zipcodeProvider);

  if (zipcode.length == 5) {
    List list = await ApiController.provinceByPostCode(zipcode);

    if (list.isNotEmpty) {
      dynamic data = list[0];

      final provinceList = await ref.read(provinceListProvider.future);
      ref.read(provinceProvider.notifier).state =
          provinceList.firstWhere((o) => o.id == data['province_id']);

      await IconFrameworkUtils.delayed(milliseconds: 100);
      final districtList = await ref.read(districtListProvider.future);
      ref.read(districtProvider.notifier).state =
          districtList.firstWhere((o) => o.id == data['district_id']);

      await IconFrameworkUtils.delayed(milliseconds: 100);
      final subDistrictList = await ref.read(subDistrictListProvider.future);
      ref.read(subDistrictProvider.notifier).state =
          subDistrictList.firstWhere((o) => o.id == data['sub_district_id']);
    }
    return list;
  }

  return [];
});

final zipcodeListProvider2 = FutureProvider.autoDispose((ref) async {
  final list = ref.watch(zipcodeListProvider).value ?? [];

  if (list.isNotEmpty) {
    dynamic data = list.first;

    await IconFrameworkUtils.delayed(milliseconds: 100);
    final districtList = ref.watch(districtListProvider).value ?? [];
    ref.read(districtProvider.notifier).state =
        districtList.firstWhere((o) => o.id == data['district_id']);

    await IconFrameworkUtils.delayed(milliseconds: 100);
    final subDistrictList = ref.watch(subDistrictListProvider).value ?? [];
    ref.read(subDistrictProvider.notifier).state =
        subDistrictList.firstWhere((o) => o.id == data['sub_district_id']);
  }

  return null;
});
