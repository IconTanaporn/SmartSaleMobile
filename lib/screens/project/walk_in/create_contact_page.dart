import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/input.dart';
import '../../../config/constant.dart';
import '../../../utils/utils.dart';

final isThaiProvider = FutureProvider.autoDispose((ref) async {
  final nationality = ref.watch(nationalityProvider);

  return nationality?.name == 'ไทย' ||
      nationality?.name == 'Thai' ||
      nationality == null;
});

final genderProvider = StateProvider<KeyModel?>((ref) => null);

final genderListProvider = FutureProvider((ref) async {
  await IconFrameworkUtils.delayed();

  return [
    KeyModel(id: 'male', name: 'ชาย'),
    KeyModel(id: 'female', name: 'หญิง'),
    KeyModel(id: 'not_specified', name: 'ไม่ระบุ'),
  ];
});

final prefixProvider = StateProvider<KeyModel?>((ref) => null);

final prefixListProvider = FutureProvider((ref) async {
  List list = await ApiController.prefixList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final nationalityProvider = StateProvider<KeyModel?>((ref) => null);

final nationalityListProvider = FutureProvider((ref) async {
  List list = await ApiController.nationalityList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final provinceProvider = StateProvider<KeyModel?>((ref) => null);

final provinceListProvider = FutureProvider((ref) async {
  List list = await ApiController.provinceList();
  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

final districtProvider = StateProvider<KeyModel?>((ref) => null);

final districtListProvider = FutureProvider.autoDispose((ref) async {
  final province = ref.watch(provinceProvider);

  List list = [];

  if (province != null) {
    list = await ApiController.districtList(province.id);
  }

  return list.map((e) => KeyModel(id: e['id'], name: e['name'])).toList();
});

class SubDistract extends KeyModel {
  String zipcode = '';

  SubDistract({
    id = '',
    name = '',
    this.zipcode = '',
  }) : super(id: id, name: name);
}

final subDistrictProvider = StateProvider<SubDistract?>((ref) => null);

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

final zipcodeProvider = StateProvider<String>((ref) => '');

final zipcodeListProvider = FutureProvider.autoDispose((ref) async {
  final zipcode = ref.watch(zipcodeProvider);
  final provinceList = ref.read(provinceListProvider).value ?? [];

  if (zipcode.length == 5) {
    List list = await ApiController.provinceByPostCode(zipcode);

    if (list.isNotEmpty) {
      dynamic data = list[0];
      ref.read(provinceProvider.notifier).state =
          provinceList.firstWhere((o) => o.id == data['province_id']);
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

@RoutePage()
class CreateContactPage extends ConsumerWidget {
  CreateContactPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _citizenId = TextEditingController();
  final TextEditingController _passportId = TextEditingController();

  final TextEditingController _addressNo = TextEditingController();
  final TextEditingController _village = TextEditingController();
  final TextEditingController _soi = TextEditingController();
  final TextEditingController _road = TextEditingController();
  final TextEditingController _zipcode = TextEditingController();

  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _lineId = TextEditingController();
  final TextEditingController _weChat = TextEditingController();

  @override
  Widget build(context, ref) {
    final isThai = ref.watch(isThaiProvider).value ?? true;

    final genderList = ref.watch(genderListProvider);
    final gender = ref.watch(genderProvider);

    final prefixList = ref.watch(prefixListProvider);
    final prefix = ref.watch(prefixProvider);

    final nationalityList = ref.watch(nationalityListProvider);
    final nationality = ref.watch(nationalityProvider);

    final provinceList = ref.watch(provinceListProvider);
    final province = ref.watch(provinceProvider);

    final districtList = ref.watch(districtListProvider);
    final district = ref.watch(districtProvider);

    final subDistrictList = ref.watch(subDistrictListProvider);
    final subDistrict = ref.watch(subDistrictProvider);

    ref.watch(zipcodeListProvider2);

    String? validate(key, value) {
      final String label = Language.translate('module.contact.$key');
      final String errorText = Language.translate(
        'common.input.validate.default_validate',
        translationParams: {'label': label},
      );

      if (key == 'firstname' || key == 'lastname') {
        if (!IconFrameworkUtils.validateName(value)) {
          return errorText;
        }
      }
      if (key == 'mobile') {
        if (isThai) {
          if (!IconFrameworkUtils.validateThaiPhoneNumber(value)) {
            return errorText;
          }
        } else {
          if (!IconFrameworkUtils.validatePhoneNumber(value)) {
            return errorText;
          }
        }
      }
      if (key == 'email') {
        if (!IconFrameworkUtils.validateEmail(value)) {
          return errorText;
        }
      }
      if (key == 'citizen_id') {
        if (!IconFrameworkUtils.validateThaiCitizenId(value)) {
          return errorText;
        }
      }

      return null;
    }

    onSave() {
      if (_formKey.currentState?.validate() ?? false) {
        // print(prefix?.name);
      }
    }

    return Scaffold(
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          Language.translate('screen.walk_in.sub_title'),
                          color: AppColor.red,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InputDropdown(
                      labelText: Language.translate('module.contact.gender'),
                      value: gender,
                      items: genderList.value ?? [],
                      onChanged: (value) =>
                          ref.read(genderProvider.notifier).state = value,
                      isLoading: genderList.isLoading,
                    ),
                    const SizedBox(height: 10),
                    InputDropdown(
                      labelText: Language.translate('module.contact.prefix'),
                      value: prefix,
                      items: prefixList.value ?? [],
                      onChanged: (value) =>
                          ref.read(prefixProvider.notifier).state = value,
                      isLoading: prefixList.isLoading,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _firstname,
                      labelText: Language.translate('module.contact.firstname'),
                      validator: (value) => validate('firstname', value),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _lastname,
                      labelText: Language.translate('module.contact.lastname'),
                      validator: (value) => validate('lastname', value),
                    ),
                    const SizedBox(height: 10),
                    InputDropdown(
                      labelText:
                          Language.translate('module.contact.nationality'),
                      value: nationality,
                      items: nationalityList.value ?? [],
                      onChanged: (value) =>
                          ref.read(nationalityProvider.notifier).state = value,
                      isLoading: nationalityList.isLoading,
                    ),
                    const SizedBox(height: 10),
                    if (isThai)
                      InputText(
                        controller: _citizenId,
                        labelText:
                            Language.translate('module.contact.citizen_id'),
                        validator: (value) => validate('citizen_id', value),
                      ),
                    if (!isThai)
                      InputText(
                        controller: _passportId,
                        labelText:
                            Language.translate('module.contact.passport_id'),
                        validator: (value) => validate('passport_id', value),
                      ),
                    const SizedBox(height: 10),
                    InputListTile(
                      controller: _birthday,
                      labelText: Language.translate('module.contact.birthday'),
                      trailing: const Icon(
                        Icons.calendar_month,
                        size: 25,
                      ),
                      // onTap: onSelectedBirthday,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      controller: _mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      labelText: Language.translate('module.contact.email'),
                      validator: (value) => validate('email', value),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _lineId,
                      labelText: Language.translate('module.contact.line'),
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _weChat,
                      labelText: Language.translate('module.contact.we_chat'),
                      required: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          Language.translate('screen.walk_in.address'),
                          color: AppColor.red,
                          fontSize: FontSize.title,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InputText(
                      controller: _addressNo,
                      labelText:
                          Language.translate('module.address.address_no'),
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _village,
                      labelText: Language.translate('module.address.village'),
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _soi,
                      labelText: Language.translate('module.address.soi'),
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _road,
                      labelText: Language.translate('module.address.road'),
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    InputText(
                      controller: _zipcode,
                      labelText: Language.translate('module.address.zipcode'),
                      onChanged: (value) {
                        ref.read(zipcodeProvider.notifier).state = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    InputDropdown(
                      labelText: Language.translate('module.address.province'),
                      value: province,
                      items: provinceList.value ?? [],
                      onChanged: (value) =>
                          ref.read(provinceProvider.notifier).state = value,
                      isLoading: provinceList.isLoading,
                    ),
                    const SizedBox(height: 10),
                    InputDropdown(
                      labelText: Language.translate('module.address.district'),
                      value: district,
                      items: districtList.value ?? [],
                      onChanged: (value) =>
                          ref.read(districtProvider.notifier).state = value,
                      isLoading: districtList.isLoading,
                    ),
                    const SizedBox(height: 10),
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
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.6),
                      child: CustomButton(
                        text: Language.translate('common.save'),
                        onClick: onSave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
