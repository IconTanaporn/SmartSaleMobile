import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/language.dart';
import '../utils/utils.dart';
// import 'package:smartsales/iconframework_lib/iconframework_utils.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic body;

  ApiException(this.message, {this.body, required this.statusCode});

  @override
  String toString() {
    return message;
  }

  bool isSuccess() {
    return statusCode == 200;
  }

  bool isNotSuccess() {
    return statusCode != 200;
  }

  bool isDuplicate() {
    return message.toLowerCase().replaceAll('.', '') == 'duplicate';
  }
}

/// ### config [ApiConfig.baseUrl]
/// *to set*
/// * [ApiConfig.tokenUser]
/// * [ApiConfig.tokenPass]
/// * [ApiConfig.authUser]
/// * [ApiConfig.authPass]
class ApiConfig {
  ApiConfig._();
  static const String baseUrl = _ananda;

  /// ### [[Standard]]
  static const String _std = 'https://std-test.iconrem.com/smartsale';
  static const String _stdTest = 'https://std-test.iconrem.com/smartsale_test';

  /// ### [[Asset Five]]
  static const String _afd = 'https://afd-rem.iconframework.com';
  static const String _afdTest = 'https://afd-rem-test.iconframework.com';
  static const String _afdQas = '$_afdTest/qas_smartsale';
  static const String _afdDev = '$_afdTest/dryrun';

  /// ### [[Ananda]]
  static const String _ananda = 'https://ananda-rem-test.iconframework.com';

  /// ### [[Token]]
  /// * [Asset Five:] admin / iC0nFrAmE**1
  /// * [Ananda:] admin / password
  /// * [Standard:] iconteam / password
  static String getTokenUser() {
    switch (baseUrl) {
      case _std:
      case _stdTest:
        return 'iconteam';
      default:
        return 'admin';
    }
  }

  static String getTokenPass() {
    switch (baseUrl) {
      case _afd:
      case _afdTest:
      case _afdQas:
      case _afdDev:
        return 'iC0nFrAmE**1';
      default:
        return 'password';
    }
  }

  /// ### [[Login]]
  /// * [Asset Five:] icon_sale / password
  /// * [Ananda:] remapi / password
  /// * [Standard:] iconteam / password
  static String getAuthUser() {
    switch (baseUrl) {
      case _afd:
        return '';
      case _afdTest:
      case _afdQas:
      case _afdDev:
        return 'icon_sale';
      case _ananda:
        return 'remapi';
      case _std:
      case _stdTest:
      default:
        return 'iconteam';
    }
  }

  static String getAuthPass() {
    switch (baseUrl) {
      case _afd:
        return '';
      default:
        return 'password';
    }
  }

  static final String tokenUser = getTokenUser();
  static final String tokenPass = getTokenPass();
  static final String authUser = getAuthUser();
  static final String authPass = getAuthPass();
}

class ApiClient {
  ApiClient._();

  /// ### config [ApiConfig.baseUrl]
  /// to set *username / password* for auth
  static const String _baseUrl = ApiConfig.baseUrl;
  static const String _apiUrl = '$_baseUrl/smartsale_api';

  // TODO: CR - new gateway
  // static const String _baseUrl = 'https://cpapi-uat.onlinesecuregateway.com';
  // static const String _apiUrl = '$_baseUrl/v2/smartsales';

  static const String _appUsername = 'icon-smartsale';
  static const String _appPassword = 'password';

  static const String _currentType = 'Api Client';

  static String _token = '';
  static String _saleId = '';
  static String _buId = '';
  static String get apiUrl => _apiUrl;

  static void setToken(token) => _token = token;
  static void setSaleId(saleId) => _saleId = saleId;
  static void setBuId(buId) => _buId = buId;

  static dynamic _getValue(
    http.Response response, {
    bool checkNull = false,
    bool checkDup = false,
  }) {
    var value = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw ApiException(
        'Status Code : ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    if (value == null) {
      throw ApiException(
        'No data',
        statusCode: response.statusCode,
      );
    }

    final header = value['header'];
    final resultCode = header['resultcode'];
    final message = header['message'];

    if (resultCode == 200) {
      if (checkDup) {
        String m = message.toString().toLowerCase().replaceAll('.', '');
        if (m == 'duplicate') {
          throw ApiException(
            message,
            body: value['body'],
            statusCode: response.statusCode,
          );
        }
      }
    } else if (resultCode != 200) {
      throw ApiException(
        message,
        body: value['body'],
        statusCode: response.statusCode,
      );
    }

    if (checkNull) {
      if (value['body'] == null) {
        throw ApiException(
          'No data',
          statusCode: response.statusCode,
        );
      }
      if ((value['body'] as Map).isEmpty) {
        throw ApiException(
          'No data',
          statusCode: response.statusCode,
        );
      }
    }

    return value['body'];
  }

  static Future post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    bool checkNull = false,
    bool checkDup = false,
  }) async {
    String url = '$_apiUrl/$endpoint';

    try {
      http.Response urlResponse = await http.post(Uri.parse(url));
      if (urlResponse.statusCode != 200 && urlResponse.statusCode != 401) {
        throw ApiException(
          'Status Code : ${urlResponse.statusCode}',
          statusCode: urlResponse.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(
        e.toString(),
        statusCode: 404,
      );
    }

    var fullBody = {
      'app_username': _appUsername,
      'app_password': _appPassword,
      'sale_id': _saleId,
      'user_id_login': _saleId,
      'bu_id': _buId,
      'lg': Language.currentLanguage,
      ...(body ?? {}),
    };

    IconFrameworkUtils.log(
      _currentType,
      '$url - request data',
      fullBody.toString(),
    );

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers ??
          {
            'authorization': 'Bearer $_token',
            'content-type': 'application/json; charset=UTF-8',
          },
      body: jsonEncode(fullBody),
    );

    // TODO: CR - new gateway
    // http.Response response = await http.post(
    //   Uri.parse(_apiUrl),
    //   headers: headers ??
    //       {
    //         'authorization': 'Bearer $_token',
    //         'content-type': 'application/json; charset=UTF-8',
    //       },
    //   body: jsonEncode({
    //     'endpoint': '/$endpoint',
    //     'method': 'post',
    //     'body': fullBody,
    //   }),
    // );

    IconFrameworkUtils.log(
      _currentType,
      '$url - response',
      response.body,
    );

    return _getValue(response, checkNull: checkNull, checkDup: checkDup);
  }
}
