
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/customSharedPreference.dart';
import 'package:majrekar_app/menu_pages/common_pages/testprint.dart';
import 'package:majrekar_app/menu_pages/common_pages/printerenum.dart';
import '../../model/DataModel.dart';

class PrintVoterDetails extends StatefulWidget {

  final List<EDetails> voterList;
  final String searchType;
  const PrintVoterDetails({super.key, required this.voterList,required this.searchType});
  @override
  State<PrintVoterDetails> createState() => _PrintVoterDetails();
}

class _PrintVoterDetails extends State<PrintVoterDetails> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();
  final customSharedPreference = CustomSharedPreference();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    String? storedDevice = "";
    try {
      devices = await bluetooth.getBondedDevices();
      storedDevice = await customSharedPreference.getString("Printer");
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            //_connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
    if (_devices.isNotEmpty) {// Get the first device for example
      for (var device in _devices) {
        var deviceName = device.name ?? "";
        print("device name : $deviceName");

        print("Stored device : $storedDevice");
        if(deviceName == storedDevice){
          _device = device;
          print("find device : $deviceName");
          break;
        }
      }
    }

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }else{
      try{
        bluetooth.connect(_device!).catchError((error) {
          print("Bluetooth error :$error");
        });
      }catch(e){
        _connected = false;
        print("Bluetooth error exception :$e");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(218,222,224, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(218,222,224, 1),
          title: const Text('Print'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Device:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (BluetoothDevice? value) {
                        setState(() {
                          _device = value;
                           customSharedPreference.saveString("Printer",_device?.name ?? "");
                        });
                      },
                      value: _device,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                    onPressed: () {
                      initPlatformState();
                    },
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _connected ? Colors.red : Colors.green),
                    onPressed: _connected ? _disconnect : _connect,
                    child: Text(
                      _connected ? 'Disconnect' : 'Connect',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed:  _connected?() async {
                          widget.voterList
                          .map((e) => printData(e))
                          .toList();
                  }:null,
                  child: const Text('PRINT',
                      style: TextStyle(color: Colors.white)),
                ),
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
            ],
          ),
        ),
      );

  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in _devices) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(device.name ?? ""),
        ));
      }
    }
    return items;
  }

  void _connect() {
    if (_device != null) {

      bluetooth.isConnected.then((isConnected) {
        print("Bluetooth connected :$isConnected");
        if (isConnected == true) {
          setState(() => _connected = true);
        }else{
          bluetooth.connect(_device!).catchError((error) {
            print("Bluetooth error :$error");
          });
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await  Future.delayed( const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content:  Text(
          message,
          style:  const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  printData(EDetails eData) async {
    BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom('Name : ${eData.lnEnglish!} ${eData.fnEnglish!}' , Size.bold.val, PrinterAlign.left.val);
        bluetooth.printCustom('Age/Gender : ${eData.age!} / ${eData.sex!} ' , Size.bold.val, PrinterAlign.left.val);
        bluetooth.printCustom('Assembly No. : ${eData.wardNo!}' , Size.bold.val, PrinterAlign.left.val);
        bluetooth.printCustom('Part No. : ${eData.partNo!}' , Size.bold.val, PrinterAlign.left.val);
        bluetooth.printCustom('Serial No. : ${eData.serialNo!}', Size.bold.val, PrinterAlign.left.val);
        bluetooth.printCustom('Voting Center : ${eData.boothAddressEnglish!}' , Size.bold.val, PrinterAlign.left.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Column generateWidgets(EDetails data, double screenWidth)  {
    return Column(children: <Widget>[
      customData("Name", getEnglishName(data),
          getMarathiName(data), screenWidth),
      customData(
          "Address",
          "${data.houseNoEnglish!} ${data.buildingNameEnglish!}",
          "${data.houseNoMarathi!} ${data.buildingNameMarathi!}",
          screenWidth),
      customAgeGender("${data.age!} / ${data.sex!}", screenWidth),
      customEpicNumber(data.cardNo!, screenWidth),
      customData("Voting Center Address", data.boothAddressEnglish,
          data.boothAddressMarathi, screenWidth),
      customWardPartSerial(
          data.wardNo!, data.partNo!, data.serialNo!, screenWidth),
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

  Padding customData(String title, String? englishValue, String? marathiValue,
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
            englishValue ?? "",
            maxLines: 2,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            height: 10,
          ),
          getMarathiTextBox(marathiValue),
          divider(screenWidth)
        ],
      ),
    );
  }

  Column getMarathiTextBox(String? marathiValue) {
    return Column(
      children: <Widget>[
        AutoSizeText(
          marathiValue ?? "",
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