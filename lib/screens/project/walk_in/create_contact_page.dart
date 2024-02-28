import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';

import '../../../components/common/background/defualt_background.dart';
import '../../../components/common/input/input.dart';
import '../../../config/constant.dart';
import '../../../providers/master_data/address_provider.dart';
import '../../../providers/master_data/customer_provider.dart';
import '../../../utils/utils.dart';

final _isThaiProvider = FutureProvider.autoDispose((ref) async {
  final nationality = ref.watch(_nationalityProvider);

  return nationality?.name == 'ไทย' ||
      nationality?.name == 'Thai' ||
      nationality == null;
});

final _genderProvider = StateProvider.autoDispose<KeyModel?>((ref) => null);
final _prefixProvider = StateProvider.autoDispose<KeyModel?>((ref) => null);
final _nationalityProvider =
    StateProvider.autoDispose<KeyModel?>((ref) => null);

@RoutePage()
class CreateContactPage extends ConsumerWidget {
  CreateContactPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _citizenId = TextEditingController();
  final _passportId = TextEditingController();

  final _addressNo = TextEditingController();
  final _village = TextEditingController();
  final _soi = TextEditingController();
  final _road = TextEditingController();
  final _zipcode = TextEditingController();

  final _birthday = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _lineId = TextEditingController();
  final _weChat = TextEditingController();

  @override
  Widget build(context, ref) {
    // ref.watch(zipcodeListProvider2);
    final genderList = ref.watch(genderListProvider);
    final prefixList = ref.watch(prefixListProvider);
    final nationalityList = ref.watch(nationalityListProvider);
    final provinceList = ref.watch(provinceListProvider);
    final districtList = ref.watch(districtListProvider);
    final subDistrictList = ref.watch(subDistrictListProvider);
    final zipcodeList = ref.watch(zipcodeListProvider);

    final isThai = ref.watch(_isThaiProvider).value ?? true;
    final gender = ref.watch(_genderProvider);
    final prefix = ref.watch(_prefixProvider);
    final nationality = ref.watch(_nationalityProvider);
    final province = ref.watch(provinceProvider);
    final district = ref.watch(districtProvider);
    final subDistrict = ref.watch(subDistrictProvider);

    String? validate(key, value) {
      return IconFrameworkUtils.contactValidate(key, value, isThai: isThai);
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
                          ref.read(_genderProvider.notifier).state = value,
                      isLoading: genderList.isLoading,
                    ),
                    const SizedBox(height: 15),
                    InputDropdown(
                      labelText: Language.translate('module.contact.prefix'),
                      value: prefix,
                      items: prefixList.value ?? [],
                      onChanged: (value) =>
                          ref.read(_prefixProvider.notifier).state = value,
                      isLoading: prefixList.isLoading,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _firstname,
                      labelText: Language.translate('module.contact.firstname'),
                      validator: (value) => validate('firstname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _lastname,
                      labelText: Language.translate('module.contact.lastname'),
                      validator: (value) => validate('lastname', value),
                    ),
                    const SizedBox(height: 15),
                    InputDropdown(
                      labelText:
                          Language.translate('module.contact.nationality'),
                      value: nationality,
                      items: nationalityList.value ?? [],
                      onChanged: (value) =>
                          ref.read(_nationalityProvider.notifier).state = value,
                      isLoading: nationalityList.isLoading,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    InputListTile(
                      controller: _birthday,
                      labelText: Language.translate('module.contact.birthday'),
                      trailing: const Icon(
                        Icons.calendar_month,
                        size: 25,
                      ),
                      // onTap: onSelectedBirthday,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      controller: _mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      labelText: Language.translate('module.contact.email'),
                      validator: (value) => validate('email', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _lineId,
                      labelText: Language.translate('module.contact.line'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    InputText(
                      controller: _village,
                      labelText: Language.translate('module.address.village'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _soi,
                      labelText: Language.translate('module.address.soi'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: _road,
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
