import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/adminpages/viewahopkeeperrequest.dart';

class ShopkeeperRequests extends StatefulWidget {
  final String id;
  const ShopkeeperRequests({Key? key, required this.id}) : super(key: key);

  @override
  State<ShopkeeperRequests> createState() => _ShopkeeperRequestsState(id);
}

class _ShopkeeperRequestsState extends State<ShopkeeperRequests> {
  String id;
  _ShopkeeperRequestsState(this.id);
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("ShopKeeper Requests", style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ), onPressed: () {
                Navigator.pop(context);
              },
              ),
              bottom: const TabBar(
                  tabs: [
                    Tab(icon: Text('Pending', style: TextStyle(color: Colors.black, fontSize: 20),)),
                    Tab(icon: Text('Accepted', style: TextStyle(color: Colors.black, fontSize: 20),)),
                  ]),
            ),
            body: TabBarView(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder(
                      future: mongoDatabase.getShops(),
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
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index){
                                  print(snapshot.data[index]);
                                  return displayCard(MongoDbShop.fromJson(snapshot.data[index]), false); // Calling fuction passing data (from json) data into our model class
                                });
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

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder(
                      future: mongoDatabase.getShops(),
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
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index){
                                  print(snapshot.data[index]);
                                  return displayCard(MongoDbShop.fromJson(snapshot.data[index]), true); // Calling fuction passing data (from json) data into our model class
                                });
                          } else {
                            return Center(
                              child: Text("No Data Available."),
                            );
                          }
                        }
                      },
                    ),
                  ), //Future builder to fetch data
                ),              ],
            ),
          ),
        ),
      );
  }
  Widget displayCard(MongoDbShop shopdata, bool isaccepted){
    if(isaccepted == shopdata.isApproved){
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shop Name: '+ shopdata.shopname),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Owner Name: '+ shopdata.name),
                  ],
                ),
                IconButton(onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ViewShopkeeperRequest(id: id,);
                          },
                          settings: RouteSettings(
                              arguments: shopdata)))
                      .then((value) => setState(() {}));
                }, icon: Icon(Icons.remove_red_eye_outlined,
                  color: Colors.black,)),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return Container();
    }
  }
}
