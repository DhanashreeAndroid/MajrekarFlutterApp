import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:majrekar_app/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../CommonWidget/Constant.dart';
import '../../CommonWidget/utility.dart';
import '../../CommonWidget/widget_to_image.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../../model/VidhansabhaModel.dart';

class ShareImage extends StatefulWidget {
  final List<EDetails> voterList;
  final String searchType;
  const ShareImage({super.key, required this.voterList,required this.searchType});

  @override
  State<ShareImage> createState() => _ShareImageState();
}

class _ShareImageState extends State<ShareImage> {
  GlobalKey key1 = GlobalKey();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    setBoothAddresses();
  }

  Future<void> setBoothAddresses() async {
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < widget.voterList.length; i++) {
      Vidhansabha? boothDetails = await ObjectBox.getBoothDetails(
          widget.voterList[i].wardNo!, widget.voterList[i].partNo!,
          widget.voterList[i].serialNo!);
      widget.voterList[i].boothAddressEnglish = boothDetails!.boothAddressEnglish!;
      widget.voterList[i].boothAddressMarathi = boothDetails.boothAddressMarathi!;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218,222,224, 1),
        appBar: AppBar(
          backgroundColor:const Color.fromRGBO(218,222,224, 1) ,
          title: const Text('Share'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
      child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            WidgetToImage(
              builder: (key) {
                key1 = key;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible : Constant.isShowShareImage,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(radius),
                          ),
                          child: Image.asset("images/sample.jpg",
                            width: screenWidth,
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),

                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.voterList
                              .map((e) => generateWidgets(e, screenWidth))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
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
                      onPressed: () async {
                        final bytes1 = await capture(key1);
                        final tempDir = await getTemporaryDirectory();
                        final file =
                            await File('${tempDir.path}/image.jpg').create();
                        file.writeAsBytesSync(bytes1);
                        Share.shareFiles([(file.path)],
                            text: '');
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
            const SizedBox(
              height: 10,
            ),
          ],
      ),
    ),
        ));
  }

  Column generateWidgets(EDetails data, double screenWidth) {
    return Column(children: <Widget>[
      customData("Name", getEnglishName(data),
          getMarathiName(data), screenWidth),
      customData(
          "Address",
          "${data.houseNoEnglish!} ${data.buildingNameEnglish!}",
          "${data.houseNoMarathi!} ${data.buildingNameMarathi!}",
          screenWidth),
      customWardPartSerial(
          data.wardNo!, data.partNo!, data.serialNo!, screenWidth),
      customAgeGender("${data.age!} / ${data.sex!}", screenWidth),
      customEpicNumber(data.cardNo!, screenWidth),
      customData("Voting Center Address", data.boothAddressEnglish!,
          data.boothAddressMarathi!, screenWidth),
    ]);
  }

  Padding customEpicNumber(String value,  double screenWidth) {
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
                  "Epic Number : ",
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


  String getEnglishName(EDetails data){
    if(widget.searchType.contains("Surname")){
      return "${data.lnEnglish!} ${data.fnEnglish!}";
    }else{
      return "${data.fnEnglish!} ${data.lnEnglish!}";
    }

  }
  String getMarathiName(EDetails data){
    if(widget.searchType.contains("Surname")){
      return "${data.lnMarathi!} ${data.fnMarathi!}";
    }else{
      return "${data.fnMarathi!} ${data.lnMarathi!}";
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

  static Future capture(GlobalKey key) async {
    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    return pngBytes;
  }
}
