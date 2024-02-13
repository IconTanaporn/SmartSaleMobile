import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../../../components/common/background/defualt_background.dart';

@RoutePage()
class ContactListPage extends ConsumerWidget {
  ContactListPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;
  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Language.translate('screen.contact_list.title')),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: SafeArea(
          child: CustomText(Language.translate('screen.contact_list.title')),
        ),
      ),
    );
  }
}
