import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'otp.dart';

class myRegisterPage extends StatefulWidget {
  const myRegisterPage({Key? key}) : super(key: key);
  @override
  State<myRegisterPage> createState() => _myRegisterPageState();
}
class _myRegisterPageState extends State<myRegisterPage> {
  bool isHiddenPassword=true;
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  var emailController = new TextEditingController();
  var userNameController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();
  var contactnoController=new TextEditingController();

  String email = '';
  String userName = '';
  String password = '';
  String contactno = '';
  String confirmPassword = '';
  // String contactNumber='';
  String address='';
  bool _obscureText = true;
  String _password = '';

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget title = FittedBox(
      child: Text(
        'Register your Account',
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo',
            shadows: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ]),
        textAlign: TextAlign.center,
      ),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: FittedBox(
          child: Text(
            'Create your new account',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Avanto',
              fontSize: 20.0,
            ),textAlign: TextAlign.center,
          ),
        ));
    Widget registerForm = SizedBox(
      child: Container(
        height: 650,
        child: Stack(
          children: <Widget>[
            Container(
              height: 620,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              decoration: BoxDecoration(
                  color: Colors.blue,
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
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),

                        ),
                        validator: MultiValidator(
                            [
                              RequiredValidator(errorText: 'Email is required.'),
                              EmailValidator(errorText: 'Invalid Email Address')
                            ]
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          email = value;
                        },
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        autovalidateMode:AutovalidateMode.onUserInteraction,
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'Username',labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),
                        ),
                        validator: (val) {
                          if (val?.isEmpty == true) {
                            return 'Password is required!';
                          }
                          if(val?.contains(' ') == true){
                            return 'Space is not allowed';
                          }
                          return null;
                        },
                        cursorColor:Colors.white,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          userName = value;
                        },
                        style: TextStyle(fontSize: 16.0, color: Colors.white, decorationColor: Colors.white),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                password = value;
                              },
                              validator: (val) {
                                if (val?.isEmpty == true) {
                                  return 'Password is required!';
                                }
                                if(val!.length <= 5){
                                  return 'Password length is too short';
                                }
                                if(val!.length >= 20){
                                  return 'Password length is too long';
                                }
                                if(val.contains(' ') == true){
                                  return 'Space is not allowed';
                                }
                                if(val.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) != true){
                                  return 'Use special characters for a strong password';
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 16.0, color: Colors.white ),
                              obscureText: _obscureText,
                            ),
                          ),
                          IconButton(
                            onPressed: _toggle,

                            icon: Icon(_obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded),color: Colors.white,)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',labelStyle: TextStyle(color: Colors.white,fontFamily: 'Avanto',fontSize: 15),
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                confirmPassword = value;

                              },
                              validator: (val) {
                                if (val?.isEmpty == true) {
                                  return 'Password is required!';
                                }
                                if(val != password){
                                  return 'Password does not match';
                                }

                                return null;
                              },
                              style: TextStyle(fontSize: 16.0, color: Colors.white ),
                              obscureText: _obscureText,
                            ),
                          ),
                          IconButton(
                              onPressed: _toggle,

                              icon: Icon(_obscureText ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded),color:Colors.white)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: IntlPhoneField(
                        decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Avanto'
                            )
                        ),
                        controller: contactnoController,
                        onChanged: (val){
                          contactno = val.toString();
                        },
                        initialCountryCode: 'PK',
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(left: MediaQuery.of(context).size.width / 5,
                bottom: 0,
                child: regAttempt(emailController.text, userNameController.text,passwordController.text, contactnoController.text)
            ),

          ],
        ),
      ),
    );
    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic,fontFamily: 'Arvo', color: Colors.black),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.facebook_outlined),
              onPressed: () {},
              color: Colors.blueAccent,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.blueAccent),
          ],
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      resizeToAvoidBottomInset : true,
      body: SingleChildScrollView(
        child:
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  title,
                  SizedBox(
                    height: 30,
                  ),
                  subTitle,
                  SizedBox(
                    height: 60,
                  ),
                  registerForm,
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 20), child: socialRegister)
                ],
              ),
            ),
        ),
      );
  }



  Widget regAttempt(String email, String username, String pass, String contactno) {
    print("log_email: " + email);
    print("log_name: " + username);
    String log_email = "";
    String log_name = "";
    MongoDbModel? data;
    String id = "";
    return Column(
      children: [
        FutureBuilder(
          future: mongoDatabase.login(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              print("email1: " + email);
              print("pass1: " + username);
              var totaldata = snapshot.data.length;
              print("Total data: " + totaldata.toString());
              var limit = totaldata - 1;
              //return loginAttempt(MongoDbModel.fromJson(snapshot.data[limit]));
              for (int i = 0; i <= limit; i++) {
                if (email == MongoDbModel.fromJson(snapshot.data[i]).email && username == MongoDbModel.fromJson(snapshot.data[i]).userName) {
                  log_email = email;
                  log_name = username;
                  data = MongoDbModel.fromJson(snapshot.data[i]);
                  id = MongoDbModel.fromJson(snapshot.data[i]).id.$oid;
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
          if(contactno != ""){
            if (_FormKey.currentState?.validate() == true) {
              try {
                if (email == log_email || username == log_name) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("email/username already exists")));
                }

                else{
                  if (_FormKey.currentState?.validate() == true) {
                    //_insertdata(email, username, passwordController.text);
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return  otpScreen(email1: email, userName: username, password: passwordController.text, contactno: contactnoController.text,);
                    }));
                  }
                }
              } catch (e) {
                print(e);
              }
            }
          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please add a valid phone no " )));
          }
        },
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            height: 60,
            child: Center(
                child: new Text("Register",
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
  void clearall(String email,String username, String pass){
    email = "";
    username = "";
    pass = "";
  }



}
