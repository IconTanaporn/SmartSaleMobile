import '../api_client.dart';

class ActivityClient {
  ActivityClient._();

  static Future calendar(type, refId, startDate, endDate) async {
    return await ApiClient.post('crm/calendar', body: {
      'stage': type,
      'reference_id': refId,
      'start_date': startDate,
      'end_date': endDate,
    });
  }

  static Future opportunityActivity(opportunityId) async {
    return await ApiClient.post('crm/log_load_by_opportunity', body: {
      'opportunity_id': opportunityId,
      'current_page': '0',
      'page_size': '200'
    });
  }

  static Future customerActivity(customerId, page, pageSize) async {
    return await ApiClient.post('crm/log_load_by_customer', body: {
      'customer_id': customerId,
      'current_page': page,
      'page_size': pageSize,
    });
  }

  static Future eventList() async {
    return await ApiClient.post('crm/masterdataMainType_loadByProcess', body: {
      'process': 'activity',
    });
  }

  static Future subEventList(eventId) async {
    return await ApiClient.post('crm/masterData_loadByProcess', body: {
      'process': 'activity',
      'main_type_id': eventId,
    });
  }

  static Future createActivity(
      projectId, type, refId, eventId, subEventId, date, time, detail) async {
    return await ApiClient.post('crm/activity_create', body: {
      'reference_id': refId,
      'event_id': eventId,
      'subevent_id': subEventId,
      'stage': type,
      'project_id': projectId,
      'date': date,
      'time': time,
      'description': detail,
    });
  }

  static Future createActivityByType(stage, type, refId) async {
    final DateTime now = DateTime.now();
    // final String date = IconFrameworkUtils.formatDate(now);
    final String time = '${now.hour}:${now.minute}';

    return await ApiClient.post('crm/activity_create_by_type_name', body: {
      'stage': stage,
      'sub_type': type,
      // 'project_id': UserProperty.getCurrentProjectId(),
      'reference_id': refId,
      // 'date': date,
      'time': time,
    });
  }
}
