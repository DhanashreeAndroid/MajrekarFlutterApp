import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/common_pages/print_details.dart';
import 'package:majrekar_app/menu_pages/common_pages/share_image.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:telephony/telephony.dart';

import '../../CommonWidget/show_snak_bar.dart';
import 'family_voter_list_page.dart';


class DetailPage extends StatefulWidget {
  final EDetails data;
  final String searchType;
  const DetailPage({Key? key, required this.data, required this.searchType}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  TextEditingController mobileController = TextEditingController();
  int selectedOption = 1;
  bool selectedVoted = false;
  bool selectedShifted = false;
  bool selectedDeath = false;
  final telephony = Telephony.instance;
  final _recipientNumberformKey = GlobalKey<FormState>();


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

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getCommonHeader(context),
                  customData("Name", getEnglishName(),
                      getMarathiName() , screenWidth),
                  customData(
                      "Address",
                      "${widget.data.houseNoEnglish!} ${widget.data.buildingNameEnglish!}",
                      "${widget.data.houseNoMarathi!} ${widget.data.buildingNameMarathi!}",
                      screenWidth),
                  customAgeGender("${widget.data.age!} / ${widget.data.sex!}", screenWidth),
                  customData("Voting Center Address", widget.data.boothAddressEnglish!,
                      widget.data.boothAddressMarathi!, screenWidth),
                  customWardPartSerial(
                      widget.data.wardNo!, widget.data.partNo!, widget.data.serialNo!, screenWidth),
                  customPrintShareButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  customMobileNumber(),
                  const SizedBox(
                    height: 10,
                  ),
                  getRedGreenOrangeRadioButton(screenWidth),
                  getShiftedCheckBox(),
                  getDeathCheckBox(),
                  getVotedCheckBox(),

                ],
              ),
            ),
          )),
    );
  }

  String getEnglishName(){
    if(widget.searchType.contains("Surname")){
      return "${widget.data.lnEnglish!} ${widget.data.fnEnglish!}";
    }else{
      return "${widget.data.fnEnglish!} ${widget.data.lnEnglish!}";
    }

  }
  String getMarathiName(){
    if(widget.searchType.contains("Surname")){
      return "${widget.data.lnMarathi!} ${widget.data.fnMarathi!}";
    }else{
      return "${widget.data.fnMarathi!} ${widget.data.lnMarathi!}";
    }

  }
  Padding customData(String title, String englishValue, String marathiValue,
      double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          AutoSizeText(
            title,
            maxLines: 1,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          AutoSizeText(
            englishValue,
            maxLines: 2,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            height: 5,
          ),
          marathiValue.isNotEmpty
              ? getMarathiTextBox(marathiValue)
              : const SizedBox(
                  height: 5,
                ),
          divider(screenWidth)
        ],
      ),
    );
  }

  Padding customAgeGender(String value,  double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(
              children: <Widget>[
                const AutoSizeText(
                  "Age/Gender : ",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  value,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),
              ]
          ),

          const SizedBox(
            height: 10,
          ),
          divider(screenWidth)
        ],
      ),
    );
  }


  Column getMarathiTextBox(String marathiValue) {
    return Column(
      children: <Widget>[
        AutoSizeText(
          marathiValue,
          maxLines: 2,
          style: const TextStyle(
              color: Colors.green, fontSize: 20, fontWeight: FontWeight.normal),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Padding customWardPartSerial(
      String ward, String part, String serial, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),

          Row(
            children: <Widget>[
              Flexible(
                  flex: 1,
                  child: Column(children: <Widget>[
                    Container(
                      width: 150,
                      child: const Center(
                        child: AutoSizeText(
                          "Assembly No",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Center(
                        child: AutoSizeText(
                          ward,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ])),
              Flexible(
                  flex: 1,
                  child: Column(children: <Widget>[
                    Container(
                      width: 150,
                      child: const Center(
                        child: AutoSizeText(
                          "Part No",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Center(
                        child: AutoSizeText(
                          part,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ])),
              Flexible(
                  flex: 1,
                  child: Column(children: <Widget>[
                    const SizedBox(
                      width: 150,
                      child: Center(
                        child: AutoSizeText(
                          "Serial No",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Center(
                        child: AutoSizeText(
                          serial,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ]))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          divider(screenWidth)
        ],
      ),
    );
  }

  SizedBox divider(double screenWidth) {
    return SizedBox(
      height: 1,
      width: screenWidth,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey),
      ),
    );
  }

  Padding customPrintShareButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 10.0, 10.0, 10.0),
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
                    width: 170,
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
                                (context) =>  FamilyVoterListPage(searchType : widget.searchType, surName:widget.data.lnEnglish!, houseNo: widget.data.houseNoEnglish!, buildingAddress: widget.data.buildingNameEnglish! )));
                      },
                      child: const Text(
                        "Family Search",
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
            flex: 1,
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
                    width: 100,
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
                        List<EDetails> voterList = List<EDetails>.generate(1, (index) => widget.data);
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  PrintDetails(voterList: voterList,searchType: widget.searchType, )));

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
            flex: 1,
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
                    width: 100,
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
                        List<EDetails> voterList = List<EDetails>.generate(1, (index) => widget.data);
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  ShareImage(voterList: voterList,searchType: widget.searchType, )));

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
                        String strMessage1 = "Name:${widget.data.lnEnglish!} ${widget.data.fnEnglish!}\nAssembly No:${widget.data.wardNo!}\nPart No:${widget.data.partNo!}\nSerial No:${widget.data.serialNo!}";
                        String strMessage2 = "Voting Center Address:${widget.data.boothAddressEnglish!}";
                        await sendDirectSmS(strMessage1);
                        await sendDirectSmS(strMessage2);
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

  Column getRedGreenOrangeRadioButton( double screenWidth) {
    return Column(children: [
      const SizedBox(
        height: 15,
      ),
      divider(screenWidth),
      const SizedBox(
        height: 20,
      ),
      const Center(
        child: AutoSizeText(
          "Mark the prediction for this voter",
          maxLines: 2,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<int>(
            value: 1,
            groupValue: selectedOption,
            activeColor:
                Colors.green, // Change the active radio button color here
            fillColor: MaterialStateProperty.all(
                Colors.green), // Change the fill color when selected
            splashRadius: 20, // Change the splash radius when clicked
            onChanged: (int? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
           const Text('Green',
               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.normal,
                   fontSize: 18)),
          const Text(' (Yes)',
               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.normal,
                   fontSize: 12)),
          Radio<int>(
            value: 2,
            groupValue: selectedOption,
            activeColor:
                Colors.red, // Change the active radio button color here
            fillColor: MaterialStateProperty.all(
                Colors.red), // Change the fill color when selected
            splashRadius: 20, // Change the splash radius when clicked
            onChanged: (int? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          const Text('Red',
               style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.normal,
               fontSize: 18)),
          const Text(' (No)',
               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.normal,
                   fontSize: 12)),
          Radio<int>(
            value: 3,
            groupValue: selectedOption,
            activeColor:
                Colors.yellow, // Change the active radio button color here
            fillColor: MaterialStateProperty.all(
                Colors.yellow), // Change the fill color when selected
            splashRadius: 20, // Change the splash radius when clicked
            onChanged: (int? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          const Text('Yellow',
               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.normal,
                   fontSize: 18)),
          const Text(' (Can\'t say)',
               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.normal,
                   fontSize: 12)),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      divider(screenWidth)
    ]);
  }

  CheckboxListTile getVotedCheckBox(){
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
           title: const Text('Voted'),
            value: selectedVoted, onChanged: (bool? value) {
                setState(() {
                  selectedVoted = value!;
                });
          },
        );
  }

  Column getShiftedCheckBox(){
    return Column(
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: const Text('Shifted'),
          value: selectedShifted, onChanged: (bool? value) {
          setState(() {
            selectedShifted = value!;
            if(value == true) {
              selectedDeath = !value;
            }
          });
        },
        ),
        selectedShifted == true ?
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter new address',
            ),
          ),
        ):
        const SizedBox(
        height: 0,
    ),
      ],
    );
  }

  CheckboxListTile getDeathCheckBox(){
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      title: const Text('Death'),
      value: selectedDeath, onChanged: (bool? value) {
      setState(() {
        selectedDeath = value!;
        if(value == true) {
          selectedShifted = !value;
        }
      });
    },
    );
  }

}
