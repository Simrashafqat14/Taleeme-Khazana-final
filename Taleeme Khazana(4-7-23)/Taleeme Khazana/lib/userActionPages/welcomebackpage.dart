import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/userActionPages/ForgetPassword.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/userActionPages/registerpage.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';


class myWelcomeBackPage extends StatefulWidget {
  const myWelcomeBackPage({Key? key}) : super(key: key);

  @override
  State<myWelcomeBackPage> createState() => _myWelcomeBackPageState();
}

class _myWelcomeBackPageState extends State<myWelcomeBackPage> {
  bool isHiddenPassword=true;
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _obscureText = true;
  MongoDbModel? data;
  String _password = '';
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  Future<bool> _onBackButtonPressed() async {
    bool exitapp = await
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return MyDashboard(id: "");
        }, settings: RouteSettings(
            arguments: data)));
    return exitapp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = FittedBox(
      child: Text(
        'Welcome To \nTALEEM-E-KHAZANA',
        style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Arvo',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            shadows: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ]),
      ),
    );

    Widget subTitle = Padding(
      padding: const EdgeInsets.only(right: 56.0),
      child: Text(
        'Login to your account using Email',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Avanto',
          fontSize: 16.0,
        ),
      ),);
    Widget loginForm = Container(
      height: 250,
      child: Stack(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Form(
              key: _FormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      autovalidateMode:AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Email', labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),
                      ),
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        email = value;
                      },

                      validator: MultiValidator(
                          [
                            RequiredValidator(errorText: 'Email is required.'),
                            EmailValidator(errorText: 'Invalid Email Address')
                          ]
                      ),
                      style: TextStyle(fontSize: 16.0),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Password',labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),

                            ),
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              password = value;
                            },
                            // validator: MultiValidator(
                            //     [
                            //       RequiredValidator(errorText: 'Password is required.'),
                            //     ]
                            // ),
                            validator: (val) {
                              if (val?.isEmpty == true) {
                                return 'Password is required!';
                              }
                              if(val!.length <= 5){
                                return 'Password length is too short';
                              }
                              if(val.contains(' ') == true){
                                return 'Space is not allowed';
                              }
                              return null;
                            },
                            obscureText: _obscureText,
                            style: TextStyle(fontSize: 15.0, ),
                            //obscureText: true,
                          ),
                        ),
                        IconButton(
                          onPressed: _toggle,

                          icon: Icon(_obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded,color: Colors.white,),)
                        // //child: new Text(_obscureText ? "Show" : "Hide"))
                      ],
                    ),
                    // IconButton(
                    //   onPressed: _toggle,
                    //
                    //   icon: Icon(_obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded),)
                    // //child: new Text(_obscureText ? "Show" : "Hide"))


                  ),

                ],
              ),
            ),
          ),
          Positioned(left: MediaQuery
              .of(context)
              .size
              .width / 6,
              bottom: 10,
              child: loginAttempt(email, password)
          ),
        ],
      ),
    );
    Widget register = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Do not have an account? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return myRegisterPage();
                  }));
            },
            child: Text(
              'Register',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return myForgetPage();
                  }));
            },
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );


    return WillPopScope(
      onWillPop: () =>
          _onBackButtonPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
        ),
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 400,
                                    height: 200,
                                    child:
                                    Image.asset('assets/TaleemeKhazana(Logo).png',
                                      width: 240,),
                                  ),
                                  // Spacer(flex:1),
                                  // SizedBox(
                                  //   height: 40,
                                  // ),
                                  //Spacer(flex: 3),
                                  welcomeBack,
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Spacer(),
                                  subTitle,
                                  SizedBox(
                                    height: 20,
                                  ),
                                 // Spacer(flex: 2),
                                  loginForm,
                                  SizedBox(
                                    height: 10,
                                  ),
                                 // Spacer(flex: 1),
                                  register,
                                  SizedBox(
                                    height: 05,
                                  ),
                                  //Spacer(flex: 1),
                                  forgotPassword,
                                ],
                              ),
                          )
                        ],
                      ),
                  ),
          ),
    );

  }
  // static List<MongoDbModel> mainmovieslist = [
  //   MongoDbModel.fromJson()
  // ];
  // List<MongoDbModel> display_list = List.from(MongoDbModel);
  Widget loginAttempt(String email, String pass) {
    print("email: " + email);
    print("pass: " + pass);
    String log_email = "";
    String log_pass = "";
    MongoDbModel? data;
    String id = "";
    return Column(
      children: [
        FutureBuilder(
          future: mongoDatabase.login(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("email1: " + email);
              print("pass1: " + pass);
              var totaldata = snapshot.data.length;
              print("Total data: " + totaldata.toString());
              var limit = totaldata - 1;
              //return loginAttempt(MongoDbModel.fromJson(snapshot.data[limit]));
              for (int i = 0; i <= limit; i++) {
                if (email == MongoDbModel
                    .fromJson(snapshot.data[i])
                    .email && pass == MongoDbModel
                    .fromJson(snapshot.data[i])
                    .password) {
                  log_email = email;
                  log_pass = pass;
                  data = MongoDbModel.fromJson(snapshot.data[i]);
                  id = MongoDbModel
                      .fromJson(snapshot.data[i])
                      .id
                      .$oid;
                  break;
                }
              }
              return Container();
            }
            else {
              return Container();
            }
            //}
          },
        ),
        TextButton(onPressed: () {
            if (_FormKey.currentState?.validate() == true) {
              try {
                if (email == log_email && pass == log_pass) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Logged in Successfully")));
                  //String _id = data.id as String;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return MyDashboard(id: id);
                      }, settings: RouteSettings(
                          arguments: data)));
                  clearall(email, pass);
                }

                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: const Duration(seconds: 1), content: Text(
                          "Incorrect Email or Password")));
                }
              } catch (e) {
                print(e);
              }
            }
          },
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
              height: 60,
              child: Center(
                  child: new Text("Login",
                      style: const TextStyle(
                          color: const Color(0xfffefefe),
                          fontWeight: FontWeight.w100,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Arvo',
                          fontSize: 20.0))),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(34, 168, 225, 1.0),
                        Color.fromRGBO(45, 175, 218, 1.0),
                        Color.fromRGBO(43, 103, 215, 1.0),
                      ],
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.16),
                      offset: Offset(0, 5),
                      blurRadius: 10.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(9.0)),
            ),
          ),
      ],
    );
  }
  void clearall(String email, String pass){
    email = "";
    pass = "";
  }

}
