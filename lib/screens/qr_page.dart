import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';
import 'package:smart_sale_mobile/config/language.dart';

import '../components/common/background/defualt_background.dart';
import '../components/common/button/button.dart';
import '../components/common/painter/dashed.dart';
import '../config/constant.dart';

@RoutePage()
class QRPage extends ConsumerWidget {
  final repaintBoundaryKey = GlobalKey();

  QRPage({
    this.url = '',
    this.title = '',
    this.detail = '',
    super.key,
  });

  final String url;
  final String title;
  final String detail;
  final search = TextEditingController();

  @override
  Widget build(context, ref) {
    shareQrImage() {
      print(url);
    }

    saveQrToLibrary() {
      print(url);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: Stack(
          children: [
            RepaintBoundary(
              key: repaintBoundaryKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: 400,
                color: Colors.white,
                child: qrCode(
                  title: title,
                  detail: detail,
                  hideLink: true,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: qrCode(
                    title: title,
                    detail: detail,
                    button: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 120,
                          child: CustomButton(
                            onClick: shareQrImage,
                            text: Language.translate('common.share_qr'),
                            backgroundColor: AppColor.white,
                            borderColor: AppColor.blue,
                            textColor: AppColor.blue,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 120,
                          child: CustomButton(
                            onClick: saveQrToLibrary,
                            text: Language.translate('common.save'),
                            backgroundColor: AppColor.blue,
                            borderColor: AppColor.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget qrCode({
    String title = '',
    String detail = '',
    Widget? button,
    bool hideLink = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (button == null) const SizedBox(height: 10),
        QrImageView(
          data: url,
          size: 250,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.circle,
            color: AppColor.black,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle,
            color: AppColor.black,
          ),
        ),
        if (title != '')
          CustomText(
            title,
            lineOfNumber: 2,
            textAlign: TextAlign.center,
            fontSize: FontSize.title,
            fontWeight: FontWeight.bold,
          ),
        if (button != null) button,
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: CustomPaint(painter: DashedLinePainter()),
        ),
        const SizedBox(height: 20),
        if (detail != '')
          CustomText(
            detail,
            lineOfNumber: 2,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
        if (!hideLink)
          CustomText(
            url,
            lineOfNumber: 2,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
