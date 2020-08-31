import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'network_exception.dart';


class RestClient {

  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = JsonDecoder();

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(String url, {Map<String, String> headers}) {
    return http.get(url, headers: headers).then((http.Response response) {
      final Map res = _decoder.convert(response.body);
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 400) {
        throw NetworkException(
            message: res.values.toList()[0], statusCode: statusCode);
      }

      return res;
    });
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final Map res = _decoder.convert(response.body);
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 400) {
        throw NetworkException(
            message: res.values.toList()[0], statusCode: statusCode);
      }

      return res;
    });
  }
}
