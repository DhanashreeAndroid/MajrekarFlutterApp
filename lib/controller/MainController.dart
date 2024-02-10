
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:majrekar_app/model/UserModel.dart';
import 'package:majrekar_app/services/authservice/AuthService.dart';

import '../CommonWidget/snackBars.dart';
import '../model/TokenModel.dart';
import '../model/DataModel.dart';

class MainController extends GetxController{
  final authService = AuthService();
  String token = "";
  Rx<TokenModel> tokenModel = TokenModel().obs;
  Rx<DataModel> dataModel = DataModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  bool isMacSaved = false;

  Future<void> getToken(
      String? userid, String? password) async {
    await authService
        .getToken(userid!, password!)
        .then((value) {
          String body = value.body;
          print("token: $body");

      tokenModel.value = TokenModel.fromJson(jsonDecode(value.body));
    }).onError((error, stackTrace) {

    });
  }

    Future<void> getAllData(String? token) async {
      await authService
          .getAllData(token)
          .then((value) {
            if(value!=null) {
              String body = value.body;
              print("dataModel: $body");

              dataModel.value = DataModel.fromJson(jsonDecode(value.body));
              int? count = dataModel.value.eDetails?.length;
              print("getData: $count");
            }

      }).onError((error, stackTrace) {
        print(error.toString());
      });

  }

  Future<void> getUserData(String? token, String userId) async {
    await authService
        .getUserData(token,userId)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("userModel: $body");

        userModel.value = UserModel.fromJson(jsonDecode(value.body));
        int? count = userModel.value.uDetails?.length;
        print("getUserData: $count");
      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }

  Future<void> saveMacAddress(String? token, String macAddress, String userName) async {
    await authService
        .saveMacAddress(token,macAddress, userName)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("saveMacAddress: $body");

       isMacSaved = body.contains("Success")? true : false;

      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }


}