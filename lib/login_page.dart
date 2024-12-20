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
      TextEditingController();
  TextEditingController passwordController =
      TextEditingController();
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
    if (userNameFocus.hasFocus) {
      userNameFocus.unfocus();
    }
    if (passwordFocus.hasFocus) {
      passwordFocus.unfocus();
    }
    await mainController.getToken(userId, password).then((value) {
      setState(() {
        if (mainController.tokenModel.value.accessToken == null) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Getting some technical error, Please tyr again."),
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
    final macAddress = await getDeviceIdentifier(context);
    if (user.macAddress != "0") {
      print('db mac address : ${user.macAddress!}');
      print('device mac address : $macAddress');
      if (macAddress == user.macAddress && macAddress != "unknown") {
          user.password = passwordController.text.toString();
          addUserDetails(user);
          importDataOffline();
      } else if (macAddress == "unknown") {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unable to find mac address."),
        ));
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("This User already login in another device"),
        ));
      }
    } else {
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
        importDataOffline();
      }
  }

  Future<void> importDataOffline() async {
      await getOfflineVotingAddressData(context);
      await getOfflineData(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPage()));
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
                                'images/logo.jpg',
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
                                      if(Constant.isOffline){
                                        offlineDataProcessing(context);
                                      }else{
                                        apiCall(userNameController.text,
                                            passwordController.text);
                                      }
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

  Future<void> offlineDataProcessing(BuildContext context) async {
    alertDailog(context);
    String userName = userNameController.text;
    String pass = passwordController.text;
    if(userName.isEmpty && pass.isEmpty){
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please add user name or password"),
      ));
    }else{
     if(userName == Constant.userName && pass == Constant.password){
      await getOfflineVotingAddressData(context);
      await getOfflineData(context);
     }else{
       Navigator.of(context, rootNavigator: true).pop();
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
         content: Text("Invalid user name or password"),
       ));
     }
    }
  }

  Future getOfflineVotingAddressData(BuildContext context) async{

    List<Vidhansabha> addressList = [];
    await ObjectBox.deleteAllBooths();

    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = "${directory.path}${Constant.votingAddressCsvTemp}";
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/votingaddress.csv");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    final csvFile = File(dbPath).openRead();

    List<List<dynamic>> list = await csvFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

    for(int i=1;i<list.length;i++){
      var eDetails = Vidhansabha(
          dbId: i.toString(),
          wardNo:list.elementAt(i).elementAt(0).toString(),
          partNo: list.elementAt(i).elementAt(1).toString(),
          from: list.elementAt(i).elementAt(2).toString(),
          to: list.elementAt(i).elementAt(3).toString(),
          boothAddressEnglish: list.elementAt(i).elementAt(4).toString(),
          boothAddressMarathi: list.elementAt(i).elementAt(5).toString()
      );
      addressList.add(eDetails);
    }
    await ObjectBox.insertAllBooths(addressList);
    List<Vidhansabha> dblist =  await ObjectBox.getAllBooths();
    print("db voting address count : ${dblist.length}");

  }


  Future getOfflineData(BuildContext context) async{

    List<EDetails> voterList = [];
    await ObjectBox.deleteAll();

    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = "${directory.path}${Constant.mainDataCsvTemp}";
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
    await ObjectBox.insertAll(voterList);
    List<EDetails> dblist =  await ObjectBox.getAll("Name");
    print("db data count : ${dblist.length}");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MenuPage()));

  }

  //---------- get online data --------

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
      //Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MenuPage()));
    }
  }
  //---------------------------
}
