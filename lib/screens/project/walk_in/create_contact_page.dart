import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';
import 'package:smart_sale_mobile/models/common/key_model.dart';
import 'package:smart_sale_mobile/screens/project/walk_in/walk_in_tab.dart';

import '../../../api/api_client.dart';
import '../../../api/api_controller.dart';
import '../../../components/common/background/default_background.dart';
import '../../../components/common/input/input.dart';
import '../../../components/common/show_picker.dart';
import '../../../components/customer/walk_in/contacts_dialog.dart';
import '../../../components/customer/walk_in/source_dialog.dart';
import '../../../config/constant.dart';
import '../../../providers/master_data/address_provider.dart';
import '../../../providers/master_data/customer_provider.dart';
import '../../../route/router.dart';
import '../../../utils/utils.dart';
import '../project_page.dart';

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

final _createContactProvider = FutureProvider.autoDispose
    .family<CreateContactResponse, Map<String, String>>((ref, input) async {
  try {
    IconFrameworkUtils.startLoading();
    final data = await ApiController.createContact(input);

    IconFrameworkUtils.stopLoading();
    return CreateContactResponse(
      customerId: IconFrameworkUtils.getValue(data, 'id'),
      oppId: IconFrameworkUtils.getValue(data, 'opp_id'),
      isSuccess: true,
    );
  } on ApiException catch (e) {
    IconFrameworkUtils.stopLoading();

    if (!e.isDuplicate()) {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.save_fail'),
        detail: e.message,
      );
    }

    return CreateContactResponse(
      duplicateList: e.body,
      isSuccess: false,
    );
  }
});

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
      return IconFrameworkUtils.contactValidate(key, value, isThai);
    }

    showDatePicker() async {
      DateTime date = _birthday.text.isNotEmpty
          ? IconFrameworkUtils.dateFormat.parse(_birthday.text)
          : DateTime.now();
      final picked = await ShowPicker.selectDate(date);

      _birthday.text = IconFrameworkUtils.dateFormat.format(picked);
    }

    toContact(id) {
      context.navigateNamedTo('/project/$projectId/contact/$id');
    }

    onReset() async {
      ref.read(_genderProvider.notifier).state = null;
      ref.read(_prefixProvider.notifier).state = null;
      ref.read(_nationalityProvider.notifier).state = null;
      ref.read(provinceProvider.notifier).state = null;
      ref.read(districtProvider.notifier).state = null;
      ref.read(subDistrictProvider.notifier).state = null;
      ref.read(zipcodeProvider.notifier).state = '';

      _firstname.clear();
      _lastname.clear();
      _citizenId.clear();
      _passportId.clear();

      _addressNo.clear();
      _village.clear();
      _soi.clear();
      _road.clear();
      _zipcode.clear();

      _birthday.clear();
      _mobile.clear();
      _email.clear();
      _lineId.clear();
      _weChat.clear();

      await IconFrameworkUtils.delayed(milliseconds: 100);

      _formKey.currentState!.reset();
    }

    Future onSuccess(firstname, lastname, id, oppId) async {
      final url = await ref
          .read(questionnaireProvider(QuestionnaireInput(id, oppId)).future);

      if (url != null) {
        await context.router.push(QRRoute(
          url: url,
          title: Language.translate('module.project.questionnaire.title'),
          detail: '$firstname $lastname',
          isPreview: true,
        ));
      }

      toContact(id);
    }

    Future onDuplicate(List list) async {
      final value = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DupContactsDialog(
            list: list
                .map((e) => DupContact(
                      IconFrameworkUtils.getValue(e, 'id'),
                      IconFrameworkUtils.getValue(e, 'name'),
                      mobile: IconFrameworkUtils.getValue(e, 'mobile'),
                      email: IconFrameworkUtils.getValue(e, 'email'),
                      citizenId: IconFrameworkUtils.getValue(e, 'citizen_id'),
                      passportId: IconFrameworkUtils.getValue(e, 'passport_id'),
                    ))
                .toList(),
          );
        },
      );

      if (value is DupContact) {
        toContact(value.id);
      }
    }

    Future onCreateContact(String source) async {
      final firstname = _firstname.text.trim();
      final lastname = _lastname.text.trim();
      final project = ref.read(projectProvider);

      final response = await ref.watch(_createContactProvider({
        'project_id': project.id,
        'gender': gender?.name ?? '',
        'prefix_id': prefix?.id ?? '',
        'firstname': firstname,
        'lastname': lastname,
        'firstname_en': firstname,
        'lastname_en': lastname,
        'nationality_id': nationality?.id ?? '',
        'citizen_id': isThai ? _citizenId.text.trim() : '',
        'passport_id': isThai ? '' : _passportId.text.trim(),
        'birth_date': _birthday.text,
        'mobile': _mobile.text.trim(),
        'email': _email.text.trim(),
        'line_id': _lineId.text.trim(),
        'wechat': _weChat.text.trim(),
        'address_no': _addressNo.text.trim(),
        'village': _village.text.trim(),
        'soi': _soi.text.trim(),
        'road': _road.text.trim(),
        'zipcode': _zipcode.text.trim(),
        'province': province?.name ?? '',
        'district': district?.name ?? '',
        'subdistrict': subDistrict?.name ?? '',
        'country': 'ไทย',
        'source': source,
      }).future);

      if (response.isSuccess) {
        onReset();
        await onSuccess(
          firstname,
          lastname,
          response.customerId,
          response.oppId,
        );
      } else if (response.duplicateList.isNotEmpty) {
        onReset();
        await onDuplicate(response.duplicateList);
      }
    }

    Future onSave() async {
      if (_formKey.currentState?.validate() ?? false) {
        final source = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const SelectSourceDialog();
          },
        );

        if (source != AlertDialogValue.cancel) {
          await onCreateContact(source);
        }
      } else {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.alert'),
          detail: Language.translate('common.input.alert.check_validate'),
        );
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
                      onTap: showDatePicker,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: IconFrameworkUtils.getWidth(0.3),
                          child: CustomButton(
                            text: Language.translate('common.cancel'),
                            backgroundColor: AppColor.grey,
                            borderColor: AppColor.grey,
                            onClick: onReset,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: IconFrameworkUtils.getWidth(0.3),
                          child: CustomButton(
                            text: Language.translate('common.save'),
                            onClick: onSave,
                          ),
                        )
                      ],
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
