import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.label});
  final GestureTapCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30.0,0,30.0,0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(218,222,224, 1),
                    Color.fromRGBO(218,222,224, .6),
                  ]
              )
          ),
          child: SizedBox(
            width: 400,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.black38,
                ),
              ),
              onPressed: onPressed,
              child: Text(label,
                style: const TextStyle(color: Color.fromRGBO(7,53,250, 1),
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ),
      );
  }
}