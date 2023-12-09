
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget getCommonHeader(BuildContext context){
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    height: 100,
    width: screenWidth,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ]
        )
    ),
    child: Column(
      children:  const [
        SizedBox(height: 10,),
        AutoSizeText("Majrekar's Voters Management System",
          maxLines: 1,
          style: TextStyle(color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold)
          ,),
        AutoSizeText("Search Mobile Software",
          maxLines: 1,
          style: TextStyle(color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ,),
        AutoSizeText("Contact - 9892862864/9867262864",
          maxLines: 1,
          style: TextStyle(color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ,)

      ],
    ),
  );
}