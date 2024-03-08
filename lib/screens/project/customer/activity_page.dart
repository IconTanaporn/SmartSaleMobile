import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_sale_mobile/screens/project/customer/activity_log_page.dart';

import '../../../components/common/background/default_background.dart';
import '../../../components/common/text/text.dart';
import '../../../config/constant.dart';
import '../../../config/language.dart';

@RoutePage()
class ActivityPage extends ConsumerWidget {
  const ActivityPage({
    this.activity,
    super.key,
  });

  final dynamic activity;

  @override
  Widget build(context, ref) {
    // print(context.routeData.pathParams);
    final Activity data =
        (activity is Activity) ? activity : Activity('-', '-', '-', '-', '-');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.activity.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColor.white,
                border: Border.symmetric(
                  horizontal: BorderSide(color: AppColor.grey5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    (data.eventDate != '') ? data.eventDate : data.date ?? '',
                    color: AppColor.red,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    data.title,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomText(data.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
