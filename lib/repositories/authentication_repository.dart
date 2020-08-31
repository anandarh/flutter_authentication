import 'dart:convert';

import 'package:flutter_authentication/models/authentication_model.dart';
import 'package:flutter_authentication/utils/network/rest_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

enum TokenType { ACCESS_TOKEN, REFRESH_TOKEN }

class AuthenticationRepository {
  /// rest-client instance
  static final RestClient _restClient = RestClient();

  /// URL to get access token
  final _url =
      'https://keycloak.digitalservice.id/auth/realms/jabarprov/protocol/openid-connect/token';

  /// Create storage
  final _storage = FlutterSecureStorage();

  Future<AuthenticationModel> authenticate(
      {@required String email, @required String password}) async {
    final body = {
      'grant_type': 'password',
      'client_id': 'tes-masif-checkin',
      'username': email,
      'password': password
    };

    final response = await http.post(_url, body: body);

    if (response.statusCode == 200) {
      return authenticationModelFromJson(response.body);
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> refreshToken() async {
    String refreshToken =
        await readTokens().then((value) => value.refreshToken);

    final body = {
      'grant_type': 'refresh_token',
      'client_id': 'tes-masif-checkin',
      'refresh_token': refreshToken
    };

    return await _restClient.post(_url, body: body).then((res) async {
      return await persistTokens(authenticationModelFromJson(jsonEncode(res)));
    });
  }

  /// Delete tokens from keystore/keychain
  Future<void> deleteTokens() async {
    await _storage.deleteAll();
    return;
  }

  /// Write tokens to keystore/keychain
  Future<void> persistTokens(AuthenticationModel tokens) async {
    await _storage.write(
        key: 'tokens', value: authenticationModelToJson(tokens));
    return;
  }

  /// Check tokens from keystore/keychain
  Future<bool> hasTokens() async {
    await Future.delayed(Duration(seconds: 1));

    return await _storage.read(key: 'tokens') != null;
  }

  /// Read tokens from keystore/keychain
  Future<AuthenticationModel> readTokens() async {
    return authenticationModelFromJson(await _storage.read(key: 'tokens'));
  }

  /// Decode access token
  static Future<Map<String, dynamic>> decodeToken(TokenType type) async {
    final token = await AuthenticationRepository().readTokens().then((token) =>
        type == TokenType.ACCESS_TOKEN
            ? token.accessToken
            : token.refreshToken);
    var arrToken = token.split('.');
    String payloadToken =
        utf8.decode(base64.decode(base64.normalize(arrToken[1])));
    return jsonDecode(payloadToken);
  }

  /// Check if the token has expired
  ///
  /// If the access token has expired, perform refresh token.
  ///
  /// If the refresh token has expired, send an exception.
  static Future<bool> isTokenExpired() async {
    return await decodeToken(TokenType.ACCESS_TOKEN)
        .then((value) =>
            DateTime.fromMillisecondsSinceEpoch(value['exp'] * 1000)
                .difference(DateTime.now())
                .isNegative)
        .then((isAccessTokenExpired) async {
      if (isAccessTokenExpired) {
        return await decodeToken(TokenType.REFRESH_TOKEN)
            .then((value) =>
                DateTime.fromMillisecondsSinceEpoch(value['exp'] * 1000)
                    .difference(DateTime.now())
                    .isNegative)
            .then((isRefreshTokenExpired) async {
          if (isRefreshTokenExpired) {
            return true;
          } else {
            return await AuthenticationRepository()
                .refreshToken()
                .then((_) => false);
          }
        });
      } else {
        return false;
      }
    });
  }
}
