
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:majrekar_app/model/UserModel.dart';
import 'package:majrekar_app/model/VidhansabhaModel.dart';
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
  Rx<VidhansabhaModel> boothModel = VidhansabhaModel().obs;
  bool isMacSaved = false;
  bool isColorSaved = false;
  bool isShiftedDeathSaved = false;
  bool isVotedNonVotedSaved = false;
  bool isUpdateFlag = false;

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
             // String body = value.body;
             // print("dataModel: $body");

              dataModel.value = DataModel.fromJson(jsonDecode(value.body));
              int? count = dataModel.value.eDetails?.length;
              print("getData: $count");
            }

      }).onError((error, stackTrace) {
        print(error.toString());
      });

  }

  Future<void> getUserData(String? token, String? userId) async {
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
  Future<void> markColorPrediction(String? token, String partNo, String serialNo, String wardNo, String color) async {
    await authService
        .markColorPrediction(token,partNo, serialNo,wardNo,color)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("markColor: $body");

        isColorSaved = body.contains("Success")? true : false;

      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }

  Future<void> markShiftedDeath(String? token, String partNo, String serialNo, String wardNo, String type) async {
    await authService
        .markShiftedDeath(token,partNo, serialNo,wardNo,type)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("markShiftedDeath: $body");

        isShiftedDeathSaved = body.contains("Success")? true : false;

      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }

  Future<void> markVotedNonVoted(String? token, String partNo, String serialNo, String wardNo, String type) async {
    await authService
        .markVotedNonVoted(token,partNo, serialNo,wardNo,type)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("markVotedNonVoted: $body");

        isVotedNonVotedSaved = body.contains("Success")? true : false;

      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }

  Future<void> getBoothData(String? token) async {
    await authService
        .getVidhansabhaData(token)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("BoothModel: $body");

        boothModel.value = VidhansabhaModel.fromJson(jsonDecode(value.body));
        int? count = boothModel.value.vidhansabhaList?.length;
        print("getBoothData: $count");
      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }

  Future<void> updateUserIsUpdatableFlag(String? token, String userid) async {
    await authService
        .updateUserIsUpdatableFlag(token, userid)
        .then((value) {
      if(value!=null) {
        String body = value.body;
        print("updateUserIsUpdatableFlag: $body");

        isUpdateFlag = body.contains("Success")? true : false;

      }

    }).onError((error, stackTrace) {
      print(error.toString());
    });

  }


}