import '../api_client.dart';

class AuthClient {
  AuthClient._();

  static Future getToken() async {
    final data = await ApiClient.post(
      'auth/token',
      body: {
        'username': ApiConfig.tokenUser,
        'password': ApiConfig.tokenPass,
      },
      headers: {
        'content-type': 'application/json; charset=UTF-8',
      },
    );

    ApiClient.setToken(data['access_token']);

    return data;
  }

  static Future login(username, password) async {
    return await ApiClient.post('home/login', checkNull: true, body: {
      'username': username,
      'password': password,
    });
  }

  static Future saleProfile() async {
    return await ApiClient.post('user_profile_load');
  }

  static Future saleBuList() async {
    return await ApiClient.post('home/bu_list');
  }
}
