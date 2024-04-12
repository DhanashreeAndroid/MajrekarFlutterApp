import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';

import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../CommonWidget/commonButton.dart';
import '../CommonWidget/show_snak_bar.dart';
import '../model/VidhansabhaModel.dart';
import 'common_pages/detail_page.dart';
import 'common_pages/print_details.dart';
import 'common_pages/share_image.dart';

class EpicSearch extends StatefulWidget {
  const EpicSearch({Key? key}) : super(key: key);

  @override
  State<EpicSearch> createState() => _EpicSearchState();
}

class _EpicSearchState extends State<EpicSearch> {
  bool isLoading = false;
  EDetails? voterDetails;
  final _recipientEpicFormKey = GlobalKey<FormState>();
  TextEditingController epicController = TextEditingController();

  Future getData() async {
    try {
      final isRecipientNameValid =
          _recipientEpicFormKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientNameValid) {
        _recipientEpicFormKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        setState(() => isLoading = true);
        voterDetails = await ObjectBox.getEpicWiseData(epicController.text);
        Vidhansabha? boothDetails = await ObjectBox.getBoothDetails(
            voterDetails!.wardNo!,
            voterDetails!.partNo!,
            voterDetails!.serialNo!);
        voterDetails!.boothAddressEnglish = boothDetails!.boothAddressEnglish!;
        voterDetails!.boothAddressMarathi = boothDetails.boothAddressMarathi!;

        setState(() => isLoading = false);
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(context, 'Please enter valid epic number.');
    }
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
            backgroundColor: const Color.fromRGBO(218, 222, 224, 1),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CommonHeader(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    ),
                    customInputs(),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      onPressed: () {
                        getData();
                      },
                      label: 'Search',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    voterDetails != null ? customButtons() : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    const AutoSizeText(
                      'Voter Details',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    voterDetails != null
                        ? generateWidgets(voterDetails!, screenWidth)
                        : Column(
                            children: [
                              Center(
                                child: Text(
                                    "Please enter Epic number then click on search button"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )));
  }

  Padding customInputs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 2.0, 0.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Form(
              key: _recipientEpicFormKey,
              child: TextFormField(
                autofocus: true,
                controller: epicController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter epic no.";
                  }
                  return null;
                },
                onSaved: (String? phoneNumber) {},
                decoration: InputDecoration(
                  hintText: 'Enter Epic No',
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
        ],
      ),
    );
  }

  Padding customButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: CustomButton(
              onPressed: () {
                List<EDetails> voterList =
                    List<EDetails>.generate(1, (index) => voterDetails!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrintDetails(
                              voterList: voterList,
                              searchType: "Surname",
                            )));
              },
              label: 'Print',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 1,
            child: CustomButton(
              onPressed: () {
                List<EDetails> voterList =
                    List<EDetails>.generate(1, (index) => voterDetails!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShareImage(
                              voterList: voterList,
                              searchType: "Surname",
                            )));
              },
              label: 'Share',
            ),
          )
        ],
      ),
    );
  }

  Column generateWidgets(EDetails data, double screenWidth) {
    return Column(children: <Widget>[
      customData(
          "Name", getEnglishName(data), getMarathiName(data), screenWidth),
      customData(
          "Address",
          "${data.houseNoEnglish!} ${data.buildingNameEnglish!}",
          "${data.houseNoMarathi!} ${data.buildingNameMarathi!}",
          screenWidth),
      customAgeGender("${data.age!} / ${data.sex!}", screenWidth),
      customEpicNumber(data.cardNo!, screenWidth),
      customData("Voting Center Address", data.boothAddressEnglish!,
          data.boothAddressMarathi!, screenWidth),
      customWardPartSerial(
          data.wardNo!, data.partNo!, data.serialNo!, screenWidth),
    ]);
  }

  Padding customEpicNumber(String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(children: <Widget>[
            const AutoSizeText(
              "Epic Number : ",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
          ]),
          const SizedBox(
            height: 10,
          ),
          divider(screenWidth)
        ],
      ),
    );
  }

  String getEnglishName(EDetails data) {
    return "${data.lnEnglish!} ${data.fnEnglish!}";
  }

  String getMarathiName(EDetails data) {
    return "${data.lnMarathi!} ${data.fnMarathi!}";
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
          getMarathiTextBox(marathiValue),
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

  SizedBox divider(double screenWidth) {
    return SizedBox(
      height: 1,
      width: screenWidth,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey),
      ),
    );
  }

  SizedBox lastDivider(double screenWidth) {
    return SizedBox(
      height: 2,
      width: screenWidth,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey),
      ),
    );
  }

  Padding customAgeGender(String value, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Row(children: <Widget>[
            const AutoSizeText(
              "Age/Gender : ",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
          ]),
          const SizedBox(
            height: 10,
          ),
          divider(screenWidth)
        ],
      ),
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
          lastDivider(screenWidth)
        ],
      ),
    );
  }
}
