import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';

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
  List<EDetails> _foundBuildingList = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {

    setState(() => isLoading = true);
    partNoDropListModel = await ObjectBox.getPartNo();
    buildingList = await ObjectBox.getPartWiseBuildings(optionItemSelected.id);
    _foundBuildingList = buildingList;

    setState(() => isLoading = false);
  }
  Future<void> _runFilter(String partNo) async {
    List<EDetails> results = await ObjectBox.getPartWiseBuildings(partNo);

    setState(() {
      _foundBuildingList = results;
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
                              _scrollUp();
                            });
                          },
                        ),
                      )
                      :
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _foundBuildingList.isNotEmpty
                      ? ListView.builder(
                    controller: _controller,
                    itemCount: _foundBuildingList.length,
                    itemBuilder: (context, index) => Card(
                      key: ValueKey(_foundBuildingList[index]),
                      color: const Color.fromRGBO(230, 238, 255, 1),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      child: ListTile(
                        leading: Text(
                          (index+1).toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(_foundBuildingList[index].buildingNameEnglish!),
                        subtitle: Text(_foundBuildingList[index].buildingNameMarathi!),
                        onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>  VoterListPage(searchType : 'BuildingWise',
                                  buildingName: _foundBuildingList[index].buildingNameEnglish!,)));
                        },
                      ),
                    ),
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              ],
            ),
          )
      )
    );

  }


}
