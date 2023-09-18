import 'package:flutter/material.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';

class RequestSubmissionPage extends StatefulWidget {
  final String id;
  const RequestSubmissionPage({Key? key, required this.id}) : super(key: key);

  @override
  State<RequestSubmissionPage> createState() => _RequestSubmissionPageState(id);
}

class _RequestSubmissionPageState extends State<RequestSubmissionPage> {
  String id;
  _RequestSubmissionPageState(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Requests Confirmation", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.blueAccent, // <-- SEE HERE
          ),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Text('Your Request Has been Submitted',style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
          // ElevatedButton(onPressed: (){
          //   Navigator.push(
          //       context, MaterialPageRoute(builder: (BuildContext context) {
          //     return MyDashboard(id: "", name: name, email: email);
          //   }));
          // }, child: Text('Back to Dasboard'))
        ],
      ),
    );
  }
}
