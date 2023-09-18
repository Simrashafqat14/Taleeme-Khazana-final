import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbRider.dart';

class ViewRiderRequest extends StatefulWidget {
  final String id;
  const ViewRiderRequest({Key? key, required this.id}) : super(key: key);
  @override
  State<ViewRiderRequest> createState() => _ViewRiderRequestState(id);
}

class _ViewRiderRequestState extends State<ViewRiderRequest> {
  String id;
  _ViewRiderRequestState(this.id);
  @override
  Widget build(BuildContext context) {
    MongodbRider data = ModalRoute.of(context)!.settings.arguments as MongodbRider;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Full Name:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.name,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Rider  Email:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.email,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Address:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.address + ' ' + data.city ,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
            Text(data.country,style:
            TextStyle(color: Colors.black,
              fontSize: 15,), textAlign: TextAlign.left,),
            if(data.isaccepted == false)...[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: mongoDatabase.getRider(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child:
                        CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          var totaldata = snapshot.data.length;
                          print("Total data: " + totaldata.toString());
                          for(int index = 0; index < totaldata; index++){
                            if(MongodbRider.fromJson(snapshot.data[index]).id.$oid == data.id.$oid ){


                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        _approve(MongodbRider.fromJson(snapshot.data[index]));
                                      },
                                      child: Text('Approve ')),
                                ],
                              );
                            }
                          }
                          return Container();
                        } else {
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    },
                  ),
                ), //Future builder to fetch data
              ),
            ]

          ],
        ),
      ),
    );
  }
  Future<void> _approve(MongodbRider userdata) async {

    final rider_update = MongodbRider(id: userdata.id, name: userdata.name, email: userdata.email, contactno: userdata.contactno, address: userdata.address, city: userdata.city, country: userdata.country, image: userdata.image, username: userdata.username, role: userdata.role, isaccepted: true, password: userdata.password);
    await mongoDatabase.updateRider(rider_update);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Approved... ")));
  }
}
