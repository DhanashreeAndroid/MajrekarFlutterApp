
import 'dart:convert';

TokenModel tokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.accessToken,
    this.validityUTC,
    this.status,
    this.message,
    this.statusCode
  });

  String? accessToken;
  String? validityUTC;
  String? status;
  String? message;
  int? statusCode;

  factory TokenModel.fromJson(dynamic json) => TokenModel(
       accessToken: json["token"] as String,
       validityUTC: json["validityUTC"] as String,
       status: json["status"] as String,
       message: json["message"] as String,
       statusCode: json["status_code"] as int
      );

  Map<String, dynamic> toJson() => {
        "token": accessToken,
        "validityUTC": validityUTC,
        "status": status,
        "message": message,
        "status_code": statusCode
      };

  @override
  String toString() {
    return '{ $accessToken, $message, $validityUTC }';
  }
}


