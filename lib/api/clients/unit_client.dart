import '../api_client.dart';

class UnitClient {
  UnitClient._();

  static Future sbuList(projectId) async {
    return await ApiClient.post('sbu', body: {
      'project_id': projectId,
    });
  }

  static Future unitTypeList(projectId) async {
    return await ApiClient.post('unittype', body: {
      'project_id': projectId,
    });
  }

  static Future buildingList(projectId) async {
    return await ApiClient.post('building', body: {
      'project_id': projectId,
    });
  }

  static Future floorList(projectId, buildingId) async {
    return await ApiClient.post('floor', body: {
      'project_id': projectId,
      'building_id': buildingId,
    });
  }

  static Future unitStatistics(projectId) async {
    return await ApiClient.post('available_unit', body: {
      'project_id': projectId,
    });
  }

  static Future unitList(
    sbuId,
    projectId,
    buildingId,
    floorId,
    unitTypeId,
    unitStatus,
  ) async {
    return await ApiClient.post('unit_load_formatrix', body: {
      'sbu_id': sbuId == '' ? '' : sbuId,
      'project_id': projectId,
      'tower_id': buildingId == '' ? '' : buildingId,
      'floor_id': floorId == '' ? '' : floorId,
      'model_type_id': unitTypeId == '' ? '' : unitTypeId,
      'unit_status': unitStatus == '' ? 'All' : unitStatus,
    });
  }

  static Future floorPlanDetail(
    sbuId,
    projectId,
    buildingId,
    floorId,
  ) async {
    return await ApiClient.post('plan_detail', checkNull: true, body: {
      'sbu_id': sbuId == '' ? '' : sbuId,
      'project_id': projectId,
      'tower_id': buildingId,
      'floor_id': floorId,
    });
  }

  static Future unitDetail(projectId, unitNumber) async {
    return await ApiClient.post('reservation_detail', checkNull: true, body: {
      // 'sbu_id': appConstant.sbu?.id ?? '',
      'project_id': projectId,
      'unit_number': unitNumber,
    });
  }

  static Future quotationUrl(projectId, unitId) async {
    return await ApiClient.post('url_quotation', checkNull: true, body: {
      'project_id': projectId,
      'unit_id': unitId,
    });
  }
}
