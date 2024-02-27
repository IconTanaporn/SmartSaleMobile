import '../../api_client.dart';

class ContactClient {
  ContactClient._();

  static Future contactList(search, filter, page, pageSize) async {
    return await ApiClient.post('crm/search', body: {
      'type': 'contacts',
      'current_page': page,
      'page_size': pageSize,
      'fullname': search,
      'filter': filter,
    });
  }

  static Future contactSearchFilter() async {
    return await ApiClient.post('crm/SearchFitter', body: {
      'type': 'contacts',
    });
  }

  static Future contactDetail(id) async {
    return await ApiClient.post('crm/contact_loadByID', checkNull: true, body: {
      'customer_id': id,
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
      'customer_id': contactId ?? '',
      'opp_id': oppId ?? '',
    });
  }

  static Future contactUpdate(Map<String, dynamic> updateData) async {
    return await ApiClient.post('crm/contact_update', body: updateData);
  }
}
