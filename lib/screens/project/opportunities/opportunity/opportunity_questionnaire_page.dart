import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../api/api_controller.dart';
import '../../../../components/common/background/defualt_background.dart';
import '../../../../components/common/loading/loading.dart';
import '../../../../components/common/refresh_indicator/refresh_list_view.dart';
import '../../../../components/common/text/text.dart';
import '../../../../config/constant.dart';
import '../../../../config/language.dart';
import '../../../../route/router.dart';

class Questionnaire {
  final String id, name, subject, url;
  final String createDate, description;

  Questionnaire(
    this.id,
    this.name,
    this.subject,
    this.url,
    this.createDate,
    this.description,
  );
}

final questionnaireListProvider = FutureProvider.autoDispose
    .family<List<Questionnaire>, String>((ref, id) async {
  List list = await ApiController.opportunityQuestionnaire(id);
  return list
      .map((e) => Questionnaire(
            e['id'],
            e['form_name'],
            e['subject'],
            e['url'],
            e['create_date'],
            e['description'],
          ))
      .toList();
});

@RoutePage()
class OpportunityQuestionnairePage extends ConsumerWidget {
  const OpportunityQuestionnairePage({
    @PathParam.inherit('id') this.oppId = '',
    super.key,
  });

  final String oppId;

  @override
  Widget build(context, ref) {
    final questionnaireList = ref.watch(questionnaireListProvider(oppId));

    onRefresh() async {
      return ref.refresh(questionnaireListProvider(oppId));
    }

    onClick(Questionnaire q) {
      context.router.push(QRRoute(
        url: q.url,
        title: Language.translate('screen.opportunity.questionnaire.title'),
        detail: q.name,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.opportunity.questionnaire.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: RefreshListView(
          onRefresh: onRefresh,
          isEmpty: !questionnaireList.isLoading &&
              questionnaireList.value != null &&
              questionnaireList.value!.isEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: questionnaireList.when(
              skipLoadingOnRefresh: false,
              error: (err, stack) => IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
              ),
              loading: () => const Loading(),
              data: (data) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: data.length,
                  separatorBuilder: (context, i) {
                    return const SizedBox(height: 15);
                  },
                  itemBuilder: (context, i) {
                    var questionnaire = data[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => onClick(questionnaire),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Row(
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: CustomText(
                                                questionnaire.subject,
                                                fontSize: FontSize.title,
                                                lineOfNumber: 1,
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.red,
                                              ),
                                            ),
                                          ),
                                          CustomText(
                                            questionnaire.createDate,
                                            fontSize: FontSize.title,
                                            color: AppColor.blue,
                                          ),
                                        ],
                                      ),
                                      CustomText(
                                        questionnaire.name,
                                        lineOfNumber: 1,
                                      ),
                                      CustomText(
                                        questionnaire.description,
                                        lineOfNumber: 4,
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
