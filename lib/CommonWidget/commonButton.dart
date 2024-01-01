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
                    Color.fromRGBO(143, 148, 251, 1),
                    Color.fromRGBO(143, 148, 251, .6),
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
                  width: 1.0,
                  color: Colors.transparent,
                ),
              ),
              onPressed: onPressed,
              child: Text(label,
                style: const TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ),
      );
  }
}