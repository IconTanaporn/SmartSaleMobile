import 'dart:convert';

import 'package:http/http.dart' as http;

import 'clients/activity_client.dart';
import 'clients/address_client.dart';
import 'clients/auth_client.dart';
import 'clients/customer/contact_client.dart';
import 'clients/customer/customer_client.dart';
import 'clients/customer/lead_client.dart';
import 'clients/opportunity_client.dart';
import 'clients/project_client.dart';
import 'clients/unit_client.dart';

class ApiController {
  ApiController._();

  static Future loadLanguage() async {
    String url =
        'https://www.iconrem.com/application/smartsale_std_language.json';
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return utf8.decode(response.bodyBytes);
    } else {
      throw Exception('Failed $url');
    }
  }

  static Future getToken() => AuthClient.getToken();
  static Future login(username, password) =>
      AuthClient.login(username, password);
  static Future saleProfile() => AuthClient.saleProfile();
  static Future saleBuList() => AuthClient.saleBuList();

  static Future projectList() => ProjectClient.projectList();
  static Future conceptDetail(String id) => ProjectClient.conceptDetail(id);
  static Future facilitiesDetail() => ProjectClient.facilitiesDetail();
  static Future factSheetDetail() => ProjectClient.factSheetDetail();
  static Future brochureList() => ProjectClient.brochureList();
  static Future brochureSend(id, email) =>
      ProjectClient.brochureSend(id, email);
  static Future modelTypeList() => ProjectClient.unitTypeList();
  static Future modelTypeDetail(type) => ProjectClient.unitTypeDetail(type);
  static Future locationDetail() => ProjectClient.locationDetail();
  static Future galleryList() => ProjectClient.galleryList();
  static Future qrCreateContact(id) => ProjectClient.qrCreateContact(id);

  static Future prefixList() => CustomerClient.prefixList();
  static Future nationalityList() => CustomerClient.nationalityList();
  static Future sourceListLead() => CustomerClient.sourceList('lead');
  static Future sourceListContact() => CustomerClient.sourceList('contact');

  static Future contactList(keyword, filter, page) =>
      ContactClient.contactList(keyword, filter, page);
  static Future contactSearchFilter() => ContactClient.contactSearchFilter();
  static Future contactDetail() => ContactClient.contactDetail();
  static Future quickCreateContact(
          firstname, lastname, mobile, email, source) =>
      ContactClient.quickCreateContact(
          firstname, lastname, mobile, email, source);
  static Future createContact(Map<String, String> data) =>
      ContactClient.createContact(data);
  static Future questionnaire({contactId, oppId}) =>
      ContactClient.questionnaire(contactId: contactId, oppId: oppId);
  static Future contactUpdate(updateData) =>
      ContactClient.contactUpdate(updateData);

  static Future leadList(keyword, filter, page) =>
      LeadClient.leadList(keyword, filter, page);
  static Future leadSearchFilter() => LeadClient.leadSearchFilter();
  static Future leadDetail() => LeadClient.leadDetail();
  static Future leadQualifyList() => LeadClient.leadQualifyList();
  static Future leadQualifyUpdate(statusId, comment) =>
      LeadClient.leadQualifyUpdate(statusId, comment);
  static Future leadUpdate(updateData) => LeadClient.leadUpdate(updateData);

  static Future addressDetail(addressId) =>
      AddressClient.addressDetail(addressId);
  static Future provinceList() => AddressClient.provinceList();
  static Future districtList(provinceId) =>
      AddressClient.districtList(provinceId);
  static Future subDistrictList(provinceId, districtId) =>
      AddressClient.subDistrictList(provinceId, districtId);
  static Future provinceByPostCode(postCode) =>
      AddressClient.provinceByPostCode(postCode);
  static Future countryList() => AddressClient.countryList();
  static Future addressUpdate(addressId, Map<String, dynamic> data) =>
      AddressClient.addressUpdate(addressId, data);
  static Future addressTypeList() => AddressClient.addressTypeList();

  static Future calendar(stage, refId, startDate, endDate) =>
      ActivityClient.calendar(stage, refId, startDate, endDate);
  static Future opportunityActivity(opportunityId) =>
      ActivityClient.opportunityActivity(opportunityId);
  static Future customerActivity(customerId) =>
      ActivityClient.customerActivity(customerId);
  static Future eventList() => ActivityClient.eventList();
  static Future subEventList(eventId) => ActivityClient.subEventList(eventId);
  static Future createActivity(
          type, refId, eventId, subEventId, date, time, detail) =>
      ActivityClient.createActivity(
          type, refId, eventId, subEventId, date, time, detail);
  static Future createActivityByType(stage, type, refId) =>
      ActivityClient.createActivityByType(stage, type, refId);

  static Future opportunityList() => OpportunityClient.opportunityList();
  static Future opportunityListByContact(page) =>
      OpportunityClient.opportunityListByContact(page);
  static Future opportunitySearchList(
          projectId, keyword, filter, page, pageSize) =>
      OpportunityClient.opportunitySearchList(
          projectId, keyword, filter, page, pageSize);
  static Future opportunitySearchFilter() =>
      OpportunityClient.opportunitySearchFilter();
  static Future opportunityDetail() => OpportunityClient.opportunityDetail();
  static Future opportunityCreate(projectId, budget, comment) =>
      OpportunityClient.opportunityCreate(projectId, budget, comment);
  static Future opportunityUpdate(data, budget, comment) =>
      OpportunityClient.opportunityUpdate(data, budget, comment);
  static Future opportunityQuestionnaire(oppId) =>
      OpportunityClient.opportunityQuestionnaire(oppId);
  static Future opportunityProcessList() =>
      OpportunityClient.opportunityProcessList();
  static Future opportunityProcessUpdate(processId) =>
      OpportunityClient.opportunityProcessUpdate(processId);
  static Future closeJobStatusList() => OpportunityClient.closeJobStatusList();
  static Future closeJobReasonList(statusId) =>
      OpportunityClient.closeJobReasonList(statusId);
  static Future closeJob(statusId, reasonId, comment) =>
      OpportunityClient.closeJob(statusId, reasonId, comment);

  static Future sbuList(projectId) => UnitClient.sbuList(projectId);
  static Future unitTypeList(projectId) => UnitClient.unitTypeList(projectId);
  static Future buildingList(projectId) => UnitClient.buildingList(projectId);
  static Future floorList(projectId, buildingId) =>
      UnitClient.floorList(projectId, buildingId);
  static Future unitStatistics(projectId) =>
      UnitClient.unitStatistics(projectId);
  static Future unitList(
          sbuId, projectId, buildingId, floorId, unitTypeId, unitStatus) =>
      UnitClient.unitList(
          sbuId, projectId, buildingId, floorId, unitTypeId, unitStatus);
  static Future floorPlanDetail(sbuId, projectId, buildingId, floorId) =>
      UnitClient.floorPlanDetail(sbuId, projectId, buildingId, floorId);
  static Future unitDetail(projectId, unitNumber) =>
      UnitClient.unitDetail(projectId, unitNumber);
  static Future quotationUrl(projectId, unitId) =>
      UnitClient.quotationUrl(projectId, unitId);
}
