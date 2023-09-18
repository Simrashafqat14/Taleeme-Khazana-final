import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/EditProfilePage.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';


class PasswordChnagePage extends StatefulWidget {
  const PasswordChnagePage({Key? key}) : super(key: key);

  @override
  State<PasswordChnagePage> createState() => _PasswordChnagePageState();
}

class _PasswordChnagePageState extends State<PasswordChnagePage> {
  bool isHiddenPassword = true;
  GlobalKey<FormState> _FormKey = GlobalKey<FormState>();
  var passwordController = new TextEditingController();
  var newpasswordController = new TextEditingController();
  var confirmPasswordController = new TextEditingController();
  String password = '';
  String newpassword = '';
  String confirmPassword = '';
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  Widget build(BuildContext context) {

    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Password", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context){
                return EditProfile(title: 'Edit Profile');
              },settings: RouteSettings(arguments: data)))
              .then((value) => setState(() {}));
        },
        ),
        actions: [
          IconButton(
            onPressed: (){
              //_updateuser(data.id, imageController.text, data.email, data.userName, data.password, fullNameController.text, nicknameController.text, addressController.text, cityController.text, countryController.text);
              if (_FormKey.currentState?.validate() == true) {

                    _updatepass(newpassword, data);
              }
              else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All fields are required")));
              }
            },
            icon: Icon(Icons.done_outline),
            color: Colors.white,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Form(
                key: _FormKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
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
                                  labelText: 'Enter Your Old Password',
                                  labelStyle: TextStyle(color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (val) {
                                  if (val?.isEmpty == true) {
                                    return 'Password is required!';
                                  }
                                  if(val != data.password){
                                    return 'Incorrect Password';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blueAccent),
                                obscureText: _obscureText,
                              ),
                            ),
                            IconButton(
                              onPressed: _toggle,

                              icon: Icon(_obscureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye_rounded), color: Colors
                                .blueAccent,)
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
                                controller: newpasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Enter New Password',
                                  labelStyle: TextStyle(color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  newpassword = value;
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
                                    fontSize: 16.0, color: Colors.blueAccent),
                                obscureText: _obscureText,
                              ),
                            ),
                            IconButton(
                              onPressed: _toggle,

                              icon: Icon(_obscureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye_rounded), color: Colors
                                .blueAccent,)
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
                                  labelStyle: TextStyle(color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                // validator: MultiValidator(
                                //   [
                                //     RequiredValidator(errorText: 'Password is required.'),
                                //     LengthRangeValidator(min: 6, max: 50, errorText: 'Password length is too short'),
                                //   ],
                                // ),
                                textAlign: TextAlign.left,
                                onChanged: (value) {
                                  confirmPassword = value;
                                },
                                validator: (val) {
                                  if (val?.isEmpty == true) {
                                    return 'Password is required!';
                                  }
                                  if (val != newpassword) {
                                    return 'Password does not match';
                                  }

                                  return null;
                                },
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blueAccent),
                                obscureText: _obscureText,
                              ),
                            ),
                            IconButton(
                                onPressed: _toggle,

                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_rounded), color: Colors
                                .blueAccent)
                            // //child: new Text(_obscureText ? "Show" : "Hide"))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _updatepass(String _password, MongoDbModel data) async{
    print(data.id);
    //final password_update = MongoDbModel(id: id, email: _email, userName: _userName, password: _password);
    final password_update = MongoDbModel(id: data.id, userimage: data.userimage, email: data.email, userName: data.userName, password: _password, fullname: data.fullname, nickname: data.nickname, address: data.address, city: data.city, country: data.country, role: data.role, contactno: data.contactno);
    await mongoDatabase.forgetpassword(password_update).whenComplete(() => Navigator.pop(context));
    _clearAll();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Updated ")));
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context){
          return EditProfile(title: 'Edit Profile');
        },settings: RouteSettings(arguments: data)))
        .then((value) => setState(() {}));
  }
  void _clearAll(){
    newpasswordController.text = "";
    confirmPasswordController.text = "";
    passwordController.text = "";
  }
}

