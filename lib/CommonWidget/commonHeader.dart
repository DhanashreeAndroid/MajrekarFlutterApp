import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class CommonHeader extends StatelessWidget {
  const CommonHeader({super.key, required this.onPressed});
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return getCommonHeader(context, onPressed);
  }

}

Widget getCommonHeader(BuildContext context, GestureTapCallback onPressed){
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    height: 135,
    width: screenWidth,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(218,222,224, 1),
              Color.fromRGBO(218,222,224, .6),
            ]
        )
    ),
    child: Column(
      children:   [
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Image.asset("images/leftarrow.png",
                    height: 30,
                    width: 30),
                onPressed: onPressed,
              ),
            ),
            Expanded(
              child: Container(
                child: Column(children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 40.0, 0.0),
                      child: Text(
                        "MAJREKAR'S",
                        style: TextStyle(
                            color: Color.fromRGBO(7, 53, 250, 1),
                            fontSize: 40,
                            fontFamily: 'Calibri',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        const Text(
          "Voters Management System",
          style: TextStyle(
              color: Color.fromRGBO(7, 53, 250, 1),
              fontSize: 20,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.bold),
        ),
        const Text(
          "Contact - 9892862864/9867262864",
          style: TextStyle(
              color: Color.fromRGBO(7, 53, 250, 1),
              fontSize: 20,
              fontFamily: 'Calibri',
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        divider(screenWidth)
      ],
    ),
  );
}

SizedBox divider(double screenWidth) {
  return SizedBox(
    height: 1,
    width: screenWidth,
    child: const DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
    ),
  );
}
