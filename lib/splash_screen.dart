
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5),
            ()=> Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
            (context) => const LoginPage()))
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/background.jpg'),
                  fit: BoxFit.fitHeight),
            ),
          ),
          Container(
            color: const Color.fromRGBO(255, 255, 255, 0.80),
          ),
          SizedBox(
            width: screenWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('images/ic_launcher.png',
                  height: 100,
                  width: 100,),
                const SizedBox(height: 10),
                const Text("Majrekar's Voter Management\n System",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40,
                      color: Colors.black,
                      fontFamily: 'FUTURALC',
                      decoration: TextDecoration.none),),
                const Text("Search Mobile Software",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'LatoRegular',
                      decoration: TextDecoration.none),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

