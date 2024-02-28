import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_controller.dart';
import '../../models/common/key_model.dart';
import '../../utils/utils.dart';

final genderListProvider = FutureProvider((ref) async {
  await IconFrameworkUtils.delayed();

  return [
    KeyModel(id: 'male', name: 'ชาย'),
    KeyModel(id: 'female', name: 'หญิง'),
    KeyModel(id: 'not_specified', name: 'ไม่ระบุ'),
  ];
});

final prefixListProvider = FutureProvider((ref) async {
  List list = await ApiController.prefixList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final nationalityListProvider = FutureProvider((ref) async {
  List list = await ApiController.nationalityList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final sourceListProvider = FutureProvider<List<KeyModel>>((ref) async {
  List list = await ApiController.sourceListLead();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});
