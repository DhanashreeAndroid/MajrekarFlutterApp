import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';

import '../CommonWidget/commonButton.dart';
import 'buildingWiseSearch/building_wise_search.dart';
import 'common_pages/voter_list_page.dart';


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
    }, child: Focus(
    autofocus: true,
    onKeyEvent: (FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
    // Mimic back button behavior
    Navigator.pop(context);
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CommonHeader(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      const SizedBox(height: 40,),
                      Image.asset("images/logo.jpg",
                      height: 100,
                          width: 100),
                      const SizedBox(height: 50,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) =>  const VoterListPage(searchType : "English" ,buildingName: "", language: "",)));
                        }, label: 'English',
                      ),

                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder:
                                  (context) =>  const VoterListPage(searchType : "Marathi" ,buildingName: "", language: "",)));
                        }, label: 'Marathi',
                      ),


                    ],
                  ),
                ),
              ),
            ],
          )
      ))
    );

  }

}
