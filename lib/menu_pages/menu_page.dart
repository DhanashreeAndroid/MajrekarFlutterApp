import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/easy_search.dart';
import 'package:majrekar_app/menu_pages/epic_search.dart';
import 'package:majrekar_app/menu_pages/pdfSample.dart';
import 'package:majrekar_app/menu_pages/surname_counter_page.dart';
import 'package:majrekar_app/menu_pages/voter_name_search.dart';
import 'package:majrekar_app/menu_pages/votingMakingPages/voting_making_main_page.dart';

import '../CommonWidget/Constant.dart';
import '../CommonWidget/commonButton.dart';
import '../CommonWidget/commonButtonCustomBorder.dart';
import '../CommonWidget/showExitPopup.dart';
import '../database/ObjectBox.dart';
import '../model/UserModel.dart';
import 'ageWiseReport/age_wise_search.dart';
import 'alphabetical_voter_list_page.dart';
import 'buildingWiseSearch/building_wise_search.dart';
import 'common_pages/voter_list_page.dart';
import 'easy_print_share.dart';
import 'languageSearch/language_wise_search.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserDetails? userDetails;
  bool isLoading = false;
  String vidhan  = "Mantree";


  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future getUserDetails() async {
    setState(() => isLoading = true);
    if(Constant.isOffline){
      userDetails = UserDetails(isMarkable: 'false');
      userDetails?.vidhansabhaName = Constant.vidhansabhaName;
    }else{
      List<UserDetails> users = await ObjectBox.getUserDetails();
      userDetails =  users.first;
    }
    if(userDetails?.vidhansabhaName != ""){
      vidhan = userDetails!.vidhansabhaName!;
    }
    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitPopup(context);
        return false;
      },child:Focus(
              autofocus: true,
              onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
              // Mimic back button behavior
                showExitPopup(context);
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
              },
      child:
    Scaffold(
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
                child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: Column(
                    children: [
                      CommonHeader(
                        onPressed: () {
                          showExitPopup(context);
                        },
                      ),
                      Visibility(
                        visible: false,
                        child: Image.asset("images/logo.jpg",
                            height: 100,
                            width: 100),
                      ),

                      const SizedBox(height: 10,),
                      Text(
                        vidhan,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 20,),
                     /* CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const VoterNameSearch()));
                        }, label: 'Search Voters Name',
                      ),*/
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const EasySearch()));
                        }, label: 'Search Voters Name',
                      ),
                      const SizedBox(height: 20,),
                    /*  CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const EasySearch()));
                        }, label: 'Easy Search',
                      ),
                      const SizedBox(height: 20,),*/
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
                                  (context) => const EpicSearch()));
                        }, label: 'EPIC No. Search ',
                      ),
                      const Visibility(
                          visible: !Constant.isOffline,
                          child: SizedBox(height: 20,)),
                      Visibility(
                        visible: !Constant.isOffline,
                        child: CustomButtonCustomBorder(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder:
                                    (context) => const VotingMakingMainPage()));
                          }, label: 'Voting Marking Report', borderColor: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const AlphabeticalVoterListPage()));
                        }, label: 'Alphabetical Voters List',
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
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) => const AgeWiseSearch()));
                        }, label: 'Age Wise Report',
                      ),
                      const SizedBox(height: 20,),
                      Constant.isShowImageToHeader?
                      const AutoSizeText(
                        textAlign: TextAlign.center,
                        "Copyright © Developed by Majrekar’s Voters Management System",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ): const SizedBox(),
                      const SizedBox(height: 20,),

                    ],
                  ),
                ),
              ),
            ],
          )),
    ));
  }
}
