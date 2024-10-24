import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:majrekar_app/login_page.dart';
import 'package:path_provider/path_provider.dart';

import 'CommonWidget/Constant.dart';
import 'CommonWidget/utility.dart';
import 'controller/MainController.dart';
import 'database/ObjectBox.dart';
import 'menu_pages/menu_page.dart';
import 'model/DataModel.dart';
import 'model/UserModel.dart';
import 'model/VidhansabhaModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final mainController = Get.put(MainController());
  var strMessage = "Please wait";

  apiCall(String? userId, String? password) async {
    alertDailog(context);

    await mainController.getToken(userId, password).then((value) {
      setState(() {
        if (mainController.tokenModel.value.accessToken == null) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Getting some technical error, Please tyr again."),
          ));
        } else {
          callUserDetailsApi(mainController.tokenModel.value.accessToken, userId);
        }
      });

    });
  }

  void callUserDetailsApi(String? token, String? userid) async {
    await mainController.getUserData(token, userid);
    int? count = mainController.userModel.value.uDetails?.length;
    if (mainController.userModel.value.uDetails != null && count! > 0) {
      UserDetails? user = mainController.userModel.value.uDetails?.first;
      addUserDetails(user);

      try{
        DateTime valEnd = DateTime.parse(user!.electionDate!);
        DateTime date = DateTime.now();
        bool valDate = date.isBefore(valEnd);
        if(valDate){
          importDataOffline(user, token!);
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            showAlertDialog(context);
          });
        }
      }catch(e){
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }

    } else {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }
  }

  void addUserDetails(UserDetails? user) async {
    await ObjectBox.updateUserDetails(user!);
  }

  Future<void> importDataOffline(UserDetails user, String token) async {
    if(user.isUpdatable == "true"){
      callBoothDataApi(token, user.userName!);
    }else{
      List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
      if(dbList.isNotEmpty){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MenuPage()));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const LoginPage()));
      }
    }
  }

  void callBoothDataApi(String? token, String userId) async {
    await mainController.getBoothData(token);
    int? count = mainController.boothModel.value.vidhansabhaList?.length;
    if (count!= null && count > 0) {
      addOrUpdateBoothDetail(mainController.boothModel.value.vidhansabhaList, token, userId);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }
  }

  void addOrUpdateBoothDetail(List<Vidhansabha>? boothList, String? token, String userId) async {
    await ObjectBox.deleteAllBooths();
    await ObjectBox.insertAllBooths(boothList!);
    saveIsUpdatableFlag(userId, token);
  }

  Future<void> saveIsUpdatableFlag(String user, String? token) async {
    await mainController.updateUserIsUpdatableFlag(
        token, user);
    if (mainController.isUpdateFlag) {
      List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
      if(dbList.isNotEmpty){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MenuPage()));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const LoginPage()));
      }
    }else {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }
  }

  @override
  void initState()  {
    super.initState();
  }

  Future<void> loadScreen() async {
    if(Constant.isOffline){
      if(Constant.isDateLimit){
        // App access limit condition
        DateTime valEnd = DateTime.parse(Constant.limitDate);
        DateTime date = DateTime.now();
        bool valDate = date.isBefore(valEnd);
        if(valDate) {
          List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
          if (dbList.isNotEmpty) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => const LoginPage()));
          }
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            showAlertDialog(context);
          });
        }
      }else{
        List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
        if (dbList.isNotEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuPage()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => const LoginPage()));
        }
      }

    }else {
      List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
      if (dbList.isEmpty) {
        Timer(const Duration(seconds: 1),
                () =>
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder:
                        (context) => const LoginPage()))
        );
      } else {
        List<UserDetails> users = await ObjectBox.getUserDetails();
        apiCall(users.first.userName, users.first.password);
      }
    }

  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        exit(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text("App access has expired.",
          style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.bold)),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: screenWidth,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment(0, 0),
                  image: AssetImage('images/promotional.jpg'),
                  fit: BoxFit.fill),
            ),
            alignment: Alignment.bottomCenter,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    side: const BorderSide(
                      width: 1.0,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    loadScreen();
                  },
                  child: const Text(
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Calibri',
                          fontWeight: FontWeight.bold),
                      'Next '), // trying to move to the bottom
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


//-0--------------------

  void callGetDataFromApi(String? token) async {
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

  void callGetData(String? token) async{
    List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
    if(dbList.isNotEmpty){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuPage()));
    }else{
      callGetDataFromApi(token);
    }
  }

  void addOrUpdateEDetails(List<EDetails>? eDetails) async {
    await ObjectBox.deleteAll();
    await ObjectBox.insertAll(eDetails!);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MenuPage()));

  }

//---------------------------
}




//flutter clean

//flutter pub get

//Run 'flutter pub run build_runner build' to generate the binding code required to use ObjectBox.

//Run below command while adding new object box model
//flutter packages pub run build_runner build --delete-conflicting-outputs

//to generate apk run this command
//flutter build apk --release --no-sound-null-safety

//to delete commit and recommit from git user below command
// git reset --soft HEAD~5