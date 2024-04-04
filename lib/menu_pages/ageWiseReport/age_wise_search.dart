import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:majrekar_app/CommonWidget/commonHeader.dart';
import 'package:majrekar_app/menu_pages/ageWiseReport/age_count_page.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/partno_drop_list_model.dart';
import 'package:majrekar_app/menu_pages/buildingWiseSearch/part_no_drop_list_item.dart';
import 'package:majrekar_app/menu_pages/languageSearch/language_list_page.dart';

import '../../CommonWidget/commonButton.dart';
import '../../CommonWidget/show_snak_bar.dart';
import '../../CommonWidget/utility.dart';
import '../../database/ObjectBox.dart';
import '../../model/DataModel.dart';
import '../common_pages/voter_list_page.dart';


class AgeWiseSearch extends StatefulWidget {
  const AgeWiseSearch({Key? key}) : super(key: key);

  @override
  State<AgeWiseSearch> createState() => _AgeWiseSearchSearchState();
}

class _AgeWiseSearchSearchState extends State<AgeWiseSearch> {
  final ScrollController _controller = ScrollController();
  bool isLoading = false;
  final _recipientPartNoKey = GlobalKey<FormState>();
  TextEditingController partNoController = TextEditingController();


  bool isValidate()  {
    try {
      final isRecipientSurnameValid =
      _recipientPartNoKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isRecipientSurnameValid) {
        _recipientPartNoKey.currentState!.save();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

 void callListPage(String ageRange){
   Navigator.push(context,
       MaterialPageRoute(builder: (context) =>  AgeCountPage(
         partNo: partNoController.text,ageRange: ageRange,)));
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
                const Center(child: Text("Age Group List")),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("18-29");
                            }
                          }, label: '18 - 29',
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                              if(isValidate()) {
                                callListPage("30-39");
                              }
                          }, label: '30 - 39',
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("40-49");
                            }
                          }, label: '40 - 49',
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("50-59");
                            }
                          }, label: '50 - 59',
                        ),
                        Visibility(
                          visible: false,
                          child: CustomButton(
                            onPressed: () {
                              if(isValidate()) {
                                callListPage("60-69");
                              }
                            }, label: '60 - 69',
                          ),
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("70-79");
                            }
                          }, label: '70 - 79',
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("80-89");
                            };
                          }, label: '80 - 89',
                        ),
                         CustomButton(
                            onPressed: () {
                              if(isValidate()) {
                                callListPage("90-99");
                              }
                            }, label: '90 - 99',
                          ),
                        const SizedBox(height: 20,),
                        CustomButton(
                          onPressed: () {
                            if(isValidate()) {
                              callListPage("100-.");
                            };
                          }, label: '100 - ...',
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
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
            flex: 1,
            child:
            Form(
              key: _recipientPartNoKey,
              child: TextFormField(
                controller: partNoController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
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
        ],
      ),
    );
  }


}
