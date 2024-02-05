import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_sale_mobile/route/router.dart';

import '../../api/api_client.dart';
import '../../api/api_controller.dart';
import '../../components/common/background/defualt_background.dart';
import '../../components/common/button/button.dart';
import '../../components/common/input/input.dart';
import '../../config/asset_path.dart';
import '../../config/constant.dart';
import '../../config/encrypted_preferences.dart';
import '../../config/language.dart';
import '../../utils/utils.dart';

//ignore_for_file: public_member_api_docs
@RoutePage()
class LoginScreen extends StatefulWidget {
  final void Function(bool isLoggedIn)? onResult;
  final bool showBackButton;
  const LoginScreen({
    Key? key,
    this.onResult,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!kReleaseMode) {
      username.text = ApiConfig.authUser;
      password.text = ApiConfig.authPass;
    }
  }

  Future fetchLogin(username, password) async {
    try {
      IconFrameworkUtils.startLoading();
      final data = await ApiController.login(username, password);
      EncryptedPref.saveAuth(jsonEncode(data).toString());
      // await ConfigFirebaseMessage.registerNotification();
      await IconFrameworkUtils.delayed();
      IconFrameworkUtils.stopLoading();
      context.router.replaceNamed('/');
    } on ApiException catch (e) {
      IconFrameworkUtils.stopLoading();
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('screen.login.alert.login_fail'),
        description: e.message,
      );
    } catch (e) {
      IconFrameworkUtils.stopLoading();
      IconFrameworkUtils.log(
        LoginRoute.name,
        'login on error',
        '$e',
      );
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('screen.login.alert.login_fail'),
        description: Language.translate(
          'screen.login.alert.check_input',
          translationParams: {
            'label': '${Language.translate(
              'screen.login.username',
            )}, ${Language.translate(
              'screen.login.password',
            )}',
          },
        ),
      );
    }
  }

  Future<bool> checkValidate() async {
    if (username.text.trim() == '') {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate('screen.login.alert.login_fail'),
        description: Language.translate(
          'screen.login.alert.check_input',
          translationParams: {
            'label': Language.translate('screen.login.username'),
          },
        ),
      );
      return false;
    }
    if (password.text.trim() == '') {
      await IconFrameworkUtils.showAlertDialog(
        title: Language.translate(
          'screen.login.alert.login_fail',
        ),
        description: Language.translate(
          'screen.login.alert.check_input',
          translationParams: {
            'label': Language.translate(
              'screen.login.password',
            ),
          },
        ),
      );
      return false;
    }
    return true;
  }

  Future onLogin() async {
    if (await checkValidate()) {
      await fetchLogin(username.text, password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultBackgroundImage(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AssetPath.logo),
                    const SizedBox(height: 15),
                    Image.asset(AssetPath.logoText),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.7),
                      child: InputText(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        radius: 40,
                        borderColor: AppColor.grey,
                        controller: username,
                        showLabel: false,
                        labelText: Language.translate(
                          'screen.login.username',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.7),
                      child: TextFieldObscure(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 0, 10),
                        controller: password,
                        hintText: Language.translate(
                          'screen.login.password',
                        ),
                        onFieldSubmitted: (value) => onLogin(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: IconFrameworkUtils.getWidth(0.7),
                      child: CustomButton(
                        height: ButtonSize.big,
                        text: Language.translate(
                          'screen.login.login',
                        ),
                        onClick: onLogin,
                        fontSize: FontSize.title,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldObscure extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry? contentPadding;

  const TextFieldObscure({
    Key? key,
    required this.controller,
    this.hintText,
    this.onFieldSubmitted,
    this.contentPadding,
  }) : super(key: key);
  @override
  State<TextFieldObscure> createState() => _TextFieldObscureState();
}

class _TextFieldObscureState extends State<TextFieldObscure> {
  bool obscureText = true;

  void onClickIcon() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputText(
      contentPadding: widget.contentPadding,
      radius: 40,
      borderColor: AppColor.grey,
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: obscureText,
      suffixIcon: IconButton(
        padding: const EdgeInsets.only(right: 20),
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColor.black2,
        ),
        onPressed: onClickIcon,
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
