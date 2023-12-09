import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/CommonWidget/customButton.dart';
import 'package:majrekar_app/model/DataModel.dart';
import 'package:majrekar_app/voter_list_page.dart';

import 'CommonWidget/showExitPopup.dart';
import 'autosearch.dart';

class DetailPage extends StatefulWidget {
  final EDetails data;
  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState(data);
}

class _DetailPageState extends State<DetailPage> {
  EDetails data;
  _DetailPageState(this.data);
  TextEditingController mobileController = TextEditingController();
  int selectedOption = 1;
  bool selectedVoted = false;
  bool selectedShifted = false;
  bool selectedDeath = false;
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
                  customData("Name", "${data.lnEnglish!} ${data.fnEnglish!}",
                      "${data.lnMarathi!} ${data.fnMarathi!}", screenWidth),
                  customData(
                      "Address",
                      "${data.houseNoEnglish!} ${data.buildingNameEnglish!}",
                      "${data.houseNoMarathi!} ${data.buildingNameMarathi!}",
                      screenWidth),
                  customAgeGender("${data.age!} / ${data.sex!}", screenWidth),
                  customData("Voting Center Address", data.boothAddressEnglish!,
                      data.boothAddressMarathi!, screenWidth),
                  customWardPartSerial(
                      data.wardNo!, data.partNo!, data.serialNo!, screenWidth),
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
                    Container(
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
                    Container(
                      width: 150,
                      child: const Center(
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
                    Container(
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
                      onPressed: () {},
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
                      onPressed: () {},
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
                      onPressed: () {},
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
          const Flexible(
            flex: 3,
            child:
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mobile No',
              ),
            ),
          ),

          Flexible(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child: SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.transparent,
                        ),
                      ),
                      onPressed: () {},
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
                padding: const EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child:
                  const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.call,
                      color: Colors.black,
                      size: 30.0,
                      semanticLabel: 'Text to announce in accessibility modes',
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
                padding: const EdgeInsets.fromLTRB(0.0, 0, 10.0, 0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, .6),
                      ])),
                  child:
                  const SizedBox(
                    width: 50,
                    child: Icon(
                      Icons.message,
                      color: Colors.black,
                      size: 30.0,
                      semanticLabel: 'Text to announce in accessibility modes',
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
            selectedDeath = !value;
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
        selectedShifted = !value;
      });
    },
    );
  }

}
