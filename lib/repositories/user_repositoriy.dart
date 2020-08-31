import 'dart:convert';

import 'package:flutter_authentication/models/user_model.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:flutter_authentication/utils/network/rest_client.dart';

class UserRepository {

  /// rest-client instance
  static final RestClient _restClient = RestClient();

  /// URL to get access token
  static final url = 'https://tesmasif-api.digitalservice.id/api/user';

  static Future<UserModel> httpGetUser() async {
    String accessToken =
    await AuthenticationRepository().readTokens().then((value) => value.accessToken);

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };

    return await _restClient.get(url, headers: headers)
        .then((dynamic res) {
          return userModelFromJson(jsonEncode(res));
        });
  }
}