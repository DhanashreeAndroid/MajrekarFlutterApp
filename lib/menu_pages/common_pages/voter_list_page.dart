
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/model/DataModel.dart';

import '../../database/ObjectBox.dart';
import 'detail_page.dart';

class VoterListPage extends StatefulWidget {
  final String searchType;
  final String houseNumber;
  final String buildingName;
  const VoterListPage({Key? key ,required this.searchType, required this.houseNumber, required this.buildingName}) : super(key: key);

  @override
  State<VoterListPage> createState() => _VoterListPageState();
}

class _VoterListPageState extends State<VoterListPage> {
  late List<EDetails> voterList  ;
  bool isLoading = false;
  // This list holds the data for the list view
  List<EDetails> _foundUsers = [];

  @override
  void initState() {
   super.initState();
   getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
    if(widget.searchType == "BuildingWise"){
      this.voterList = await ObjectBox.getAllBuildingWiseData(widget.houseNumber, widget.buildingName);
    }else {
      this.voterList = await ObjectBox.getAll(widget.searchType);
    }
    // at the beginning, all users are shown
    _foundUsers = voterList;
    setState(() => isLoading = false);
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<EDetails> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = voterList;
    } else {
      results = voterList
          .where((voter) =>
      (voter.lnEnglish!.toLowerCase().contains(enteredKeyword.toLowerCase()))
      || voter.fnEnglish!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async{
       Navigator.pop(context);
       return false;
    },
    child: SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(230, 238, 255, 1),
        body: Container(
          child: Column(
            children: [
              getCommonHeader(context),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                      labelText: 'Search', suffixIcon: Icon(Icons.search)),
                ),
              ),
              const SizedBox(
                height: 5,
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
                      title: getTextViewEnglish(index, widget.searchType),
                      subtitle: getTextViewMarathi(index, widget.searchType),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  DetailPage(data : _foundUsers[index], searchType: widget.searchType,)));
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
      ),
    ),
    );
  }

  Widget getTextViewEnglish(int index, String searchType){
    if(searchType.contains("Name")){
      return Text("${_foundUsers[index].fnEnglish} ${_foundUsers[index].lnEnglish}");
    }else{
      return Text("${_foundUsers[index].lnEnglish} ${_foundUsers[index].fnEnglish}");
    }

  }
  Widget getTextViewMarathi(int index, String searchType){
    if(searchType.contains("Name")){
      return Text("${_foundUsers[index].fnMarathi} ${_foundUsers[index].lnMarathi}");
    }else{
      return Text("${_foundUsers[index].lnMarathi} ${_foundUsers[index].fnMarathi}");
    }

  }

 Widget buildNotes() => ListView.builder(
   itemCount: voterList.length,
   itemBuilder: (context , index){
     return   ListTile(
       leading: const CircleAvatar(
         backgroundColor: Colors.black,
         backgroundImage: NetworkImage('https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?cs=srgb&dl=pexels-pixabay-415829.jpg&fm=jpg'),
       ),
       title: Text("${voterList[index].lnEnglish} ${voterList[index].fnEnglish}"),
       subtitle: Text("${voterList[index].lnMarathi} ${voterList[index].fnMarathi}"),
     );
   },
 );

}


