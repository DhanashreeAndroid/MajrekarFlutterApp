
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:majrekar_app/login_page.dart';

import 'CommonWidget/utility.dart';
import 'controller/MainController.dart';
import 'database/ObjectBox.dart';
import 'menu_pages/menu_page.dart';
import 'model/DataModel.dart';
import 'model/UserModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final mainController = Get.put(MainController());

  apiCall(String userId, String password) async {
    alertDailog(context);

    await mainController.getToken(userId, password).then((value) {
      setState(() {
        if (mainController.tokenModel.value.accessToken == null) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid user name or password"),
          ));
        } else {
          callUserDetailsApi(mainController.tokenModel.value.accessToken, userId);
          //callLoginApi(mainController.tokenModel.value.accessToken);
        }
      });

    });
  }

  void callUserDetailsApi(String? token, String userid) async {
    await mainController.getUserData(token, userid);
    int? count = mainController.userModel.value.uDetails?.length;
    if (mainController.userModel.value.uDetails != null && count! > 0) {
      UserDetails? user = mainController.userModel.value.uDetails?.first;
      addUserDetails(user);
      callLoginApi(token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }

  }

  void addUserDetails(UserDetails? user) async {

      await ObjectBox.deleteUserDetails();
      await ObjectBox.insertUserDetails(user!);

  }

  Future<void> callMacAddress(UserDetails user, String token) async {
    final macAddress = await getDeviceIdentifier();
    if (user != null && user.macAddress != null) {
      if (macAddress == user.macAddress) {
        callLoginApi(token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This User already login in another device"),
        ));
      }
    } else {
      await mainController.saveMacAddress(
          token, macAddress!, user!.userName!);
      if (mainController.isMacSaved) {
        await ObjectBox.updateMacAddress(macAddress);

      }
    }
  }

  void callLoginApi(String? token) async {
    await mainController.getAllData(token);
    int? count = mainController.dataModel.value.eDetails?.length;
    if (mainController.dataModel.value.eDetails != null && count! > 0) {
      addOrUpdateEDetails(mainController.dataModel.value.eDetails);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }
  }

  void addOrUpdateEDetails(List<EDetails>? eDetails) async {

      await ObjectBox.deleteAll();
      await ObjectBox.insertAll(eDetails!);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuPage()));

  }


  @override
  void initState()  {
    super.initState();
        loadScreen();
  }

  Future<void> loadScreen() async {
    List<UserDetails> users = await ObjectBox.getUserDetails();
    if(users.isEmpty) {
      Timer(const Duration(seconds: 5),
              () =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) => const LoginPage()))
      );
    }else{
      apiCall(users.first.userName!, users.first.password!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.fill),
            ),
          ),
          Container(
            color: const Color.fromRGBO(255, 255, 255, 0.50),
          ),
          SizedBox(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/ic_launcher.png',
                  height: 100,
                  width: 100,),
                const SizedBox(height: 10),
                const Text("Majrekar's Voter Management\n System",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40,
                      color: Colors.black,
                      fontFamily: 'FUTURALC',
                      decoration: TextDecoration.none),),
                const Text("Search Mobile Software",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'LatoRegular',
                      decoration: TextDecoration.none),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//flutter clean

//flutter pub get

//flutter packages pub run build_runner build --delete-conflicting-outputs