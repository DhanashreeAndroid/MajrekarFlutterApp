
import 'package:flutter/material.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/surname_counter_model.dart';
import 'package:majrekar_app/model/DataModel.dart';
import '../../database/ObjectBox.dart';
import 'common_pages/detail_page.dart';
import 'common_pages/voter_list_page.dart';

class SurnameCounterPage extends StatefulWidget {
  const SurnameCounterPage({Key? key }) : super(key: key);

  @override
  State<SurnameCounterPage> createState() => _SurnameCounterPageState();
}

class _SurnameCounterPageState extends State<SurnameCounterPage> {
  late List<SurnameCounterModel> voterList  ;
  bool isLoading = false;
  // This list holds the data for the list view
  List<SurnameCounterModel> _foundUsers = [];

  @override
  void initState() {
   super.initState();
   getData();
  }

  Future getData() async {
    setState(() => isLoading = true);
      this.voterList = await ObjectBox.getSurnameCountData();

    // at the beginning, all users are shown
    _foundUsers = voterList;
    setState(() => isLoading = false);
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<SurnameCounterModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = voterList;
    } else {
      results = voterList
          .where((voter) =>
      (voter.surName.toLowerCase().contains(enteredKeyword.toLowerCase())))
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
        backgroundColor: const Color.fromRGBO(218,222,224, 1),
        body: Column(
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
                  key: ValueKey(_foundUsers[index]),
                  color: const Color.fromRGBO(218,222,224, 1),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    leading: Text(
                        (index+1).toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(_foundUsers[index].surName),
                    subtitle: Text("Total Count : ${_foundUsers[index].count}"),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) =>  VoterListPage(searchType : "SurnameCount" ,buildingName: _foundUsers[index].surName, language: "",)));
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
    );
  }




}


