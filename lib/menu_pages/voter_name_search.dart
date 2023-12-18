import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/CommonWidget/customButton.dart';
import 'package:majrekar_app/common_pages/voter_list_page.dart';

import '../CommonWidget/showExitPopup.dart';

class VoterNameSearch extends StatefulWidget {
  const VoterNameSearch({Key? key}) : super(key: key);

  @override
  State<VoterNameSearch> createState() => _VoterNameSearchState();
}

class _VoterNameSearchState extends State<VoterNameSearch> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return false;
    }, child: Scaffold(
          backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getCommonHeader(context),
                  const SizedBox(height: 40,),
                  Image.asset("images/logom.png",
                  height: 100,
                      width: 100),
                  const SizedBox(height: 50,),
                  customButton(context, "Surname wise Search"),
                  const SizedBox(height: 20,),
                  customButton(context, "Name wise Search"),
                  const SizedBox(height: 20,),
                  customButton(context, "Building wise Search")

                ],
              ),
            ),
          )
      )
    );

  }

}
