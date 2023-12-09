import 'package:flutter/material.dart';
import 'package:majrekar_app/splash_screen.dart';

import 'database/ObjectBox.dart';
/// Provides access to the ObjectBox Store throughout the app.
late ObjectBox objectbox;

void main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


