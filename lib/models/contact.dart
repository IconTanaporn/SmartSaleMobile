enum ContactType { thai, corporation, foreigner }

enum ContactAddressType { thailand, aboard }

class ContactDetail {
  final String id;
  final String prefix;
  final String firstName;
  final String lastName;
  final String citizenId;
  final String passportId;
  final String mobile;
  final String nationality;
  final String birthday;
  final String email;
  final String lineId;
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
  final String source;
  final String trackingAmount;

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
    this.id = '',
    this.prefix = '',
    this.firstName = '',
    this.lastName = '',
    this.citizenId = '',
    this.passportId = '',
    this.mobile = '',
    this.nationality = '',
    this.birthday = '',
    this.email = '',
    this.lineId = '',
    this.weChat = '',
    this.trackingAmount = '',
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
    this.source = '',
  });
}
