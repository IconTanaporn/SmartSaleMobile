import '../../api_client.dart';

class CustomerClient {
  CustomerClient._();

  static Future prefixList() async {
    return await ApiClient.post('crm/prefix_load');
  }

  static Future nationalityList() async {
    return await ApiClient.post('crm/nationality_load');
  }

  static Future sourceList(process) async {
    return await ApiClient.post('crm/masterdata_soucre_load', body: {
      'process': process,
    });
  }
}
