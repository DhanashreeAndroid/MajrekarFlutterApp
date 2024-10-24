
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/model/DataModel.dart';

import '../../database/ObjectBox.dart';
import '../common_pages/detail_page.dart';
import '../common_pages/voter_list_page.dart';
import 'language_list_model.dart';

class LanguageListPage extends StatefulWidget {
  final String buildingName;
  const LanguageListPage({Key? key ,required this.buildingName}) : super(key: key);

  @override
  State<LanguageListPage> createState() => _LanguageListPageState();
}

class _LanguageListPageState extends State<LanguageListPage> {
  List<LanguageItem> languageList =[] ;
  bool isLoading = false;

  @override
  void initState() {
   super.initState();
   getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
    languageList = await ObjectBox.getLanguageList(widget.buildingName);
    setState(() => isLoading = false);
  }

  // This function is called whenever the text field changes

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
       Navigator.pop(context);
       return false;
    },
    child:Focus(
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
    SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(218,222,224, 1),
        body: Column(
          children: [
            CommonHeader(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.buildingName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            const Divider(),
            languageList.isNotEmpty?
            const AutoSizeText(
              "Please click on below Language to see voter details",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ) : const SizedBox(),
            Expanded(
              child: languageList.isNotEmpty
                  ? ListView.builder(
                itemCount: languageList.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(languageList[index].name),
                  color: const Color.fromRGBO(218,222,224, 1),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    tileColor: const Color.fromRGBO(218,222,224, 1),
                    leading: const Text( "", style: TextStyle(fontSize: 0),),
                    minLeadingWidth : 1,
                    title: getTitle(languageList[index].name, languageList[index].count),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>  VoterListPage(searchType : 'LanguageWise',
                            buildingName: widget.buildingName,language: languageList[index].name,)));
                    },
                  ),
                ),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    )),
    );
  }

  Row getTitle(String name,  int count){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(name),
        Text(count.toString(),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ],
    );
  }

}


