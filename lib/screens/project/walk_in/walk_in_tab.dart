import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/utils/utils.dart';

import '../../../api/api_controller.dart';
import '../../../components/common/loading/loading.dart';
import '../../../config/asset_path.dart';
import '../../../config/language.dart';
import '../../../route/router.dart';
import '../project_page.dart';

class QuestionnaireInput {
  final String? customerId, oppId;

  QuestionnaireInput(
    this.customerId,
    this.oppId,
  );
}

class CreateContactResponse {
  final String? customerId, oppId;
  final List duplicateList;
  final bool isSuccess;

  CreateContactResponse({
    this.customerId,
    this.oppId,
    this.duplicateList = const [],
    this.isSuccess = false,
  });
}

final questionnaireProvider =
    FutureProvider.family<dynamic, QuestionnaireInput>((ref, input) async {
  final data = await ApiController.questionnaire(
      contactId: input.customerId, oppId: input.oppId);
  return IconFrameworkUtils.getValue(data, 'questionnaire_url');
});

final qrCreateContactProvider =
    FutureProvider.autoDispose.family<String, String>((ref, id) async {
  var data = await ApiController.qrCreateContact(id);
  return IconFrameworkUtils.getValue(data, 'url');
});

@RoutePage(name: 'WalkInTab')
class WalkInTabPage extends ConsumerWidget {
  const WalkInTabPage({
    @PathParam.inherit('id') required this.projectId,
    super.key,
  });

  final String projectId;

  @override
  Widget build(context, ref) {
    ref.watch(projectDetailProvider(projectId));
    final project = ref.watch(projectProvider);
    final qrCreateContact = ref.watch(qrCreateContactProvider(projectId));

    toQrCreateContact() {
      context.router.push(QRRoute(
        url: qrCreateContact.value ?? '',
        title: Language.translate('screen.walk_in.title'),
        detail: project.name,
        isPreview: false,
      ));
    }

    toScanCard() {
      //
    }

    return AutoTabsScaffold(
      routes: [
        WalkInRoute(),
        CreateContactRoute(),
      ],
      appBarBuilder: (context, tabsRouter) {
        toCreateContact() {
          tabsRouter.setActiveIndex(1);
        }

        toWalkIn() {
          tabsRouter.setActiveIndex(0);
        }

        return AppBar(
          title: Text(Language.translate('screen.walk_in.title')),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed:
                  tabsRouter.activeIndex == 0 ? toCreateContact : toWalkIn,
              icon: Image.asset(AssetPath.buttonNewContact),
            ),
            if (tabsRouter.activeIndex == 0)
              qrCreateContact.when(
                loading: () => const Center(child: Loading(size: 25)),
                error: (err, stack) => Container(),
                data: (_) {
                  return IconButton(
                    onPressed: toQrCreateContact,
                    icon: Image.asset(
                      AssetPath.buttonScanQr,
                    ),
                  );
                },
              ),
            if (tabsRouter.activeIndex != 0)
              IconButton(
                onPressed: toScanCard,
                icon: Image.asset(
                  AssetPath.buttonScanCard,
                ),
              ),
          ],
        );
      },
    );
  }
}
