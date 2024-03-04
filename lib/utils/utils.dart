import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../components/common/alert/dialog.dart';
import '../components/common/alert/snack_bar_content.dart';
import '../components/common/loading/loading.dart';
import '../config/constant.dart';
import '../config/language.dart';
import 'debounce.dart';

enum AlertDialogValue { confirm, cancel, dialog }

List<CameraDescription> cameras = [];
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class IconFrameworkUtils {
  IconFrameworkUtils._();

  static void log(String tag, String title, String value) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern
        .allMatches('${DateTime.now()} $tag : $title : $value')
        .forEach((match) => debugPrint(match.group(0)));
  }

  static void fixDeviceOrientationToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void fixDeviceOrientationToLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static void resetDeviceOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static TargetPlatform getCurrentPlatform(BuildContext context) {
    return Theme.of(context).platform;
  }

  static double getWidth(double percent) {
    return MediaQuery.of(navigatorKey.currentContext!).size.width * percent;
  }

  static double getHeight(double percent) {
    return MediaQuery.of(navigatorKey.currentContext!).size.height * percent;
  }

  static bool _isNotNull(var data, String key) {
    if (data == null ||
        data[key] == null ||
        data[key] == 'nil' ||
        data[key] == 'null' ||
        data[key] == '<null>' ||
        data[key] == '<nil>') {
      return false;
    }
    return true;
  }

  static String getValue(var data, String key) {
    if (_isNotNull(data, key)) {
      return data[key].toString();
    } else {
      return '';
    }
  }

  static double getNumber(var data, String key) {
    if (_isNotNull(data, key)) {
      var number = data[key];
      if (number is num) {
        return data[key] + 0.0;
      }
      return double.tryParse(number) ?? 0.0;
    } else {
      return 0;
    }
  }

  static List getList(var value) {
    if (value != null) {
      if (value is List) {
        return value;
      }
    }
    return [];
  }

  static final NumberFormat _currencyFormat = NumberFormat('#,##0.00', 'th_TH');

  static String numberFormat(dynamic number) {
    return _currencyFormat.format(number);
  }

  static String currencyFormat(double price) {
    return '${numberFormat(price)} ${Language.translate('common.unit.baht')}';
  }

  static bool validateName(String value) {
    return !RegExp(
            r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=0-9' // <-- Notice the escaped symbols
            "'" // <-- ' is added to the expression
            ']')
        .hasMatch(value);
  }

  static bool validateNumber(String value) {
    return RegExp(r'\d').hasMatch(value);
  }

  static bool validateThaiCitizenId(String value) {
    return RegExp(r'(^[0-9]{13}$)').hasMatch(value);
  }

  /// https://regex101.com/library/E4nowz
  static bool validateThaiPhoneNumber(String value) {
    return RegExp(r'^(\+66|0)(\d{8,9}$)').hasMatch(value);
  }

  /// https://en.wikipedia.org/wiki/E.164
  static bool validatePhoneNumber(String value) {
    return RegExp(r'^(\+)?(\d{5,15}$)').hasMatch(value);
  }

  static bool validateEmail(String value) {
    return EmailValidator.validate(value);
  }

  static String? contactValidate(key, value, {bool isThai = false}) {
    final String label = Language.translate('module.contact.$key');
    final String errorText = Language.translate(
      'common.input.validate.default_validate',
      translationParams: {'label': label},
    );

    if (key == 'firstname' || key == 'lastname') {
      if (!IconFrameworkUtils.validateName(value)) {
        return errorText;
      }
    }
    if (key == 'mobile') {
      if (isThai) {
        if (!IconFrameworkUtils.validateThaiPhoneNumber(value)) {
          return errorText;
        }
      } else {
        if (!IconFrameworkUtils.validatePhoneNumber(value)) {
          return errorText;
        }
      }
    }
    if (key == 'email') {
      if (!IconFrameworkUtils.validateEmail(value)) {
        return errorText;
      }
    }
    if (key == 'citizen_id') {
      if (!IconFrameworkUtils.validateThaiCitizenId(value)) {
        return errorText;
      }
    }

    return null;
  }

  static DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static DateFormat timeFormat = DateFormat('HH:mm');

  static String getCurrentDate() {
    return dateFormat.format(DateTime.now());
  }

  static String getCurrentTime() {
    return timeFormat.format(DateTime.now());
  }

  static formatToApiDate(DateTime dateTime) {
    return apiDateFormat.format(dateTime);
  }

  static String formatDate(DateTime value) {
    return dateFormat.format(value);
  }

  static String formatTime(DateTime value) {
    return timeFormat.format(value);
  }

  static String formatThaiIDCardDate(String date) {
    DateFormat inputFormat = DateFormat('d MMM. yyyy');
    return dateFormat.format(inputFormat.parse(date));
  }

  static String formatPassportMrzDate(String yyMMdd) {
    String y = yyMMdd.substring(0, 2);
    String m = yyMMdd.substring(2, 4);
    String d = yyMMdd.substring(4, 6);
    String date = '$y/$m/$d';
    DateFormat inputFormat = DateFormat('yy/MM/dd');
    return dateFormat.format(inputFormat.parse(date));
  }

  // static Future previewUrl(String link) async {
  //   var url = Uri.parse(link);
  //
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.inAppWebView);
  //   } else {
  //     throw 'Could not launch preview url';
  //   }
  // }

  static void unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static int inputNumberDelayed = 1500;

  static Debounce debounce(milliseconds) {
    return Debounce(milliseconds: milliseconds);
  }

  static Future<void> delayed({int milliseconds = 600}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  static Future<void> delayedWithLoading({int milliseconds = 600}) async {
    startLoading();
    await delayed(milliseconds: milliseconds);
    stopLoading();
  }

  static Future<void> startLoading() async {
    await delayed(milliseconds: 0);
    return await showDialog<void>(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: Loading(),
            )
          ],
        );
      },
    );
  }

  static Future<void> stopLoading() async {
    Navigator.of(navigatorKey.currentContext!).pop();
  }

  static Future<void> showError(String errorText) async {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: AppColor.red,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SnackBarContent(
          // label: Language.translate('common.alert.fail'),
          text: errorText,
          color: AppColor.red,
          backgroundColor: AppColor.red2,
        ),
      ),
    );
  }

  static Future showAlertDialog({
    String title = '',
    String detail = '',
    String? cancelText,
  }) async {
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          onNext: () {
            Navigator.of(context).pop(AlertDialogValue.dialog);
          },
          title: title,
          detail: detail,
          nextText: cancelText ?? Language.translate('common.confirm'),
        );
      },
    );
  }

  static Future showConfirmDialog({
    String title = '',
    String detail = '',
    String? confirmText,
    String? cancelText,
    bool disable = false,
    Widget? child,
  }) async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmDialog(
          onNext: () {
            Navigator.of(context, rootNavigator: true)
                .pop(AlertDialogValue.confirm);
          },
          onCancel: () {
            Navigator.of(context, rootNavigator: true)
                .pop(AlertDialogValue.cancel);
          },
          title: title,
          detail: detail,
          nextText: confirmText ?? Language.translate('common.alert.confirm'),
          disable: disable,
          cancelText: cancelText ?? Language.translate('common.alert.cancel'),
          child: child,
        );
      },
    );
  }

  static Future showConfirmCheckboxDialog({
    String title = '',
    String description = '',
    List itemList = const [],
    String? confirmText,
    String? cancelText,
    bool enableAll = false,
  }) async {
    return await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertConfirmCheckbox(
          onNext: (itemList) {
            Navigator.of(context, rootNavigator: true).pop(itemList);
          },
          onCancel: () {
            Navigator.of(context, rootNavigator: true).pop([]);
          },
          title: title,
          itemList: itemList,
          enableAll: enableAll,
          textNext: confirmText ?? Language.translate('common.alert.confirm'),
          textCancel: cancelText ?? Language.translate('common.alert.cancel'),
        );
      },
    );
  }

  static Future showContactDialog({
    String refId = '',
    String line = '',
    String email = '',
    String tel = '',
    String stage = '',
    Function()? onEmptyLine,
    Function()? onEmptyEmail,
    Function()? onEmptyTel,
  }) async {
    return Container();
    //
    // return await showDialog(
    //   context: navigatorKey.currentContext!,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     return CustomContactDialog(
    //       refId: refId,
    //       line: line,
    //       email: email,
    //       tel: tel,
    //       stage: stage,
    //       onEmptyLine: onEmptyLine,
    //       onEmptyEmail: onEmptyEmail,
    //       onEmptyTel: onEmptyTel,
    //       onClose: () {
    //         Navigator.of(context).pop(AlertDialogValue.dialog);
    //       },
    //     );
    //   },
    // );
  }

  static Future saveBoundaryImageTemporary(
      RenderRepaintBoundary? boundary) async {
    final image = await boundary?.toImage();
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final imageBytes = byteData?.buffer.asUint8List();
    if (imageBytes != null) {
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/qr_code.png').create();
      await imagePath.writeAsBytes(imageBytes);
      return imagePath.path;
    }
    return '';
  }
}
