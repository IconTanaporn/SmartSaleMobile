import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/components/common/table/description.dart';

import '../../../config/constant.dart';
import '../../../config/language.dart';
import '../../../models/contact.dart';
import '../../common/expand/expand_section.dart';
import '../../common/text/text.dart';

class ContactProfile extends StatelessWidget {
  final ContactDetail contact;
  final bool expand;

  const ContactProfile({
    Key? key,
    required this.contact,
    required this.expand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpandedSection(
            expand: expand,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CustomText(
                Language.translate('screen.contact.info.title'),
                fontSize: FontSize.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Descriptions(fontSize: FontSize.normal, colon: '', rows: [
            [
              'module.contact.firstname',
              '${contact.prefix} ${contact.firstName}'.trim()
            ],
            if (expand) ['module.contact.nationality', contact.nationality],
            if (expand)
              [
                contact.type == ContactType.thai
                    ? 'module.contact.citizen_id'
                    : 'module.contact.passport_id',
                contact.type == ContactType.thai
                    ? contact.citizenId
                    : contact.passportId
              ],
            ['module.contact.mobile', contact.mobile],
            ['module.contact.email', contact.email],
            if (expand) ['module.contact.line', contact.lineId],
            if (expand) ['module.contact.we_chat', contact.weChat],
            ['module.contact.source', contact.source],
            [
              'module.contact.tracking_amount',
              '${contact.trackingAmount} ${Language.translate('common.unit.times')}'
            ],
          ]),
          ExpandedSection(
            expand: expand,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: CustomText(
                Language.translate('screen.contact.address.title'),
                fontSize: FontSize.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: ExpandedSection(
              expand: expand,
              child: Column(
                children: [
                  if (contact.addressType == ContactAddressType.aboard)
                    Descriptions(fontSize: FontSize.normal, colon: '', rows: [
                      ['module.address.address_no', contact.houseNumber],
                      ['module.address.city', contact.city],
                      ['module.address.country', contact.country],
                      ['module.address.zipcode', contact.zipCode],
                    ]),
                  if (contact.addressType == ContactAddressType.thailand)
                    Descriptions(fontSize: FontSize.normal, colon: '', rows: [
                      ['module.address.address_no', contact.houseNumber],
                      ['module.address.village', contact.village],
                      ['module.address.soi', contact.soi],
                      ['module.address.road', contact.road],
                      ['module.address.province', contact.province],
                      ['module.address.district', contact.district],
                      ['module.address.sub_district', contact.subDistrict],
                      ['module.address.zipcode', contact.zipCode],
                    ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
