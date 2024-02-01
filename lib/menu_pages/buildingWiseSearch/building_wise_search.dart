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


  Future getData() async {
    try {
      final isRecipientSurnameValid =
      _recipientPartNoKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientSurnameValid) {
        _recipientPartNoKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        setState(() => isLoading = true);
        buildingList = await ObjectBox.getPartWiseBuildings(partNoController.text);
        setState(() => isLoading = false);
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      ShowSnackBar.showSnackBar(context, 'Error occurred.');
    }
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
                getCommonHeader(context),
                const SizedBox(
                  width: 10,
                ),
                customInputs(),
                const SizedBox(
                  height: 10,
                ),
                const Divider(thickness: 2,),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: buildingList.isNotEmpty
                      ? ListView.builder(
                    controller: _controller,
                    itemCount: buildingList.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(buildingList[index]),
                      color: const Color.fromRGBO(218,222,224, 1),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        leading: Text(
                          (index+1).toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(buildingList[index].buildingNameEnglish!),
                        subtitle: Text(buildingList[index].buildingNameMarathi!),
                        onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  VoterListPage(searchType : 'BuildingWise',
                                  buildingName: buildingList[index].buildingNameEnglish!,)));
                        },
                      ),
                    ),
                  )
                      :    const Center(
                child: Text("Please enter Part No then click on search button"),
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
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 2.0, 0.0),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5,),
          Flexible(
            flex: 2,
            child:
            Form(
              key: _recipientPartNoKey,
              child: TextFormField(
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
            flex: 2,
            child:
            CustomButton(
              onPressed: () {
                getData();
                _scrollUp();
              }, label: 'Search',
            ),
          )
        ],
      ),
    );
  }


}
