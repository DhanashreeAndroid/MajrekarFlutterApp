import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';

import '../../model/DataModel.dart';
import '../CommonWidget/commonButton.dart';
import '../CommonWidget/show_snak_bar.dart';
import 'common_pages/detail_page.dart';


class EasySearch extends StatefulWidget {
  const EasySearch({Key? key}) : super(key: key);

  @override
  State<EasySearch> createState() => _EasySearchState();
}

class _EasySearchState extends State<EasySearch> {
  final ScrollController _controller = ScrollController();
  bool isLoading = false;
  List<EDetails> voterList = [];
  final _recipientSurnameFormKey = GlobalKey<FormState>();
  final _recipientNameFormKey = GlobalKey<FormState>();
  TextEditingController surnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();


  Future getData() async {


    try {
      final isRecipientSurnameValid =
      _recipientSurnameFormKey.currentState!.validate();
      final isRecipientNameValid =
      _recipientNameFormKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientSurnameValid && isRecipientNameValid) {
        _recipientSurnameFormKey.currentState!.save();
        _recipientNameFormKey.currentState!.save();
        //to vibrate the phone
        await HapticFeedback.lightImpact();
        setState(() => isLoading = true);
       // voterList = await ObjectBox.getEasySearchData(nameController.text, surnameController.text);
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
    if (_controller.hasClients) {
      _controller.animateTo(0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
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
              customInputs(),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onPressed: () {
                  getData();
                  }, label: 'Search',
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(thickness: 2,),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: voterList.isNotEmpty
                    ? ListView.builder(
                  controller: _controller,
                  itemCount: voterList.length,
                  itemBuilder: (context, index) => Card(
                    key: ValueKey(voterList[index].id),
                    color: const Color.fromRGBO(230, 238, 255, 1),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    child: ListTile(
                      leading: const Text( "", style: TextStyle(fontSize: 0),),
                      minLeadingWidth : 1,
                      title: Text("${voterList[index].lnEnglish} ${voterList[index].fnEnglish}"),
                      subtitle: Text("${voterList[index].lnMarathi} ${voterList[index].fnMarathi}"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context) =>  DetailPage(data : voterList[index], searchType: "Surname",)));
                      },
                    ),
                  ),
                )
                    : const Center(
                  child: Text("Please enter surname and name then click on search button"),
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
          Flexible(
            flex: 1,
            child:
            Form(
              key: _recipientSurnameFormKey,
              child: TextFormField(
                autofocus: true,
                controller: surnameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter surname";
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
          const SizedBox(width: 10,),
          Flexible(
            flex: 1,
            child:
            Form(
              key: _recipientNameFormKey,
              child: TextFormField(
                autofocus: true,
                controller: nameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter first name";
                  }
                  return null;
                },
                onSaved: (String? phoneNumber) {},
                decoration: InputDecoration(
                  hintText: 'Enter first name',
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
          )
        ],
      ),
    );
  }



}
