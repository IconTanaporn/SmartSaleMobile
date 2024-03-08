import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/background/default_background.dart';
import '../../components/common/text/text.dart';
import '../../config/constant.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';

@RoutePage()
class SettingLanguagePage extends ConsumerWidget {
  const SettingLanguagePage({super.key});

  static const List<String> languageList = ['th', 'en'];

  static const language = {'th': 'ภาษาไทย', 'en': 'English'};

  @override
  Widget build(context, ref) {
    Future onChangeLanguage(String lang) async {
      final value = await IconFrameworkUtils.showConfirmDialog(
        title: Language.translate('screen.setting.language.change_language'),
        detail: Language.translate(Language.translate(
          language[lang]!,
        )),
      );

      if (value == AlertDialogValue.confirm) {
        IconFrameworkUtils.startLoading();
        if (context.mounted) {
          await FlutterI18n.refresh(context, Locale(lang));
          await Language.setCurrentLanguage(lang);
          if (context.mounted) {
            Phoenix.rebirth(context);
          }
        }
        IconFrameworkUtils.stopLoading();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Language.translate('screen.setting.language.title'),
        ),
        centerTitle: true,
      ),
      body: DefaultBackgroundImage(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: languageList.length,
          itemBuilder: (context, i) {
            final String lang = languageList[i];

            void onTap() {
              onChangeLanguage(lang);
            }

            return SizedBox(
              width: double.infinity,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColor.grey5),
                    bottom: BorderSide(color: AppColor.grey5),
                  ),
                  color: AppColor.white,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Radio<String>(
                              value: lang,
                              groupValue: Language.currentLanguage,
                              onChanged: (_) => onTap(),
                              activeColor: AppColor.red,
                            ),
                            CustomText(
                              language[lang] ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
