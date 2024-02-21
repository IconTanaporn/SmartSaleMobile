import '../../providers/auth_provider.dart';
import '../api_client.dart';

class OpportunityClient {
  OpportunityClient._();

  static Future opportunityList() async {
    return await ApiClient.post('crm/optprojectlist');
  }

  static Future opportunityListByContact(id) async {
    return await ApiClient.post('crm/opportunity_load_by_contact', body: {
      'bu_id': user.buId,
      'contact_id': id,
      'current_page': 0,
      'page_size': '10'
    });
  }

  static Future opportunitySearchList(
      projectId, keyword, filter, page, pageSize) async {
    return await ApiClient.post('crm/search', body: {
      'type': 'opportunity',
      'project_id': projectId,
      'current_page': page,
      'page_size': pageSize,
      'fullname': keyword,
      'filter': filter,
    });
  }

  static Future opportunitySearchFilter() async {
    return await ApiClient.post('crm/SearchFitter', body: {
      'type': 'opportunity',
    });
  }

  static Future opportunityDetail(id) async {
    return await ApiClient.post('crm/opportunity_load_by_id',
        checkNull: true,
        body: {
          'opportunity_id': id,
        });
  }

  static Future opportunityCreate(projectId, budget, comment) async {
    return await ApiClient.post('crm/opportunity_create', body: {
      // 'contact_id': UserProperty.getCustomerId(),
      'project_id': projectId,
      'opportunity': '0%',
      'budget': budget,
      'comment': comment,
    });
  }

  static Future opportunityUpdate(
      id, name, projectId, contactId, budget, comment) async {
    return await ApiClient.post('crm/opportunity_update', body: {
      'id': id,
      'name': name,
      'project_id': projectId,
      'contact_id': contactId,
      'budget': budget,
      'comment': comment,
    });
  }

  static Future opportunityQuestionnaire(oppId) async {
    return await ApiClient.post('crm/questionnaire_loadAll', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
      // 'customer_id': appConstant.customerId,
      'ref_id': oppId,
    });
  }

  static Future opportunityProcessList(id) async {
    return await ApiClient.post('crm/saleProcess_loadAll', body: {
      'opportunity_id': id,
    });
  }

  static Future opportunityProcessUpdate(processId) async {
    return await ApiClient.post('crm/saleProcess_update', body: {
      // 'opportunity_id': UserProperty.getOpportunityPropertyByKey('id'),
      'sale_process_id': processId,
    });
  }

  static Future closeJobStatusList() async {
    return await ApiClient.post('crm/salestatus');
  }

  static Future closeJobReasonList(statusId) async {
    return await ApiClient.post('crm/salereason', body: {
      'status': statusId,
    });
  }

  static Future closeJob(statusId, reasonId, comment) async {
    return await ApiClient.post('crm/opportunity_statusUpdate', body: {
      // 'project_id': UserProperty.getCurrentProjectId(),
      // 'id': UserProperty.getOpportunityPropertyByKey('id'),
      'status': statusId,
      'win_lose_reason': reasonId,
      'comment': comment,
    });
  }
}
