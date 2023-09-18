import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/dashboardpage.dart';
import 'package:fyp_project/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Calling database connect when app stars inside main()
  await mongoDatabase.connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taleem-e-Khazana',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Raleway1',
      ),

      home: mySplashScreen(),
    );
  }
}

