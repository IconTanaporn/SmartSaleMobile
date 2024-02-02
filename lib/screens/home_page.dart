import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/common/background/defualt_background.dart';
import '../components/common/input/search_input.dart';
import '../components/common/text/text.dart';
import '../config/asset_path.dart';
import '../config/constant.dart';
import '../config/encrypted_preferences.dart';
import '../config/language.dart';
import '../utils/utils.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  final search = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<PackageInfo> checkPackageInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      return packageInfo;
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetPath.logoFull),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.settings),
                title: CustomText(Language.translate('screen.setting.title')),
                onTap: () {
                  // setState(() {
                  //   selectedPage = 'Settings';
                  // });
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: CustomText(
                  Language.translate('screen.setting.logout.title'),
                ),
                onTap: () async {
                  final value = await IconFrameworkUtils.showConfirmDialog(
                    title: Language.translate('screen.setting.logout.title'),
                    detail: Language.translate(
                        'screen.setting.logout.confirm_logout'),
                  );
                  if (value == AlertDialogValue.confirm) {
                    // TODO: [Logout] clear data
                    EncryptedPref.clearPreferences();

                    context.router.popUntilRoot();
                    context.router.replaceNamed('/login');
                  }
                },
              ),
              Expanded(
                child: FutureBuilder(
                  future: checkPackageInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      PackageInfo? info = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            'Version ${info?.version ?? ''}.${info?.buildNumber ?? ''}',
                            fontSize: FontSize.px12,
                          ),
                        ],
                      );
                    } else {
                      // return
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultBackgroundImage(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomText(
                      Language.translate('screen.project_list.title'),
                      color: AppColor.red,
                      fontSize: FontSize.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SearchInput(
                      controller: search,
                      // onChanged: filterProjects,
                      hintText: Language.translate(
                        'screen.project_list.search',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
