import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/button/button.dart';
import 'package:smart_sale_mobile/models/contact.dart';
import 'package:smart_sale_mobile/screens/project/contacts/contact/contact_page.dart';

import '../../../../api/api_client.dart';
import '../../../../api/api_controller.dart';
import '../../../../components/common/background/default_background.dart';
import '../../../../components/common/input/input.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/common/show_picker.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../models/common/key_model.dart';
import '../../../../providers/master_data/customer_provider.dart';
import '../../../../utils/utils.dart';

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
final _sourceProvider = StateProvider.autoDispose<KeyModel?>((ref) => null);

final _initProvider = FutureProvider.autoDispose((ref) async {
  await IconFrameworkUtils.delayed(milliseconds: 0);
  final contact = ref.read(contactProvider);

  final genderList = await ref.read(genderListProvider.future);
  ref.read(_genderProvider.notifier).state = genderList.firstWhere(
    (e) => e.name == contact.gender,
    orElse: () => genderList.last,
  );

  final prefixList = await ref.read(prefixListProvider.future);
  ref.read(_prefixProvider.notifier).state = prefixList.firstWhereOrNull(
    (e) => e.name == contact.prefix,
  );

  final nationalityList = await ref.read(nationalityListProvider.future);
  ref.read(_nationalityProvider.notifier).state =
      nationalityList.firstWhereOrNull(
    (e) => e.name == contact.nationality,
  );

  final sourceList = await ref.read(sourceListProvider.future);
  ref.read(_sourceProvider.notifier).state = sourceList.firstWhereOrNull(
    (e) => e.name == contact.source,
  );
});

final _updateProvider = FutureProvider.autoDispose
    .family<bool, ContactDetail>((ref, updateData) async {
  final source = ref.read(_sourceProvider);

  IconFrameworkUtils.startLoading();
  try {
    await ApiController.contactUpdate({
      'id': updateData.id,
      'gender': updateData.gender,
      'prefix': updateData.prefix,
      'firstname': updateData.firstName,
      'lastname': updateData.lastName,
      'mobile': updateData.mobile,
      'line_id': updateData.lineId,
      'email': updateData.email,
      'source_id': source?.id ?? '',
      'source_name': source?.name ?? '',
      'nationality': updateData.nationality,
      'citizen_id': updateData.citizenId,
      'passport_id': updateData.passportId,
      'we_chat': updateData.weChat,
      'birthday': updateData.birthday,
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
      'Edit Contact',
      'Update Provider',
      e.message,
    );
  }
  return false;
});

final fullAddressProvider = FutureProvider.autoDispose((ref) async {
  final contact = ref.watch(contactProvider);

  var data = await ApiController.contactDetail(contact.id);

  return IconFrameworkUtils.getValue(data, 'full_address');
});

@RoutePage()
class EditContactPage extends ConsumerWidget {
  EditContactPage({
    @PathParam.inherit('id') this.contactId = '',
    super.key,
  });

  final String contactId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(context, ref) {
    ref.watch(_initProvider);
    final contact = ref.watch(contactProvider);
    final fullAddress = ref.watch(fullAddressProvider);
    final firstname = TextEditingController(text: contact.firstName);
    final lastname = TextEditingController(text: contact.lastName);
    final mobile = TextEditingController(text: contact.mobile);
    final email = TextEditingController(text: contact.email);
    final lineId = TextEditingController(text: contact.lineId);
    final citizenId = TextEditingController(text: contact.citizenId);
    final passportId = TextEditingController(text: contact.passportId);
    final birthday = TextEditingController(text: contact.birthday);
    final weChat = TextEditingController(text: contact.weChat);

    final genderList = ref.watch(genderListProvider);
    final prefixList = ref.watch(prefixListProvider);
    final nationalityList = ref.watch(nationalityListProvider);
    final sourceList = ref.watch(sourceListProvider);

    final isThai = ref.watch(_isThaiProvider).value ?? true;
    final gender = ref.watch(_genderProvider);
    final prefix = ref.watch(_prefixProvider);
    final nationality = ref.watch(_nationalityProvider);
    final source = ref.watch(_sourceProvider);

    String? validate(key, value) {
      return IconFrameworkUtils.contactValidate(key, value, isThai: isThai);
    }

    showDatePicker() async {
      DateTime date = IconFrameworkUtils.dateFormat.parse(birthday.text);
      final picked = await ShowPicker.selectDate(date);

      birthday.text = IconFrameworkUtils.dateFormat.format(picked);
    }

    Future onSave() async {
      if (_formKey.currentState!.validate()) {
        final isSuccess = await ref.read(_updateProvider(ContactDetail(
          id: contactId,
          gender: gender?.name ?? '',
          prefix: prefix?.name ?? '',
          firstName: firstname.text,
          lastName: lastname.text,
          nationality: nationality?.name ?? '',
          citizenId: citizenId.text,
          passportId: passportId.text,
          mobile: mobile.text,
          lineId: lineId.text,
          email: email.text,
          weChat: weChat.text,
          birthday: birthday.text,
        )).future);

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

    onRefresh() async {
      return ref.refresh(fullAddressProvider);
    }

    toEditAddress() async {
      await context.router.pushNamed('/contact/$contactId/address');
      // TODO: refresh address
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.contact.edit.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          Language.translate('screen.contact.edit.sub_title'),
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
                      controller: firstname,
                      labelText: Language.translate('module.contact.firstname'),
                      validator: (value) => validate('firstname', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: lastname,
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
                        controller: citizenId,
                        labelText:
                            Language.translate('module.contact.citizen_id'),
                        validator: (value) => validate('citizen_id', value),
                      ),
                    if (!isThai)
                      InputText(
                        controller: passportId,
                        labelText:
                            Language.translate('module.contact.passport_id'),
                        validator: (value) => validate('passport_id', value),
                      ),
                    const SizedBox(height: 15),
                    InputListTile(
                      controller: birthday,
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
                      controller: mobile,
                      labelText: Language.translate('module.contact.mobile'),
                      validator: (value) => validate('mobile', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      labelText: Language.translate('module.contact.email'),
                      validator: (value) => validate('email', value),
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: lineId,
                      labelText: Language.translate('module.contact.line'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputText(
                      controller: weChat,
                      labelText: Language.translate('module.contact.we_chat'),
                      required: false,
                    ),
                    const SizedBox(height: 15),
                    InputDropdown(
                      labelText: Language.translate('module.contact.source'),
                      value: source,
                      items: sourceList.value ?? [],
                      isLoading: sourceList.isLoading,
                      onChanged: (v) =>
                          ref.read(_sourceProvider.notifier).state = v,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              Language.translate('screen.walk_in.address'),
                              color: AppColor.red,
                              fontSize: FontSize.title,
                              fontWeight: FontWeight.bold,
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
                                onTap: toEditAddress,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CustomText(
                                      Language.translate(
                                          'screen.contact.edit.menu.edit_address'),
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    fullAddress.when(
                      skipLoadingOnRefresh: false,
                      error: (err, stack) => IconButton(
                        onPressed: onRefresh,
                        icon: const Icon(Icons.refresh),
                      ),
                      loading: () => const Loading(),
                      data: (data) => InputTextArea(
                        controller: TextEditingController(
                          text: data,
                        ),
                        labelText: Language.translate('module.contact.address'),
                        disabled: true,
                      ),
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
          ),
        ),
      ),
    );
  }
}
