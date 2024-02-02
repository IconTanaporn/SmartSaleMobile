import '../../api_client.dart';

class ContactClient {
  ContactClient._();

  static Future contactList(keyword, filter, page) async {
    return await ApiClient.post('crm/search', body: {
      'type': 'contacts',
      'current_page': page,
      'page_size': 10,
      'fullname': keyword,
      'filter': filter,
    });
  }

  static Future contactSearchFilter() async {
    return await ApiClient.post('crm/SearchFitter', body: {
      'type': 'contacts',
    });
  }

  static Future contactDetail() async {
    return await ApiClient.post('crm/contact_loadByID', checkNull: true, body: {
      // 'customer_id': UserProperty.getCustomerId(),
    });
  }

  static Future quickCreateContact(
      firstname, lastname, mobile, email, source) async {
    return await ApiClient.post(
      'crm/quick_create',
      body: {
        'firstname': firstname,
        'lastname': lastname,
        'mobile': mobile,
        'email': email,
        'source': source,
        // 'project_id': UserProperty.getCurrentProjectId(),
      },
      checkDup: true,
    );
  }

  static Future createContact(data) async {
    return await ApiClient.post(
      'crm/contact_create_by_idcard',
      body: {
        ...data,
        // 'project_id': UserProperty.getCurrentProjectId(),
      },
      checkDup: true,
    );
  }

  static Future questionnaire({contactId, oppId}) async {
    return await ApiClient.post('crm/questionnair_default', body: {
      // 'customer_id': contactId ?? UserProperty.getCustomerId(),
      'opp_id': oppId ?? '',
    });
  }

  static Future contactUpdate(Map<String, dynamic> updateData) async {
    return await ApiClient.post('crm/contact_update', body: updateData);
  }
}
