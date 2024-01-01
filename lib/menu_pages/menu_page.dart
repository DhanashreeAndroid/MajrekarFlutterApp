import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/voter_name_search.dart';

import '../CommonWidget/commonButton.dart';
import '../CommonWidget/showExitPopup.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitPopup(context);
        return false;
      },
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  getCommonHeader(context),
                  const SizedBox(height: 40,),
                  Image.asset("images/logom.png",
                      height: 100,
                      width: 100),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Search Voters Name',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Easy Search',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Alphabetical Voters List',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Voting Making Report',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Surname Counter',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Voters Slip (Print/Share)',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Contact Number Saved',
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) => const VoterNameSearch()));
                    }, label: 'Language Report',
                  ),
                  

                ],
              ),
            ),
          )),
    );
  }
}
