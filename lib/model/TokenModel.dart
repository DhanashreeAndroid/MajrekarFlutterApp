
import 'dart:convert';

TokenModel tokenModelFromJson(String str) => TokenModel.fromJson(json.decode(str));

String tokenModelToJson(TokenModel data) => json.encode(data.toJson());

class TokenModel {
  TokenModel({
    this.accessToken,
    this.tokenType,
    this.expireIn
  });

  String? accessToken;
  String? tokenType;
  int? expireIn;

  factory TokenModel.fromJson(dynamic json) => TokenModel(
       accessToken: json["access_token"] as String,
       tokenType: json["token_type"] as String,
      expireIn: json["expires_in"] as int
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
    "expires_in": expireIn
      };

  @override
  String toString() {
    return '{ ${this.accessToken}, ${this.tokenType}, ${this.expireIn} }';
  }
}


