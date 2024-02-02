import '../../api_client.dart';

class LeadClient {
  LeadClient._();

  static Future leadList(keyword, filter, page) async {
    return await ApiClient.post('crm/search', body: {
      'type': 'leads',
      'current_page': page,
      'page_size': 10,
      'fullname': keyword,
      'filter': filter,
    });
  }

  static Future leadSearchFilter() async {
    return await ApiClient.post('crm/SearchFitter', body: {
      'type': 'leads',
    });
  }

  static Future leadDetail() async {
    return await ApiClient.post('crm/lead_loadByID', checkNull: true, body: {
      // 'lead_id': UserProperty.getCustomerId(),
    });
  }

  static Future leadQualifyList() async {
    return await ApiClient.post('crm/leadstatus');
  }

  static Future leadQualifyUpdate(statusId, comment) async {
    return await ApiClient.post(
      'crm/editstatus',
      body: {
        // 'lead_id': UserProperty.getCustomerId(),
        'lead_status': statusId,
        'reason': comment,
      },
      checkDup: true,
    );
  }

  static Future leadUpdate(Map<String, dynamic> updateData) async {
    return await ApiClient.post('crm/lead_update', body: updateData);
  }
}
