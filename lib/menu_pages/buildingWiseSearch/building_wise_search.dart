import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';

import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../common_pages/voter_list_page.dart';


class BuildingWiseSearch extends StatefulWidget {
  const BuildingWiseSearch({Key? key}) : super(key: key);

  @override
  State<BuildingWiseSearch> createState() => _BuildingWiseSearchSearchState();
}

class _BuildingWiseSearchSearchState extends State<BuildingWiseSearch> {
  PartNo optionItemSelected = PartNo(id: "All");
  bool isLoading = false;
  PartNoDropListModel? partNoDropListModel;
  List<EDetails> voterList = [];
  List<EDetails> _foundUsers = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
    partNoDropListModel = await ObjectBox.getPartNo();
    voterList = await ObjectBox.getPartWiseBuildings(optionItemSelected.id);
    _foundUsers = voterList;

    setState(() => isLoading = false);
  }
  Future<void> _runFilter(String partNo) async {
    List<EDetails> results = await ObjectBox.getPartWiseBuildings(partNo);

    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context);
      return false;
    }, child: Scaffold(
          backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                getCommonHeader(context),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AutoSizeText(
                    "Select Part No",
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child:  !partNoDropListModel.isNull
                          ?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PartNoDropListItem(
                          optionItemSelected,
                          partNoDropListModel!,
                              (optionItem){
                            optionItemSelected = optionItem;
                            setState(() {
                              _runFilter(optionItemSelected.id);
                            });
                          },
                        ),
                      )
                      :
                      const SizedBox(
                        width: 10,
                      )
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _foundUsers.isNotEmpty
                      ? ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundUsers[index].id),
                      color: const Color.fromRGBO(230, 238, 255, 1),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        leading: Text(
                          (index+1).toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text("${_foundUsers[index].houseNoEnglish} ${_foundUsers[index].buildingNameEnglish}"),
                        subtitle: Text("${_foundUsers[index].houseNoMarathi} ${_foundUsers[index].buildingNameMarathi}"),
                        onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  VoterListPage(searchType : 'BuildingWise',
                                  houseNumber: _foundUsers[index].houseNoEnglish!,
                                  buildingName: _foundUsers[index].buildingNameEnglish!,)));
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
          )
      )
    );

  }


}
