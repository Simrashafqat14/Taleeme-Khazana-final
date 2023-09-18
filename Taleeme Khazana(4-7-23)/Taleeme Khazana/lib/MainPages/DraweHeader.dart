import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/personalShop.dart';
import 'package:fyp_project/userActionPages/registerpage.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

import '../Userprofilepages/EditProfilePage.dart';
import '../Userprofilepages/PersonalProfile.dart';

class HeaderDrawer extends StatefulWidget {
  final String? text;
  final MongoDbModel userdata;
  const HeaderDrawer({Key? key, required this.text, required this.userdata}) : super(key: key);

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState(text, userdata);
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  String? text;
  MongoDbModel userdata;
  _HeaderDrawerState(this.text, this.userdata);
  Widget navigationDrawer() {
    print("header: " + text!);
    Uint8List bytes = base64.decode(userdata.userimage);

    return Container(
        color: Colors.blue,
        width: double.infinity,
        height: 220,
        padding: EdgeInsets.only(top: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userdata.userimage != "" ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.memory(
                  bytes!,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(
                  height: 80,
                  width: 80,'assets/profile.jpg')),
              Text(userdata.userName,
                style: TextStyle(color: Colors.white, fontSize: 20),),
              Text(userdata.email,
                style: TextStyle(color: Colors.grey[200], fontSize: 14),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return ViewPersonalProfile(id: text!);
                        }, settings: RouteSettings(arguments: userdata)))
                        .then((value) {
                      setState(() {});
                    });
                  },
                      child: Text('View Profile',
                        style: TextStyle(color: Colors.white, fontSize: 14),)
                  ),
                  if(userdata.role == "ShopKeeper")...[
                    FutureBuilder(
                        future: mongoDatabase.getShops(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if(snapshot.connectionState== ConnectionState.waiting){
                            return Center(child:
                            CircularProgressIndicator(),
                            );
                          } else{
                            if(snapshot.hasData){
                              var totaldata = snapshot.data.length;
                              print("Total data: " + totaldata.toString());
                              for(var i = 0; i < totaldata; i++){
                                if(MongoDbShop.fromJson(snapshot.data[i]).userid == text){
                                  return ElevatedButton(onPressed: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return personalShopPage(id: text!, userdata:userdata!);
                                        }, settings: RouteSettings(arguments: MongoDbShop.fromJson(snapshot.data[i]))))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                      child: Text('View Shop',
                                        style: TextStyle(color: Colors.white, fontSize: 14),)
                                  );
                                }
                              }
                              return Container();
                            }else{
                              return Center(
                                child: Text("No Data Available."),
                              );
                            }
                          }
                        },
                      ),


                  ]
                  else...[
                    ElevatedButton(onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return EditProfile(title: 'Edit Profile');
                          }, settings: RouteSettings(arguments: userdata)))
                          .then((value) {
                        setState(() {});
                      });
                    },
                        child: Text('Edit Profile',
                          style: TextStyle(color: Colors.white, fontSize: 14),)
                    ),
                  ]
                ],
              ),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    print(userdata.userName);
    print(text);
    return Container(
      child: navigationDrawer()
    );
  }
}
