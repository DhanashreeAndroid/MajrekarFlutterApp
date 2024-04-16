import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../CommonWidget/Constant.dart';
import '../../CommonWidget/commonButton.dart';
import '../../CommonWidget/show_snak_bar.dart';
import '../../CommonWidget/utility.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../../model/UserModel.dart';

class VotingMakingMainPage extends StatefulWidget {
  const VotingMakingMainPage({Key? key}) : super(key: key);

  @override
  State<VotingMakingMainPage> createState() =>
      _VotingMakingMainPageState();
}

class _VotingMakingMainPageState extends State<VotingMakingMainPage> {
  bool isLoading = false;
  UserDetails? userDetails;
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }
  
  Future getUserDetails() async {
    setState(() => isLoading = true);
    List<UserDetails> users = await ObjectBox.getUserDetails();
    userDetails =  users.first;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return false;
    }, child: Scaffold(
          backgroundColor: const Color.fromRGBO(218,222,224, 1),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                CommonHeader(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(child: customButtons()),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
      )
    );

  }


  Padding customButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10,),
          CustomButton(
            onPressed: () {

            }, label: 'All Names',
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
            onPressed: () {

            }, label: 'Marking Done',
          )
        ],
      ),
    );
  }



}
