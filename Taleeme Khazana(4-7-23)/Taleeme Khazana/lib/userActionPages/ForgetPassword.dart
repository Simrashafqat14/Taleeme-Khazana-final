import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:form_field_validator/form_field_validator.dart';

class myForgetPage extends StatefulWidget {
  const myForgetPage({Key? key}) : super(key: key);

  @override
  State<myForgetPage> createState() => _myForgetPage();
}

class _myForgetPage extends State<myForgetPage> {
  bool isHiddenPassword = true;
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  var emailController = new TextEditingController();
  var passwordController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();
  String email = '';
  String password = '';
  String confirmPassword = '';
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
    Widget title = Text(
      'Get your Account back',
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
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Forget Password',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Avanto',
            fontSize:16.0,
          ), textAlign: TextAlign.center,
        ));

    Widget forgetPassForm = SizedBox(
      child: Container(
        height: 450,
        child: Stack(
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                      padding: const EdgeInsets.only(top: 10.0,),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        decoration: InputDecoration(
                          //hintText: 'Email',
                          labelText: 'Email', labelStyle: TextStyle(fontFamily: 'Avanto',
                            color: Colors.white, fontSize: 15),

                        ),
                        validator: MultiValidator(
                            [
                              RequiredValidator(
                                  errorText: 'Email is required.'),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(fontFamily: 'Avanto',
                                    color: Colors.white, fontSize: 15),
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                password = value;
                              },
                              validator: (val) {
                                if (val?.isEmpty == true) {
                                  return 'Password is required!';
                                }
                                if (val!.length <= 5) {
                                  return 'Password length is too short';
                                }
                                if (val.contains(' ') == true) {
                                  return 'Space is not allowed';
                                }
                                if (val.contains(
                                    new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) !=
                                    true) {
                                  return 'Use special characters for a strong password';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                              obscureText: _obscureText,
                            ),
                          ),
                          IconButton(
                            onPressed: _toggle,

                            icon: Icon(_obscureText
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye_rounded), color: Colors
                              .white,)
                          // //child: new Text(_obscureText ? "Show" : "Hide"))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Re Enter New Password',
                                labelStyle: TextStyle(fontFamily: 'Avanto',
                                    color: Colors.white, fontSize: 15),
                              ),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                confirmPassword = value;
                              },
                              validator: (val) {
                                if (val?.isEmpty == true) {
                                  return 'Password is required!';
                                }
                                if (val != password) {
                                  return 'Password does not match';
                                }

                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                              obscureText: _obscureText,
                            ),
                          ),
                          IconButton(
                              onPressed: _toggle,

                              icon: Icon(_obscureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye_rounded), color: Colors
                              .white)
                          // //child: new Text(_obscureText ? "Show" : "Hide"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _button(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      resizeToAvoidBottomInset: true,
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
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
                    SizedBox(height: 10),
                    title,
                    SizedBox(height: 10),
                    subTitle,
                    SizedBox(height: 30),
                    forgetPassForm,
                  ],
                )

            ),
          ],
        ),
      ),
    );
  }

  Widget _button() {
    return Positioned(
      left: MediaQuery.of(context).size.width / 5,
      bottom: 160,
      child: FutureBuilder(
        future: mongoDatabase.login(),
        builder: (context, AsyncSnapshot snapshot){

          if(snapshot.hasData){

            var totaldata = snapshot.data.length;
            print("Total data: " + totaldata.toString());
            var limit = totaldata-1;

            //return loginAttempt(MongoDbModel.fromJson(snapshot.data[limit]));
            return TextButton(onPressed: () {
              if (_FormKey.currentState?.validate() == true) {
                for(int i =0; i<totaldata;i++){
                  if(MongoDbModel.fromJson(snapshot.data[i]).email == email) {

                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email exists")));
                    _updatepass(MongoDbModel.fromJson(snapshot.data[i]).id,MongoDbModel.fromJson(snapshot.data[i]).email, MongoDbModel.fromJson(snapshot.data[i]).userName, password, MongoDbModel.fromJson(snapshot.data[i]));
                    break;
                  }
                }
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All fields are required")));
              }
            },
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                height: 60,
                child: Center(
                    child: new Text("Confirm",
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
            );
          }else{
            return TextButton(onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Check You internet Connection")));

            },
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                height: 60,
                child: Center(
                    child: new Text("Confirm",
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
            );
          }
          //}
        },
      ),
    );


  }
  Future<void> _updatepass(var id,String _email, String _userName, String _password, MongoDbModel data) async{
    print(id);
    print(_userName+_email+_password);
    //final password_update = MongoDbModel(id: id, email: _email, userName: _userName, password: _password);
    final password_update = MongoDbModel(id: id, userimage: data.userimage, email: _email, userName: _userName, password: _password, fullname: data.fullname, nickname: data.nickname, address: data.address, city: data.city, country: data.country, role: data.role, contactno: data.contactno);
    await mongoDatabase.forgetpassword(password_update).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Updated ")));
  }
  void _clearAll(){
    emailController.text = "";
    confirmPasswordController.text = "";
    passwordController.text = "";
  }
}

