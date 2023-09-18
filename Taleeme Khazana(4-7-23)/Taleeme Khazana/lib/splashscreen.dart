import 'package:flutter/material.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/userActionPages/registerpage.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';

class mySplashScreen extends StatefulWidget {
  const mySplashScreen({Key? key}) : super(key: key);

  @override
  State<mySplashScreen> createState() => _mySplashScreenState();
}

class _mySplashScreenState extends State<mySplashScreen> with SingleTickerProviderStateMixin{
  late Animation<double> opacity;
  late AnimationController controller;
  @override
  void initState(){
    // initState();
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)..addListener(() {
      setState(() {
      });
    });
    controller.forward().then((_) {
      navigationPage();
    });
  }

  Future initializeState() async {
    WidgetsFlutterBinding.ensureInitialized();

  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void navigationPage(){
    //MyDashboard(id: "", name: "",email: "",)
    MongoDbModel? data;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyDashboard(id: ""),settings: RouteSettings(arguments: data)));
  }
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Container(
        child: SafeArea(
          child: new Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(child: Opacity(
                  opacity: opacity.value,
                    child: new Image.asset('assets/TaleemeKhazana(Logo).png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Taleem e Khazana',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
