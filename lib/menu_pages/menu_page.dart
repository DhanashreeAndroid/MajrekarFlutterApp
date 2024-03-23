import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/easy_search.dart';
import 'package:majrekar_app/menu_pages/pdfSample.dart';
import 'package:majrekar_app/menu_pages/surname_counter_page.dart';
import 'package:majrekar_app/menu_pages/voter_name_search.dart';

import '../CommonWidget/commonButton.dart';
import '../CommonWidget/showExitPopup.dart';
import 'alphabetical_voter_list_page.dart';
import 'buildingWiseSearch/building_wise_search.dart';
import 'easy_print_share.dart';
import 'languageSearch/language_wise_search.dart';

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
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/background.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                color: const Color.fromRGBO(255, 255, 255, 0.50),
              ),
              SafeArea(
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
                                  (context) => const EasySearch()));
                        }, label: 'Easy Search',
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) =>  const BuildingWiseSearch()));
                        }, label: 'Building wise Search',
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const AlphabeticalVoterListPage()));
                        }, label: 'Alphabetical Voters List',
                      ),
                      Visibility(
                        visible: false,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder:
                                    (context) => const VoterNameSearch()));
                          }, label: 'Voting Making Report',
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const SurnameCounterPage()));
                        }, label: 'Surname Counter',
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const EasyPrintShare()));
                        }, label: 'Voters Slip (Print/Share)',
                      ),
                     Visibility(
                        visible: false,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder:
                                    (context) =>  PdfSample()));
                          }, label: 'Contact Number Saved',
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const LanguageWiseSearch()));
                        }, label: 'Language Report',
                      ),
                      const SizedBox(height: 20,),

                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
