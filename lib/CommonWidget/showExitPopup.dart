import 'dart:io';
import 'package:flutter/material.dart';


Future<bool?> showExitPopup(context) async{
  return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Want to Exit the app!"),
                const SizedBox(height:20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('yes selected');
                          String os = Platform.operatingSystem;

                          if(os == "windows") {
                            deleteData();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Please click on Ok to close the app."),
                              action: SnackBarAction(
                                label: 'OK',
                                textColor: Colors.white,
                                onPressed: () {
                                  exit(0);
                                },
                              ),
                            ));
                            Navigator.of(context).pop();
                          }else{
                            exit(0);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Text("Yes", style: TextStyle(color:
                        Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('no selected');
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade800,
                          ),
                          child: const Text("No", style: TextStyle(color:
                          Colors.white)),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      });


}
Future deleteData () async {
  //await ObjectBox.deleteAllBooths();
 // await ObjectBox.deleteAll();
 // await ObjectBox.deleteUserDetails();
}