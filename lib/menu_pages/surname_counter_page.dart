
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/surname_counter_model.dart';
import 'package:majrekar_app/model/DataModel.dart';
import '../../database/ObjectBox.dart';
import '../CommonWidget/commonButton.dart';
import '../CommonWidget/show_snak_bar.dart';
import '../CommonWidget/utility.dart';
import 'common_pages/detail_page.dart';
import 'common_pages/voter_list_page.dart';

class SurnameCounterPage extends StatefulWidget {
  const SurnameCounterPage({Key? key }) : super(key: key);

  @override
  State<SurnameCounterPage> createState() => _SurnameCounterPageState();
}

class _SurnameCounterPageState extends State<SurnameCounterPage> {
  List<SurnameCounterModel> voterList = [] ;
  bool isLoading = false;
  final _recipientSurnameKey = GlobalKey<FormState>();
  TextEditingController surnameController = TextEditingController();

  Future getData() async {
    try {
      final isRecipientSurnameValid =
      _recipientSurnameKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientSurnameValid) {
        _recipientSurnameKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        setState(() {
          isLoading = true;
        });
        voterList = await ObjectBox.getSurnameCountData(surnameController.text);
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        await HapticFeedback.heavyImpact();
        return;
      }
    } catch (e) {
      print(e.toString());
      ShowSnackBar.showSnackBar(context, 'Error occurred.');
    }
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
            CommonHeader(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            customInputs(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),

            const SizedBox(
              height: 10,
            ),
            voterList.isNotEmpty?
            const AutoSizeText(
              "Please click on below surname",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ) : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),

            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: voterList.isNotEmpty
                  ? ListView.builder(
                itemCount: voterList.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(voterList[index]),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    tileColor: const Color.fromRGBO(218,222,224, 1),
                    leading: const Text("",style: TextStyle(fontSize: 0),),
                    minLeadingWidth : 1,
                    title: Text(voterList[index].surName,style: const TextStyle(fontSize: 20),),
                    subtitle: Text("Total Count : ${voterList[index].count}",style: const TextStyle(fontSize: 20),),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder:
                              (context) =>  VoterListPage(searchType : "SurnameCount" ,buildingName: voterList[index].surName, language: "",)));
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

  Padding customInputs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 2.0, 0.0),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5,),
          Flexible(
            flex: 1,
            child:
            Form(
              key: _recipientSurnameKey,
              child: TextFormField(
                style: const TextStyle(
                    height: 1
                ),
                controller: surnameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    voterList.clear();
                    return "Please enter Surname";
                  }
                  return null;
                },
                onSaved: (String? phoneNumber) {},
                decoration: InputDecoration(
                  hintText: 'Enter surname',
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
              }, label: 'Search',
            ),
          ),
        ],
      ),
    );
  }



}


