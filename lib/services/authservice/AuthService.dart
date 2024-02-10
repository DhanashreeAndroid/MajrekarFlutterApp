import 'dart:convert';
import 'dart:developer';
import '../../CommonWidget/Constant.dart';
import '../../CommonWidget/utility.dart';
import '../../data/network/BaseApiServices.dart';
import '../../data/network/NetworkApiService.dart';
import 'package:http/http.dart' as http;

import '../../model/TokenModel.dart';

class AuthService {

  Future<dynamic> getToken(String userid, String password) async {
    print(userid);

    try {
      var data = {
        "username": userid,
        "password": password,
        "grant_type" : "password"};

      print("data:  $data");

      var url = Uri.parse("${Constant.baseUrl}${Constant.jwtToken}");

      print("url $url");

      var res = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
      );
      print("Status : ${res.statusCode}");
      return res;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> getAllData(String? token) async {
    try {

      var url = Uri.parse("${Constant.baseUrl}${Constant.getData}");

      print("url $url");

      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "bearer $token",
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=1000"
        },
      );
      print("Status : ${res.statusCode}");
      return res;
    } catch (e) {
      print(e);
      return "null";
    }
  }

  Future<dynamic> getUserData(String? token, String userid) async {
    try {

      var url = Uri.parse("${Constant.baseUrl}${Constant.getUserData}/$userid");

      print("url $url");

      var res = await http.get(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "bearer $token",
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=1000"
        },
      );
      print("Status : ${res.statusCode}");
      return res;
    } catch (e) {
      print(e);
      return "null";
    }
  }

  Future<dynamic> saveMacAddress(String? token, String macAddress, String userName) async {
    print(macAddress);

    try {
      var data = {
        "username": userName,
        "macAddress": macAddress,
        "grant_type" : "password"};

      print("data:  $data");

      var url = Uri.parse("${Constant.baseUrl}${Constant.saveMacAddress}");

      print("url $url");

      var res = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "bearer $token",
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=5, max=1000"
        },
        body: data,
      );
      print("Status : ${res.statusCode}");
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
