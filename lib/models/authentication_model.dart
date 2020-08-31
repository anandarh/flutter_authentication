import 'dart:convert';

/// To parse this JSON data, do
///
/// final authenticationModel = authenticationModelFromJson(jsonString);

AuthenticationModel authenticationModelFromJson(String str) => AuthenticationModel.fromJson(json.decode(str));

String authenticationModelToJson(AuthenticationModel data) => json.encode(data.toJson());

class AuthenticationModel {
  AuthenticationModel({
    this.accessToken,
    this.refreshToken});

  String accessToken;
  String refreshToken;

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) => AuthenticationModel(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
  };
}
