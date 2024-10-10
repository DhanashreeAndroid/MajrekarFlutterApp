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
import 'package:majrekar_app/dao/maindata_dao.dart';
import 'package:majrekar_app/database/main_data_database.dart';
import 'package:majrekar_app/entities/MainData.dart';
import 'package:majrekar_app/login_page.dart';
import 'package:path_provider/path_provider.dart';

import 'CommonWidget/Constant.dart';
import 'CommonWidget/utility.dart';
import 'controller/MainController.dart';
import 'menu_pages/menu_page.dart';
import 'model/DataModel.dart';
import 'model/UserModel.dart';
import 'model/VidhansabhaModel.dart';

class SplashScreen extends StatefulWidget {
  final MainDataDao dao;
  final MainDataDatabase database;
  const SplashScreen({Key? key, required this.dao, required this.database}) : super(key: key);

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
      //await ObjectBox.updateUserDetails(user!);
  }

  Future<void> importDataOffline(UserDetails user, String token) async {
    if(user.isUpdatable == "true"){
      callBoothDataApi(token, user.userName!);
    }else{
      /*List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
      if(dbList.isNotEmpty){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MenuPage()));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const LoginPage()));
      }*/
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
    /*  await ObjectBox.deleteAllBooths();
      await ObjectBox.insertAllBooths(boothList!);*/
      saveIsUpdatableFlag(userId, token);
  }

  Future<void> saveIsUpdatableFlag(String user, String? token) async {
    await mainController.updateUserIsUpdatableFlag(
        token, user);
    if (mainController.isUpdateFlag) {
      /*List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
      if(dbList.isNotEmpty){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MenuPage()));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => const LoginPage()));
      }*/
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
    loadScreen();
  }

  Future<void> loadScreen() async {
    // previous data logic
   /* if(Constant.isOffline){
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
    }*/
    getOfflineData(context);

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
                Image.asset('images/logo.jpg',
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
   /* List<EDetails> dbList  =  await ObjectBox.getIsDataAvailable();
    if(dbList.isNotEmpty){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuPage()));
    }else{
      callGetDataFromApi(token);
    }*/
  }

  void addOrUpdateEDetails(List<EDetails>? eDetails) async {
   /* await ObjectBox.deleteAll();
    await ObjectBox.insertAll(eDetails!);*/
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MenuPage()));

  }
  Future getOfflineData(BuildContext context) async{

    List<EDetails> voterList = [];
    // await ObjectBox.deleteAll();

    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = "${directory.path}maindata1.csv";
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/maindata.csv");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    final csvFile = File(dbPath).openRead();

    List<List<dynamic>> list = await csvFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

    for(int i=1;i<list.length;i++){
      //ward no.,Partno,Serial_No,Cardno,LN_English,FN_English,LN_Marathi,FN_Marathi,Sex,Age,HouseNo_English,HouseNo_Marathi,BuildingName_English,BuildingName_marathi,EnglishBoothAddress,MarathiBoothAddress,Lang,Color,Shifted_death,Voted_Nonvoted
      var eDetails = EDetails(dbId: i.toString(), wardNo:list.elementAt(i).elementAt(0).toString(),
          partNo: list.elementAt(i).elementAt(1).toString(),
          serialNo: list.elementAt(i).elementAt(2).toString(),
          cardNo: list.elementAt(i).elementAt(3).toString(),
          lnEnglish: list.elementAt(i).elementAt(4).toString(),
          fnEnglish: list.elementAt(i).elementAt(5).toString(),
          lnMarathi: list.elementAt(i).elementAt(6).toString(),
          fnMarathi: list.elementAt(i).elementAt(7).toString(),
          sex: list.elementAt(i).elementAt(8).toString(),
          age: list.elementAt(i).elementAt(9).toString(),
          houseNoEnglish: list.elementAt(i).elementAt(10).toString(),
          houseNoMarathi: list.elementAt(i).elementAt(11).toString(),
          buildingNameEnglish: list.elementAt(i).elementAt(12).toString(),
          buildingNameMarathi: list.elementAt(i).elementAt(13).toString(),
          boothAddressEnglish: list.elementAt(i).elementAt(14).toString(),
          boothAddressMarathi: list.elementAt(i).elementAt(15).toString(),
          lang: list.elementAt(i).elementAt(16).toString(),
          color: list.elementAt(i).elementAt(17).toString(),
          shiftedDeath: list.elementAt(i).elementAt(18).toString(),
          votedNonVoted: list.elementAt(i).elementAt(19).toString()
      );
      voterList.add(eDetails);
    }
    var batch = widget.database.database.batch();

    for (var val in voterList) {
      var mainData = MainData(null,val.dbId,
          val.wardNo, val.partNo, val.serialNo, val.cardNo, val.lnEnglish, val.fnEnglish, val.lnMarathi,
          val.fnMarathi, val.sex, val.age, val.houseNoEnglish, val.houseNoMarathi, val.buildingNameEnglish,
          val.buildingNameMarathi, val.boothAddressEnglish, val.boothAddressMarathi, val.lang,
          val.color, val.shiftedDeath, val.votedNonVoted);
      batch.insert("MainData", mainData as Map<String, Object?>);

    }
    batch.commit();

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