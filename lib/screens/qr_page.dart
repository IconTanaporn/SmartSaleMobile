import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_sale_mobile/components/common/text/text.dart';

import '../components/common/button/button.dart';
import '../components/common/loading/loading.dart';
import '../components/common/painter/dashed.dart';
import '../components/common/webview/webview.dart';
import '../config/asset_path.dart';
import '../config/constant.dart';
import '../config/language.dart';
import '../utils/utils.dart';

final _progressProvider = StateProvider.autoDispose<int>((ref) => 0);
final _previewProvider = StateProvider<bool>((ref) => false);
final _initPreviewProvider =
    FutureProvider.autoDispose.family<void, bool>((ref, value) async {
  await IconFrameworkUtils.delayed(milliseconds: 0);
  ref.read(_previewProvider.notifier).state = value;
});

@RoutePage()
class QRPage extends ConsumerWidget {
  final repaintBoundaryKey = GlobalKey();

  QRPage({
    this.url = '',
    this.title = '',
    this.detail = '',
    this.isPreview = false,
    super.key,
  });

  final String url, title, detail;
  final bool isPreview;

  Future<String> getQrImagePath() async {
    IconFrameworkUtils.startLoading();
    final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    final path = await IconFrameworkUtils.saveBoundaryImageTemporary(boundary);
    IconFrameworkUtils.stopLoading();
    return path;
  }

  shareQrImage() async {
    final path = await getQrImagePath();

    if (path != '') {
      try {
        ShareResult result = await Share.shareXFiles(
          [XFile(path)],
          sharePositionOrigin: const Rect.fromLTWH(10, 10, 10, 10),
        );

        if (result.status == ShareResultStatus.success) {
          // print(result.raw.split('.').last);
        }
      } catch (e) {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.fail'),
          detail: e.toString(),
        );
      }
    }
  }

  saveQrToLibrary() async {
    final path = await getQrImagePath();

    if (path != '') {
      try {
        final result = await ImageGallerySaver.saveFile(path);

        if (result['isSuccess']) {
          await IconFrameworkUtils.showAlertDialog(
            title: Language.translate('common.alert.save_complete'),
          );
        }
      } catch (e) {
        await IconFrameworkUtils.showAlertDialog(
          title: Language.translate('common.alert.save_fail'),
          detail: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(context, ref) {
    ref.watch(_initPreviewProvider(isPreview));

    int progress = ref.watch(_progressProvider);
    bool preview = ref.watch(_previewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(_previewProvider.notifier).update((state) => !state),
            icon: Image.asset(AssetPath.buttonScanQr),
          ),
        ],
      ),
      body: preview
          ? Stack(
              children: [
                WebView(
                  url: url.trim(),
                  onProgress: (v) =>
                      ref.read(_progressProvider.notifier).state = v,
                ),
                if (progress < 100)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Loading(color: AppColor.grey3),
                      CustomText(
                        '$progress',
                        fontSize: FontSize.title,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  )
              ],
            )
          : Stack(
              children: [
                RepaintBoundary(
                  key: repaintBoundaryKey,
                  child: Container(
                    color: AppColor.white,
                    padding: const EdgeInsets.all(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: qrCode(
                        title: title,
                        detail: detail,
                        isRepaint: true,
                      ),
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
    );
  }

  Widget qrCode({
    String title = '',
    String detail = '',
    Widget? button,
    bool isRepaint = false,
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
        if (!isRepaint)
          CustomText(
            url,
            lineOfNumber: 3,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
