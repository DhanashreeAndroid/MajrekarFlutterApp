import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/CommonWidget/customButton.dart';
import 'package:majrekar_app/common_pages/voter_list_page.dart';
import 'package:majrekar_app/menu_pages/voter_name_search.dart';

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
            child: Column(
              children: [
                getCommonHeader(context),
                const SizedBox(height: 40,),
                Image.asset("images/logom.png",
                    height: 100,
                    width: 100),
                const SizedBox(height: 20,),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                     crossAxisSpacing: 30
                      ),
                      scrollDirection: Axis.vertical,
                      children: [
                    GestureDetector(
                      onTap:() {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) => const VoterNameSearch()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Search Voters\nName",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                 ),
                          ),
                        ),

                      ),
                    ), //1
                    GestureDetector(
                    onTap:() {

                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ])),
                      child: const Center(
                        child: Text(
                          "Easy\nSearch",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.normal),
                        ),
                      ),

                    ),
                      ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Alphabetical\nVoters List",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Voting Making\nReport",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Surname\nCounter",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Voters Slip\n(Print/Share)",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Contact Number\nSaved",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                    GestureDetector(
                      onTap:() {

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: const Center(
                          child: Text(
                            "Language\nReport",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal),
                          ),
                        ),

                      ),
                    ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
