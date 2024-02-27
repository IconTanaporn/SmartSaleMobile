import 'package:smart_sale_mobile/models/lead.dart';

enum ContactType { thai, corporation, foreigner }

enum ContactAddressType { thailand, aboard }

class ContactDetail extends LeadDetail {
  final String citizenId;
  final String passportId;
  final String nationality;
  final String birthday;
  final String weChat;
  final String zipCode;
  final String province;
  final String district;
  final String subDistrict;
  final String houseNumber;
  final String village;
  final String soi;
  final String road;
  final String address;
  final String country;
  final String city;

  ContactType _getType() {
    String n = nationality.toLowerCase();
    if (n.contains('ไทย') || n.contains('thai')) {
      return ContactType.thai;
    }

    return ContactType.foreigner;
  }

  ContactAddressType _getAddressType() {
    String n = country.toLowerCase();
    if (n.contains('ไทย') || n.contains('thai')) {
      return ContactAddressType.thailand;
    }

    return ContactAddressType.aboard;
  }

  ContactType get type => _getType();

  ContactAddressType get addressType => _getAddressType();

  ContactDetail({
    super.id = '',
    super.prefix = '',
    super.firstName = '',
    super.lastName = '',
    this.citizenId = '',
    this.passportId = '',
    super.mobile = '',
    this.nationality = '',
    this.birthday = '',
    super.email = '',
    super.lineId = '',
    this.weChat = '',
    super.trackingAmount = '',
    this.address = '',
    this.zipCode = '',
    this.country = '',
    this.city = '',
    this.province = '',
    this.district = '',
    this.subDistrict = '',
    this.houseNumber = '',
    this.village = '',
    this.soi = '',
    this.road = '',
    super.source = '',
  });
}
