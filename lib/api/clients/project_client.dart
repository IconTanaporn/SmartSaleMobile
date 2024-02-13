import '../api_client.dart';

class ProjectClient {
  ProjectClient._();

  static Future projectList() async {
    return await ApiClient.post('project_load_forsale');
  }

  static Future conceptDetail(String id) async {
    return await ApiClient.post('concept_detail', checkNull: true, body: {
      'project_id': id,
    });
  }

  static Future facilitiesDetail() async {
    return await ApiClient.post('facilities_detail', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future factSheetDetail() async {
    return await ApiClient.post('factsheet_detail', checkNull: true, body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future brochureList() async {
    return await ApiClient.post('brochure', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future brochureSend(id, email) async {
    return await ApiClient.post('brochure_send', body: {
      // 'customer_id': UserProperty.getCustomerId(),
      'brochure_id': id,
      'email': email,
    });
  }

  static Future unitTypeList() async {
    return await ApiClient.post('unittype_list', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future unitTypeDetail(type) async {
    return await ApiClient.post('unittype_detail', checkNull: true, body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
      'model_type': type,
    });
  }

  static Future locationDetail() async {
    return await ApiClient.post('location_detail', checkNull: true, body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future galleryList() async {
    return await ApiClient.post('gallery', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
    });
  }

  static Future qrCreateContact(String projectId) async {
    return await ApiClient.post('crm/genarate_link', body: {
      'project_id': projectId,
    });
  }
}
