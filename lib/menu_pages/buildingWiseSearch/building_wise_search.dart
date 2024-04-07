import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';

import '../../CommonWidget/commonButton.dart';
import '../../CommonWidget/show_snak_bar.dart';
import '../../CommonWidget/utility.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../common_pages/voter_list_page.dart';


class BuildingWiseSearch extends StatefulWidget {
  const BuildingWiseSearch({Key? key}) : super(key: key);

  @override
  State<BuildingWiseSearch> createState() => _BuildingWiseSearchSearchState();
}

class _BuildingWiseSearchSearchState extends State<BuildingWiseSearch> {
  final ScrollController _controller = ScrollController();
  PartNo optionItemSelected = PartNo(id: "All");
  bool isLoading = false;
  PartNoDropListModel? partNoDropListModel;
  List<EDetails> buildingList = [];
  final _recipientPartNoKey = GlobalKey<FormState>();
  TextEditingController partNoController = TextEditingController();
  List<EDetails> _foundUsers = [];

  TextEditingController buildingController =
  TextEditingController();

  Future getData() async {
    try {
      final isRecipientSurnameValid =
      _recipientPartNoKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientSurnameValid) {
        _recipientPartNoKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        setState(() {
          isLoading = true;
          alertDailog(context);
        });
        buildingList.clear();
        buildingList = await ObjectBox.getPartWiseBuildings(partNoController.text);
        _foundUsers = buildingList;
        setState(() {
          isLoading = false;
          Navigator.of(context, rootNavigator: true).pop();
        });
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ShowSnackBar.showSnackBar(context, 'Error occurred.');
    }
  }

  Future getDataFullVidhan() async {
    try {
      setState(() {
        isLoading = true;
        alertDailog(context);
      });
        buildingList.clear();
        buildingList = await ObjectBox.getPartWiseBuildings("All");
      _foundUsers = buildingList;
      setState(() {
        isLoading = false;
        Navigator.of(context, rootNavigator: true).pop();
      });
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      ShowSnackBar.showSnackBar(context, 'Error occurred.');
    }
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<EDetails> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = buildingList;
    } else {
      results = buildingList
          .where((voter) =>
      (voter.buildingNameEnglish!.toLowerCase().contains(enteredKeyword.toLowerCase())))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }


  void _scrollUp() {
    _controller.animateTo(0,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
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
                  height: 5,
                ),
              CustomButton(
                onPressed: () {
                  getDataFullVidhan();
                 }, label: 'Search in Full Vidhansabha',
                ),
                const Divider(),
                customInputs(),
                const Divider(thickness: 2,),

                _foundUsers.isNotEmpty?
                TextField(
                  controller: buildingController,
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    hintText: 'Search Building',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ):const SizedBox(),
                _foundUsers.isNotEmpty?
                const AutoSizeText(
                  "Please click on below building names",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                ) : const SizedBox(),
                Expanded(
                  child: _foundUsers.isNotEmpty
                      ? ListView.builder(
                    controller: _controller,
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundUsers[index]),
                      color: const Color.fromRGBO(218,222,224, 1),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        tileColor: const Color.fromRGBO(218,222,224, 1),
                        leading: const Text( "", style: TextStyle(fontSize: 0),),
                        minLeadingWidth : 1,
                        title: Text(_foundUsers[index].buildingNameEnglish!),
                        subtitle: Text(_foundUsers[index].buildingNameMarathi!),
                        onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  VoterListPage(searchType : 'BuildingWise',
                                  buildingName: _foundUsers[index].buildingNameEnglish!,language: "",)));
                        },
                      ),
                    ),
                  )
                      :    const Center(
                child: Text("Click on Full Vidhansabha button to search buildings in full vidhansabha\nOR\nPlease enter Part No then click on search button", textAlign: TextAlign.center,),
                  ),
                ),

              ],
            ),
          )
      )
    );

  }

  Padding customInputs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 2.0, 0.0),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5,),
          Flexible(
            flex: 1,
            child:
            Form(
              key: _recipientPartNoKey,
              child: TextFormField(
                style: const TextStyle(
                    height: 1
                ),
                controller: partNoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    buildingList.clear();
                    return "Please enter Part No";
                  }
                  return null;
                },
                onSaved: (String? phoneNumber) {},
                decoration: InputDecoration(
                  hintText: 'Enter Part No',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Flexible(
            flex: 1,
            child:
            CustomButton(
              onPressed: () {
                getData();
                _scrollUp();
              }, label: 'Search',
            ),
          ),
        ],
      ),
    );
  }


}
