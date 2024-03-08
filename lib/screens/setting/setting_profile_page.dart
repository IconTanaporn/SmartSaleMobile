import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_controller.dart';
import '../../components/common/background/default_background.dart';
import '../../components/common/loading/loading.dart';
import '../../components/common/text/text.dart';
import '../../config/asset_path.dart';
import '../../config/constant.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';

final saleProvider = FutureProvider.autoDispose((ref) async {
  var data = await ApiController.saleProfile();
  return Sale(
    id: IconFrameworkUtils.getValue(data, 'user_id'),
    name: IconFrameworkUtils.getValue(data, 'username'),
    firstname: IconFrameworkUtils.getValue(data, 'firstname'),
    lastname: IconFrameworkUtils.getValue(data, 'lastname'),
    email: IconFrameworkUtils.getValue(data, 'email'),
    prefix: IconFrameworkUtils.getValue(data, 'prefix'),
    gender: IconFrameworkUtils.getValue(data, 'gender'),
    birthday: IconFrameworkUtils.getValue(data, 'birth_date_string'),
    nationality: IconFrameworkUtils.getValue(data, 'nationality'),
    citizenId: IconFrameworkUtils.getValue(data, 'citizen_id'),
    mobile: IconFrameworkUtils.getValue(data, 'mobile'),
    avatar: IconFrameworkUtils.getValue(data, 'avatar'),
    address: Address(
      no: IconFrameworkUtils.getValue(data, 'address'),
      moo: IconFrameworkUtils.getValue(data, 'moo'),
      soi: IconFrameworkUtils.getValue(data, 'soi'),
      village: IconFrameworkUtils.getValue(data, 'village'),
      road: IconFrameworkUtils.getValue(data, 'road'),
      district: IconFrameworkUtils.getValue(data, 'district'),
      subDistrict: IconFrameworkUtils.getValue(data, 'subdistrict'),
      province: IconFrameworkUtils.getValue(data, 'province'),
      country: IconFrameworkUtils.getValue(data, 'country'),
      zipcode: IconFrameworkUtils.getValue(data, 'postalcode'),
    ),
  );
});

@RoutePage()
class SettingProfilePage extends ConsumerWidget {
  const SettingProfilePage({super.key});

  dataRow(String label, String value) => DataRow(
        cells: <DataCell>[
          DataCell(CustomText(
            Language.translate(label),
            color: AppColor.grey4,
          )),
          DataCell(Container(
            constraints: BoxConstraints(
              maxWidth: IconFrameworkUtils.getWidth(0.6),
              maxHeight: double.infinity,
            ),
            child: CustomText(
              value == '' ? '-' : value,
              lineOfNumber: 2,
            ),
          )),
        ],
      );

  @override
  Widget build(context, ref) {
    final sale = ref.watch(saleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.setting.profile.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: sale.when(
          loading: () => const Center(child: Loading()),
          error: (err, stack) => CustomText('Error: $err'),
          data: (data) {
            if (data.address == null) {
              return CustomText(
                Language.translate('common.no_data'),
              );
            }
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColor.grey5),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColor.grey5,
                        child: Image.asset(
                          AssetPath.iconProfile,
                          color: AppColor.white,
                          width: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: AppColor.transparent),
                        child: DataTable(
                          headingRowHeight: 0,
                          dividerThickness: 0,
                          dataRowHeight: FontSize.normal * 2,
                          columns: <DataColumn>[
                            DataColumn(label: Container()),
                            DataColumn(label: Container()),
                          ],
                          rows: <DataRow>[
                            dataRow(
                              'screen.setting.profile.firstname',
                              data.firstname,
                            ),
                            dataRow(
                              'screen.setting.profile.lastname',
                              data.lastname,
                            ),
                            dataRow(
                              'screen.setting.profile.mobile',
                              data.mobile,
                            ),
                            dataRow(
                              'screen.setting.profile.email',
                              data.email,
                            ),
                            dataRow(
                              'module.address.zipcode',
                              data.address!.zipcode,
                            ),
                            dataRow(
                              'module.address.country',
                              data.address!.country,
                            ),
                            dataRow(
                              'module.address.district',
                              data.address!.district,
                            ),
                            dataRow(
                              'module.address.sub_district',
                              data.address!.subDistrict,
                            ),
                            dataRow(
                              'module.address.village',
                              data.address!.village,
                            ),
                            dataRow(
                              'module.address.road',
                              data.address!.road,
                            ),
                            dataRow(
                              'module.address.address_no',
                              data.address!.no,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Sale {
  final String id;
  final String name;
  final String firstname;
  final String lastname;
  final String email;
  final String prefix;
  final String gender;
  final String birthday;
  final String nationality;
  final String citizenId;
  final String mobile;
  final String avatar;
  final Address? address;

  Sale({
    this.id = '',
    this.name = '',
    this.firstname = '',
    this.lastname = '',
    this.email = '',
    this.prefix = '',
    this.gender = '',
    this.birthday = '',
    this.nationality = '',
    this.citizenId = '',
    this.mobile = '',
    this.avatar = '',
    this.address,
  });
}

class Address {
  final String no;
  final String moo;
  final String soi;
  final String village;
  final String road;
  final String district;
  final String subDistrict;
  final String province;
  final String country;
  final String zipcode;

  Address({
    this.no = '',
    this.moo = '',
    this.soi = '',
    this.village = '',
    this.road = '',
    this.district = '',
    this.subDistrict = '',
    this.province = '',
    this.country = '',
    this.zipcode = '',
  });
}
