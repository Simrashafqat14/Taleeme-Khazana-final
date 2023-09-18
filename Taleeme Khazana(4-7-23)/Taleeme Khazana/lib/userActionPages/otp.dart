import 'package:flutter/material.dart';
import '../EmailOTP.dart';
import 'contactinfo.dart';


class otpScreen extends StatefulWidget {
  final String email1, userName, password, contactno;
  const otpScreen({Key? key,required this.email1,required this.userName,required this.password, required this.contactno}) : super(key: key);

  @override
  State<otpScreen> createState() => _otpScreenState(email1, userName, password, contactno);
}

class _otpScreenState extends State<otpScreen> {
  String email1, userName, password, contactno;
  _otpScreenState(this.email1, this.userName, this.password, this.contactno);
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    print(email1);
    print(userName);
    print(password);
    print(contactno);
    email.text = email1;
    return Scaffold(
      appBar: AppBar(
        title:Text('Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/TaleemeKhazana(Logo).png",
                height: 350,
              ),
            ),
            const SizedBox(
              height: 60,
              child: Text(
                "Lets get Started",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,fontFamily: 'Roboto'),
              ),
            ),
            const SizedBox(height: 10,),
            FittedBox(
              child: const Text("Add your valid Email address. \nWe'll send you a verification code that you are  a real",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 38,),
            Card(
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.blue,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () async {
                            myauth.setConfig(
                                appEmail: "",
                                appName: "Taleem-e-Khazana",
                                userEmail: email.text,
                                otpLength: 4,
                                otpType: OTPType.digitsOnly);
                            if (await myauth.sendOTP() == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("OTP has been sent"),
                              ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>   OtpScreen(myauth: myauth,email1: email1, userName: userName, password: password, contactno: contactno,)));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Oops, OTP failed"),
                              ));
                            }
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.blue,
                          )),
                      hintText: "Email Address",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }




}
