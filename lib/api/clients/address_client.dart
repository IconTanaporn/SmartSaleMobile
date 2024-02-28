// import 'package:smartsales/config/app_constant.dart' as appConstant;

import '../api_client.dart';

class AddressClient {
  AddressClient._();

  static Future addressDetail(contactId, addressId) async {
    return await ApiClient.post('crm/address_detail', checkNull: true, body: {
      'customer_id': contactId,
      'address_id': addressId,
    });
  }

  static Future provinceList() async {
    return await ApiClient.post('crm/masterdata_province_load');
  }

  static Future districtList(provinceId) async {
    return await ApiClient.post('crm/masterdata_district_load', body: {
      'province_id': provinceId,
    });
  }

  static Future subDistrictList(provinceId, districtId) async {
    return await ApiClient.post('crm/masterdata_subdistrict_load', body: {
      'province_id': provinceId,
      'district_id': districtId,
    });
  }

  static Future provinceByPostCode(postCode) async {
    return await ApiClient.post('crm/province_by_postcode', body: {
      'postcode': postCode,
    });
  }

  static Future countryList() async {
    return await ApiClient.post('crm/masterdata_country_load');
  }

  static Future addressUpdate(
      contactId, addressId, Map<String, dynamic> data) async {
    return await ApiClient.post('crm/address_update', body: {
      'customer_id': contactId,
      'address_id': addressId,
      ...data,
    });
  }

  static Future addressTypeList() async {
    return await ApiClient.post('crm/address_type_list');
  }
}
