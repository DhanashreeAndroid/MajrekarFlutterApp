import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/ageWiseReport/age_count_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';
import 'package:majrekar_app/menu_pages/languageSearch/language_list_page.dart';

import '../../CommonWidget/commonButton.dart';
import '../../CommonWidget/show_snak_bar.dart';
import '../../CommonWidget/utility.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../common_pages/voter_list_page.dart';


class AgeCountPage extends StatefulWidget {
  final String partNo;
  final String ageRange;
  const AgeCountPage({Key? key,required this.partNo, required this.ageRange}) : super(key: key);

  @override
  State<AgeCountPage> createState() => _AgeCountPageState();
}

class _AgeCountPageState extends State<AgeCountPage> {
  bool isLoading = false;
  List<AgeCountModel> list = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
        setState(() => isLoading = true);
        list = await ObjectBox.getAgeCountTable(widget.partNo, widget.ageRange);
        setState(() => isLoading = false);

  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return false;
    }, child:Focus(
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
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: screenWidth,
                      child: DataTable(
                        columns: const [
                          // Set the name of the column
                          DataColumn(label: SizedBox(width: 80,child: Center(child:
                            Text('Age', textAlign:TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.bold
                          ),))),),
                          DataColumn(label: SizedBox(width:80,child: Center(child:
                          Text('Male', textAlign:TextAlign.center, style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.bold
                          )))),),
                          DataColumn(label: SizedBox(width: 80,child: Center(child:
                          Text('Female', textAlign:TextAlign.center, style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Calibri',
                              fontWeight: FontWeight.bold
                          )))),)
                        ],
                        rows: list
                            .map(
                              (e) => DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        e.age.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Calibri',
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: GestureDetector(
                                        child: Text(
                                          e.maleCount.toString(),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(7,53,250, 1),
                                              fontSize: 20,
                                              fontFamily: 'Calibri',
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (context) =>  VoterListPage(searchType : "AgeWise" ,buildingName: widget.partNo, language: "M-${e.age}" ,)));

                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: GestureDetector(
                                        child: Text(
                                          e.femaleCount.toString(),
                                          style: const TextStyle(
                                              color: Color.fromRGBO(7,53,250, 1),
                                              fontSize: 20,
                                              fontFamily: 'Calibri',
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (context) =>  VoterListPage(searchType : "AgeWise" ,buildingName: widget.partNo, language: "F-${e.age}" ,)));

                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ).toList(),
                      ),
                    ),
                  )
                  ,
                ),

              ],
            ),
          )
      ))
    );

  }



}
