import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/main.dart';
import 'package:fyp_project/userActionPages/otp.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../EmailOTP.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          hintText: ('0'),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String email1, userName, password, contactno;
  const OtpScreen({Key? key,required this.myauth,required this.email1,required this.userName,required this.password, required this.contactno}) : super(key: key);
  final EmailOTP myauth ;
  @override
  State<OtpScreen> createState() => _OtpScreenState(email1, userName, password, contactno);
}

class _OtpScreenState extends State<OtpScreen> {
  String email1, userName, password, contactno;
  _OtpScreenState(this.email1, this.userName, this.password, this.contactno);
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";
  @override
  Widget build(BuildContext context) {
    print(email1);
    print(userName);
    print(password);
    print(contactno);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/TaleemeKhazana(Logo).png",
                height: 350,
              ),
            ),
            const Icon(Icons.dialpad_rounded, size: 50),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Verification",
              style: TextStyle(fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10,),
            Text('Enter verification code number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Otp(
                  otpController: otp1Controller,
                ),
                Otp(
                  otpController: otp2Controller,
                ),
                Otp(
                  otpController: otp3Controller,
                ),
                Otp(
                  otpController: otp4Controller,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (await widget.myauth.verifyOTP(otp: otp1Controller.text +
                      otp2Controller.text +
                      otp3Controller.text +
                      otp4Controller.text) == true) {
                    _insertdata(email1, userName, password, contactno);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("OTP is verified, User Registered Successfully"),
                    ));
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const myWelcomeBackPage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid OTP"),
                    ));
                  }
                },
                child: Text('Verify',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arvo'
                      ),
                    )
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text("Didn't Recieve Email? ",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return otpScreen(email1: email1, userName: userName, password: password, contactno: contactno,);
                      }));
                },
                    child: Text(
                      'Resend', style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 13,
                        color: Colors.blue
                    ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _insertdata(String _email, String _userName, String _password, String _contactno) async{
    var _id = mongo.ObjectId();
    //final data = MongoDbModel(id: _id, email: _email, userName: _userName, password: _password);
    final data = MongoDbModel(id: _id, userimage: '', email: _email, userName: _userName, password: _password, fullname: "", nickname: "", address: "", city: "", country: "", role: "Customer", contactno: _contactno);
    var result = await mongoDatabase.insert(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successfull " )));

  }

}
