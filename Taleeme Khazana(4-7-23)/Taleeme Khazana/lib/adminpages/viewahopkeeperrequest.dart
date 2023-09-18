import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/ViewProfile.dart';

class ViewShopkeeperRequest extends StatefulWidget {
  final String id;
  const ViewShopkeeperRequest({Key? key, required this.id}) : super(key: key);
  @override
  State<ViewShopkeeperRequest> createState() => _ViewShopkeeperRequestState(id);
}

class _ViewShopkeeperRequestState extends State<ViewShopkeeperRequest> {
  String id;
  _ViewShopkeeperRequestState(this.id);
  @override
  Widget build(BuildContext context) {
    MongoDbShop data = ModalRoute.of(context)!.settings.arguments as MongoDbShop;
    Uint8List bytes = base64.decode(data.image);
    Uint8List bytesreceipt = base64.decode(data.receiptimage);

    return Scaffold(
      appBar: AppBar(
        title: Text(data.shopname),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data.image != "" ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.memory(
                    bytes!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(
                    height: 100,
                    width: 100,'assets/defaultshop.png')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Shop Name:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.shopname,style:
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
                Text('Owner Name:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.name,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Owner Email:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.email,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: mongoDatabase.login(),
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
                          if(MongoDbModel.fromJson(snapshot.data[index]).id.$oid == data.userid ){


                            return ElevatedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return ViewProfile(id: data.userid, userid: id,);
                                      }, settings: RouteSettings(arguments: MongoDbModel.fromJson(snapshot.data[index]))))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Text('View Profile'));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data.receiptimage != "" ? Image.memory(
                    bytesreceipt!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ) : Image.asset(
                    height: 300,
                    width: 300,'assets/product_default.jpg'),
              ],
            ),
            if(data.isApproved == false)...[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: mongoDatabase.login(),
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
                            if(MongoDbModel.fromJson(snapshot.data[index]).id.$oid == data.userid ){


                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        _approve(MongoDbModel.fromJson(snapshot.data[index]), data);
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
  Future<void> _approve(MongoDbModel userdata, MongoDbShop shopdata) async {

    final role_update = MongoDbModel(id: userdata.id, userimage: userdata.userimage, email: userdata.email, userName: userdata.userName, password: userdata.password, fullname: userdata.fullname, nickname: userdata.nickname, address: userdata.address, city: userdata.city, country: userdata.country, role: "ShopKeeper", contactno: userdata.contactno);
    await mongoDatabase.updaterole(role_update);
    final shop_update = MongoDbShop(id: shopdata.id, userid: shopdata.userid, image: shopdata.image, email: shopdata.email, name: shopdata.name, shopname: shopdata.shopname, shopTagline: shopdata.shopTagline, shopemail: shopdata.shopemail, shopwebsite: shopdata.shopwebsite, shopDescription: shopdata.shopDescription, isApproved: true, isChecked: shopdata.isChecked, receiptimage: shopdata.receiptimage);
    await mongoDatabase.updateshop(shop_update);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Approved... ")));
  }
}
