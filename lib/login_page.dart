import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:majrekar_app/CommonWidget/Constant.dart';
import 'package:majrekar_app/controller/MainController.dart';
import 'package:majrekar_app/database/ObjectBox.dart';
import 'package:majrekar_app/menu_pages/menu_page.dart';
import 'package:majrekar_app/model/UserModel.dart';
import 'package:majrekar_app/model/VidhansabhaModel.dart';
import 'package:path_provider/path_provider.dart';

import 'CommonWidget/commonHeader.dart';
import 'CommonWidget/utility.dart';
import 'model/DataModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final mainController = Get.put(MainController());
  TextEditingController userNameController =
      TextEditingController(text: "admin");
  TextEditingController passwordController =
      TextEditingController(text: "admin123");
  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final items = List<EDetails>.generate(
      200,
      (i) => EDetails(
          dbId: '$i',
          wardNo: '155',
          partNo: '1',
          serialNo: '1',
          cardNo: 'NNX4065991',
          lnEnglish: 'JADHAV$i',
          fnEnglish: 'PARSHURAM TUKAR$i',
          lnMarathi: 'जाधव',
          fnMarathi: 'परशुराम तुकाराम',
          sex: 'M',
          age: '52',
          houseNoEnglish: '52',
          houseNoMarathi: '52',
          buildingNameEnglish:
              'Vina Nagar A 1, Phase 1 Lalbahadur Shastri Marg, Mulund West',
          buildingNameMarathi:
              'विणा नगरए-1 फेज- 1, लालबहादुर शास्त्री मार्ग, मुलुंड पश्चिम',
          boothAddressEnglish:
              'St.George School, Mulund (W) 2nd Floor, Room No.1',
          boothAddressMarathi:
              'सेंट जॉर्ज स्कूल,मुलुंड(प) दुसरा मजला खोली क्रं  1	',
          lang: 'MARATHI',
          color: '',
          shiftedDeath: '',
          votedNonVoted: ''));

  apiCall(String userId, String password) async {
    alertDailog(context);
    if(userNameFocus.hasFocus) {
      userNameFocus.unfocus();
    }
    if(passwordFocus.hasFocus) {
      passwordFocus.unfocus();
    }
    await mainController.getToken(userId, password).then((value) {
      setState(() {
        if (mainController.tokenModel.value.accessToken == null) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid user name or password"),
          ));
        } else {
          callUserDetailsApi(mainController.tokenModel.value.accessToken);
        }
      });

    });
  }

  void callUserDetailsApi(String? token) async {
      await mainController.getUserData(token, userNameController.text);
      int? count = mainController.userModel.value.uDetails?.length;
      if (mainController.userModel.value.uDetails != null && count! > 0) {
        UserDetails? user = mainController.userModel.value.uDetails?.first;
        checkForAnotherDevice(user!, token!);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Getting some technical problem, Please try again."),
        ));
      }

  }

  Future<void> checkForAnotherDevice(UserDetails user, String token) async {
    final macAddress = await getDeviceIdentifier();
    if (user.macAddress != "0") {
      print('db mac address : ${user.macAddress!}' );
      print('device mac address : $macAddress' );
      if (macAddress == user.macAddress && macAddress != "unknown") {
        if(Constant.isOffline){
          getOfflineData(context);
        }else {
          user.password = passwordController.text.toString();
          addUserDetails(user);
          callBoothDataApi(token);
        }
      } else if (macAddress == "unknown") {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unable to find mac address."),
        ));
      }else {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This User already login in another device"),
        ));
      }
    }else{
      user.password = passwordController.text.toString();
      addUserDetails(user);
      callMacAddress(user, token, macAddress!);
    }
  }

  Future<void> callMacAddress(UserDetails user, String token, String macAddress) async {

      await mainController.saveMacAddress(
          token, macAddress, user.userName!);
      if (mainController.isMacSaved) {
        await ObjectBox.updateMacAddress(macAddress);
        if(Constant.isOffline){
          getOfflineData(context);
        }else {
          callBoothDataApi(token);
        }
      }

  }

  Future<void> updateMacAddress(UserDetails user, String token) async {
    final macAddress = await getDeviceIdentifier();
    print('db mac address : ${user.macAddress!}' );
    print('device mac address : $macAddress' );

      await mainController.saveMacAddress(
          token, macAddress!, user!.userName!);
      if (mainController.isMacSaved) {
        await ObjectBox.updateMacAddress(macAddress);
        callBoothDataApi(token);
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

  void callBoothDataApi(String? token) async {
    await mainController.getBoothData(token);
    int? count = mainController.boothModel.value.vidhansabhaList?.length;
    if (count!= null && count > 0) {
      addOrUpdateBoothDetail(mainController.boothModel.value.vidhansabhaList);
      callLoginApi(token);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Getting some technical problem, Please try again."),
      ));
    }
  }

  void addOrUpdateBoothDetail(List<Vidhansabha>? boothList) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      await ObjectBox.deleteAllBooths();
      await ObjectBox.insertAllBooths(boothList!);
    }
  }


  void addOrUpdateEDetails(List<EDetails>? eDetails) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      await ObjectBox.deleteAll();
      await ObjectBox.insertAll(eDetails!);
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuPage()));
    }
  }

  void addUserDetails(UserDetails? user) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      List<UserDetails> users = await ObjectBox.getUserDetails();
      if (users.isEmpty) {
        await ObjectBox.insertUserDetails(user!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(255, 255, 255, 0.50),
          body: SafeArea(
            child: Stack(
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
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: screenWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/ic_launcher.png',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Majrekar's Voter Management\n System",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.black,
                                    fontFamily: 'FUTURALC',
                                    decoration: TextDecoration.none),
                              ),
                              const Text(
                                "Search Mobile Software",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: 'LatoRegular',
                                    decoration: TextDecoration.none),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(143, 148, 251, .2),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: userNameController,
                                        autofocus: false,
                                        focusNode: userNameFocus,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "User Name",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        obscureText: true,
                                        autofocus: false,
                                        controller: passwordController,
                                        focusNode: passwordFocus,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400])),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: SizedBox(
                                  width: 400,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      side: const BorderSide(
                                        width: 1.0,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    onPressed: () async {

                                        apiCall(userNameController.text,
                                            passwordController.text);

                                    },
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );



  }

  Future getOfflineData(BuildContext context) async{
/*
    List<EDetails> voterList = [];
    await ObjectBox.deleteAll();

    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = "${directory.path}fullvidhansabha3.csv";
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/datautfeight.csv");
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
    await ObjectBox.insertAll(voterList);
    List<EDetails> dblist =  await ObjectBox.getAll("Name");
    print("db data count : ${dblist.length}");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MenuPage()));
 */
  }


}
