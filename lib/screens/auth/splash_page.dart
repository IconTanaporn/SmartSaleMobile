import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/api_client.dart';
import '../../api/api_controller.dart';
import '../../config/asset_path.dart';
import '../../config/encrypted_preferences.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';

//ignore_for_file: public_member_api_docs
@RoutePage()
class SplashScreen extends StatefulWidget {
  static const String screenId = '/splashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initial();
  }

  Future initial() async {
    IconFrameworkUtils.fixDeviceOrientationToPortrait();

    bool isInit = false;
    await setLanguage();
    do {
      isInit = await checkVersion();
    } while (!isInit);
    do {
      isInit = await getToken();
    } while (!isInit);
    // do {
    //   isInit = await fetchAddressTypeList();
    // } while (!isInit);

    context.router.navigateNamed('/');
  }

  Future setLanguage() async {
    try {
      await Language.setLanguage();
    } catch (e) {
      IconFrameworkUtils.log(
        SplashScreen.screenId,
        'setLanguage on error',
        e.toString(),
      );
    }
  }

  Future<bool> getToken() async {
    try {
      final value = await EncryptedPref.getToken();
      if (value != '') {
        var token = jsonDecode(value);
        var formattedDate =
            DateFormat('yyyy-MM-ddTHH:mm:ss').parse(token['expiration']);
        if (formattedDate.isBefore(DateTime.now())) {
          ApiClient.setToken(token['access_token']);
          return true;
        }
      }

      final token = await ApiController.getToken();
      EncryptedPref.saveToken(jsonEncode(token).toString());
      await IconFrameworkUtils.delayed();
      return true;
    } on ApiException catch (e) {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.fail'),
        description: e.message,
        cancelText: Language.translate('common.alert.try_again'),
      );
      return false;
    } catch (e) {
      IconFrameworkUtils.log(
        SplashScreen.screenId,
        'getToken on error',
        e.toString(),
      );
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('common.alert.fail'),
        description: 'Cannot get token.',
        cancelText: Language.translate('common.alert.try_again'),
      );
      return false;
    }
  }

  Future<bool> fetchAddressTypeList() async {
    try {
      final List list = await ApiController.addressTypeList();
      setState(() {
        // AddressTypeList.setValues(
        //   list.map<KeyDataModel>((item) {
        //     return KeyDataModel(
        //       id: item['id'],
        //       name: item['name'],
        //     );
        //   }).toList(),
        // );
      });
      return true;
    } on ApiException catch (e) {
      IconFrameworkUtils.showError(e.message);
    } catch (e) {
      IconFrameworkUtils.log(
        runtimeType.toString(),
        'fetchAddressTypeList on error',
        '$e',
      );
    }
    await IconFrameworkUtils.showAlertDialog(
      title: Language.translate('common.alert.fail'),
      description: 'Cannot initial data.',
      cancelText: Language.translate('common.alert.try_again'),
    );
    return false;
  }

  Future<bool> checkInternetConnection() async {
    return true;
    // not working
    // ConnectivityResult res = await Connectivity().checkConnectivity();
    // return res != ConnectivityResult.none;
  }

  bool checkLanguageVersion() {
    // TODO: check Language file version
    return true;
  }

  Future<bool> checkVersion() async {
    // TODO: check version
    const String version = '2.0.0';
    // final String currentVersion = (await PackageInfo.fromPlatform()).version;
    // appConstant.appVersion = currentVersion;

    return true;

    // if (version != currentVersion) {
    //   await IconFrameworkUtils.showAlertDialog(
    //     context,
    //     title: Language.translate('common.alert.fail'),
    //     description: 'Please update app version',
    //     cancelText: Language.translate('common.alert.try_again'),
    //   );
    // }
    //
    // return version == currentVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AssetPath.backgroundDefault,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AssetPath.logoCircle),
                const SizedBox(height: 20),
                Image.asset(AssetPath.iconFrameworkLogo),
                const SizedBox(height: 15),
                Image.asset(AssetPath.logoText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
