import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/login_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../model/DataModel.dart';

class PrintDetails extends StatefulWidget {
  final List<EDetails> voterList;
  final String searchType;
  const PrintDetails({super.key, required this.voterList,required this.searchType});

  @override
  State<PrintDetails> createState() => _PrintDetailsState();
}

class _PrintDetailsState extends State<PrintDetails> {
  GlobalKey key1 = GlobalKey();
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected??false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
        tips = 'connect success';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218,222,224, 1),
        appBar: AppBar(
          title: const Text('Print Data'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Text(tips),
                    ),
                  ],
                ),
                const Divider(),
                StreamBuilder<List<BluetoothDevice>>(
                  stream: bluetoothPrint.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data!.map((d) => ListTile(
                      title: Text(d.name??''),
                      subtitle: Text(d.address??''),
                      onTap: () async {
                        setState(() {
                          _device = d;
                        });
                      },
                      trailing: _device!=null && _device!.address == d.address?const Icon(
                        Icons.check,
                        color: Colors.green,
                      ):null,
                    )).toList(),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed:  _connected?null:() async {
                              if(_device!=null && _device!.address !=null){
                                setState(() {
                                  tips = 'connecting...';
                                });
                                await bluetoothPrint.connect(_device!);
                              }else{
                                setState(() {
                                  tips = 'please select device';
                                });
                                print('please select device');
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2.0, color: Colors.black38),
                            ),
                            child: const Text('Connect', style: TextStyle( fontSize: 18, fontWeight: FontWeight.normal),),

                          ),
                          const SizedBox(width: 10.0),
                          OutlinedButton(
                            onPressed:  _connected?() async {
                              setState(() {
                                tips = 'disconnecting...';
                              });
                              await bluetoothPrint.disconnect();
                            }:null,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2.0, color: Colors.black38),
                            ),
                            child: const Text('Disconnect', style: TextStyle( fontSize: 18, fontWeight: FontWeight.normal),),
                          ),
                          const SizedBox(width: 10.0),
                          StreamBuilder<bool>(
                            stream: bluetoothPrint.isScanning,
                            initialData: false,
                            builder: (c, snapshot) {
                              if (snapshot.data == true) {
                                return  OutlinedButton(
                                  onPressed:() =>  {
                                    bluetoothPrint.stopScan()
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(width: 2.0, color: Colors.black38),
                                  ),
                                  child: const Text('Search', style: TextStyle( fontSize: 18, fontWeight: FontWeight.normal),),
                                );

                              } else {
                                return OutlinedButton(
                                  onPressed:() =>  {
                                  bluetoothPrint.startScan(timeout: const Duration(seconds: 4))
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(width: 2.0, color: Colors.black38),
                                  ),
                                  child: const Text('Search', style: TextStyle( fontSize: 18, fontWeight: FontWeight.normal),),
                                );
                               }
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      const AutoSizeText(
                        'Voter Details',
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.voterList
                            .map((e) => generateWidgets(e, screenWidth))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed:  _connected?() async {
                          widget.voterList
                              .map((e) => printData(e))
                              .toList();
                        }:null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 2.0, color: Colors.black38),
                        ),
                        child: const Text('Print', style: TextStyle( fontSize: 18, color: Colors.black,fontWeight: FontWeight.normal),),

                      ),
                     /* OutlinedButton(
                        child: Text('print label(tsc)'),
                        onPressed:  _connected?() async {
                          Map<String, dynamic> config = Map();
                          config['width'] = 40; // 标签宽度，单位mm
                          config['height'] = 70; // 标签高度，单位mm
                          config['gap'] = 2; // 标签间隔，单位mm

                          // x、y坐标位置，单位dpi，1mm=8dpi
                          List<LineText> list = [];
                          list.add(LineText(type: LineText.TYPE_TEXT, x:10, y:10, content: 'A Title'));
                          list.add(LineText(type: LineText.TYPE_TEXT, x:10, y:40, content: 'this is content'));
                          list.add(LineText(type: LineText.TYPE_QRCODE, x:10, y:70, content: 'qrcode i\n'));
                          list.add(LineText(type: LineText.TYPE_BARCODE, x:10, y:190, content: 'qrcode i\n'));

                          List<LineText> list1 = [];
                          ByteData data = await rootBundle.load("images/election.jpeg");
                          List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                          String base64Image = base64Encode(imageBytes);
                          list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));

                          await bluetoothPrint.printLabel(config, list);
                          await bluetoothPrint.printLabel(config, list1);
                        }:null,
                      ),*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

      );


  }

  printData(EDetails eData) async {
    Map<String, dynamic> config = {};

    List<LineText> list = [];

    list.add(LineText(type: LineText.TYPE_TEXT, content: '********************************', weight: 5, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Majrekar\'s Voters Management', weight: 5, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'System', weight: 5, align: LineText.ALIGN_CENTER, linefeed: 1));
    list.add(LineText(linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Name : ${eData.lnEnglish!} ${eData.fnEnglish!}' , weight: 5, align: LineText.ALIGN_LEFT, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Address : ${eData.houseNoEnglish!} ${eData.buildingNameEnglish!}', weight: 5, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Age/Gender : ${eData.age!} / ${eData.sex!} ',weight: 5, align: LineText.ALIGN_LEFT, x: 0,relativeX: 0, linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Assembly No. : ${eData.wardNo!}',weight: 5, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Part No. : ${eData.partNo!}',weight: 5, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Serial No. : ${eData.serialNo!}',weight: 5, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 1));
    list.add(LineText(type: LineText.TYPE_TEXT, content: 'Voting Center Address : ${eData.boothAddressEnglish!}',weight: 5, align: LineText.ALIGN_LEFT, x: 0, relativeX: 0, linefeed: 1));

    list.add(LineText(type: LineText.TYPE_TEXT, content: '********************************', weight: 5, align: LineText.ALIGN_CENTER,linefeed: 1));
    list.add(LineText(linefeed: 1));

    await bluetoothPrint.printLabel(config, list);
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
      customAgeGender("${data.age!} / ${data.sex!}", screenWidth),
      customData("Voting Center Address", data.boothAddressEnglish!,
          data.boothAddressMarathi!, screenWidth),
      customWardPartSerial(
          data.wardNo!, data.partNo!, data.serialNo!, screenWidth),
    ]);
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
