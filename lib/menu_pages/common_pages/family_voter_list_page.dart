
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/common_pages/print_details.dart';
import 'package:majrekar_app/menu_pages/common_pages/share_image.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:telephony/telephony.dart';

import '../../CommonWidget/show_snak_bar.dart';
import '../../database/ObjectBox.dart';
import 'detail_page.dart';

class FamilyVoterListPage extends StatefulWidget {
  final String searchType;
  final String surName;
  final String houseNo;
  final String buildingAddress;
  const FamilyVoterListPage({Key? key ,required this.searchType,
    required this.surName,
    required this.houseNo,
    required this.buildingAddress}) : super(key: key);

  @override
  State<FamilyVoterListPage> createState() => _FamilyVoterListPageState(searchType, surName, houseNo, buildingAddress);
}

class _FamilyVoterListPageState extends State<FamilyVoterListPage> {
  String searchType;
   String surName;
   String houseNo;
   String buildingAddress;
  _FamilyVoterListPageState(this.searchType,  this.surName, this.houseNo, this.buildingAddress);
  late List<EDetails> voterList  ;
  bool isLoading = false;
  final telephony = Telephony.instance;
  final _recipientNumberformKey = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
   super.initState();
   getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
    voterList = await ObjectBox.getFamilyVoters(searchType, surName, houseNo, buildingAddress);
    setState(() => isLoading = false);
  }

  // This function is called whenever the text field changes

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
       Navigator.pop(context);
       return false;
    },
    child: SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
        body: Column(
          children: [
            getCommonHeader(context),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: voterList.isNotEmpty
                  ? ListView.builder(
                itemCount: voterList.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(voterList[index].id),
                  color: const Color.fromRGBO(230, 238, 255, 1),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    leading: Text(
                        (index+1).toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: getTextViewEnglish(index, searchType),
                    subtitle: getTextViewMarathi(index, searchType),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) =>  DetailPage(data : voterList[index], searchType: searchType,)));
                    },
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            customPrintShareButton(),
            const SizedBox(
              height: 10,
            ),
            customMobileNumber(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget getTextViewEnglish(int index, String searchType){
    if(searchType.contains("Name")){
      return Text("${voterList[index].fnEnglish} ${voterList[index].lnEnglish}");
    }else{
      return Text("${voterList[index].lnEnglish} ${voterList[index].fnEnglish}");
    }

  }
  Widget getTextViewMarathi(int index, String searchType){
    if(searchType.contains("Name")){
      return Text("${voterList[index].fnMarathi} ${voterList[index].lnMarathi}");
    }else{
      return Text("${voterList[index].lnMarathi} ${voterList[index].fnMarathi}");
    }

  }

 Widget buildNotes() => ListView.builder(
   itemCount: voterList.length,
   itemBuilder: (context , index){
     return   ListTile(
       leading: const CircleAvatar(
         backgroundColor: Colors.black,
         backgroundImage: NetworkImage('https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?cs=srgb&dl=pexels-pixabay-415829.jpg&fm=jpg'),
       ),
       title: Text("${voterList[index].lnEnglish} ${voterList[index].fnEnglish}"),
       subtitle: Text("${voterList[index].lnMarathi} ${voterList[index].fnMarathi}"),
     );
   },
 );

  Padding customPrintShareButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Row(
        children: <Widget>[

          Flexible(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(0, 0, 0, 1),
                        Color.fromRGBO(0, 0, 0, .6),
                      ])),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  PrintDetails(voterList: voterList,searchType: searchType, )));

                      },
                      child: const Text(
                        "Print",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(0, 0, 0, 1),
                        Color.fromRGBO(0, 0, 0, .6),
                      ])),
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  ShareImage(voterList: voterList, searchType: searchType,)));

                      },
                      child: const Text(
                        "Share",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Padding customMobileNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 2.0, 0.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 3,
            child:
            Form(
              key: _recipientNumberformKey,
              child: TextFormField(
                controller: mobileController,
                autofillHints: const [AutofillHints.telephoneNumber],
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter mobile number";
                  }
                  return null;
                },
                onSaved: (String? phoneNumber) {},
                decoration: InputDecoration(
                  hintText: 'Enter mobile number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

          Flexible(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child: SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: ()  {

                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 5.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child:
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          width: 0.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: () async {
                        await openDialer();
                      },
                      icon:  const Icon(
                        Icons.call,
                        color: Colors.black,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child:
                  SizedBox(
                    width: 50,
                    child: IconButton(
                      onPressed: ()async {
                        voterList
                            .map((e) => generateMessage(e) )
                            .toList();
                      },
                      icon: const Icon(
                        Icons.message,
                        color: Colors.black,
                        size: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void generateMessage(EDetails data) async{
    String strMessage1 = "Name:${data.lnEnglish!} ${data.fnEnglish!}\nAssembly No:${data.wardNo!}\nPart No:${data.partNo!}\nSerial No:${data.serialNo!}";
    String strMessage2 = "${data.fnEnglish!} ${data.lnEnglish!}\nVoting Center Address: ${data.boothAddressEnglish!} ";
    await sendDirectSmS(strMessage1);
    await sendDirectSmS(strMessage2);
  }
  void showRequestStatus(SendStatus status) {
    switch (status) {
      case SendStatus.SENT:
        ShowSnackBar.showSnackBar(context, ShowSnackBar.sent);
        return;
      case SendStatus.DELIVERED:
        ShowSnackBar.showSnackBar(context, ShowSnackBar.delivered);
        return;
      default:
        ShowSnackBar.showSnackBar(
          context,
          ShowSnackBar.failed,
          backGroundColor: Colors.red,
        );
        return;
    }
  }

  Future<void> openDialer() async {
    try {
      final isRecipientNumberValid =
      _recipientNumberformKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientNumberValid ) {
        _recipientNumberformKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        telephony.openDialer(mobileController.text.trim());
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(context, 'Error occured while sending SMS.');
    }

  }

  Future<void> sendDirectSmS(String message) async {
    try {
      final isRecipientNumberValid =
      _recipientNumberformKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientNumberValid ) {
        _recipientNumberformKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();

        final permissionsGranted =
            await telephony.requestPhoneAndSmsPermissions ?? false;

        if (permissionsGranted) {
          ShowSnackBar.showSnackBar(context, 'Sending SMS...');
          await telephony.sendSms(
            to: mobileController.text.trim(),
            message: message,
            statusListener: (SendStatus status) {
              showRequestStatus(status);
            },
          );
          //clearTextField(ignorePhoneNumber: true);
        } else {
          ShowSnackBar.showSnackBar(context, 'SMS permission is not allowed');
        }
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(context, 'Error occured while sending SMS.');
    }
  }


}


