import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/borrowrequests.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Requests/Viewrequest.dart';
import 'package:fyp_project/ViewProducts/borrow/biewborrowrequest.dart';

class LoginUserBorrowRequests extends StatefulWidget {
  final String id;
  const LoginUserBorrowRequests({Key? key, required this.id}) : super(key: key);

  @override
  State<LoginUserBorrowRequests> createState() => _LoginUserBorrowRequestsState(id);
}

class _LoginUserBorrowRequestsState extends State<LoginUserBorrowRequests> {
  String id;
  _LoginUserBorrowRequestsState(this.id);
  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    print(data.email);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Requests", style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.blueAccent,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ), onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context){
                      return MyDashboard(id: data.id.$oid);
                    },settings: RouteSettings(arguments: data)))
                    .then((value) => setState(() {}));
              },
              ),
              bottom: const TabBar(
                  tabs: [
                    Tab(icon: Text('Received', style: TextStyle(color: Colors.white, fontSize: 20),)),
                    Tab(icon: Text('Accepted', style: TextStyle(color: Colors.white, fontSize: 20),)),
                    Tab(icon: Text('Sent', style: TextStyle(color: Colors.white, fontSize: 20),)),
                  ]),
            ),
            body: TabBarView(
              children: [
                // Text('Received', style: TextStyle(color: Colors.black, fontSize: 20),),
                // Text('Sent', style: TextStyle(color: Colors.black, fontSize: 20),),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text("Pending Requests for your products", style: TextStyle(fontSize: 20),),
                          SizedBox(
                            height: 15,
                          ),
                          Text("*Note: Once a request is accepted it cannot be changed*", style: TextStyle(fontSize: 15, color: Colors.red),),
                        ],
                      ),
                    ),
                    Expanded(child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder(
                          future: mongoDatabase.getBorrowRequests(),
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
                                      return displayreceivedborrowCard(MongoDbBorrowRequests.fromJson(snapshot.data[index]), data); // Calling fuction passing data (from json) data into our model class
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
                    ),),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text("Request Accepted By you", style: TextStyle(fontSize: 20),),
                          SizedBox(
                            height: 15,
                          ),
                          Text("*Note: Once a request is accepted it cannot be changed*", style: TextStyle(fontSize: 15, color: Colors.red),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: FutureBuilder(
                            future: mongoDatabase.getBorrowRequests(),
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
                                        return displayacceptedCard(MongoDbBorrowRequests.fromJson(snapshot.data[index]), data); // Calling fuction passing data (from json) data into our model class
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
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Requests made by you", style: TextStyle(fontSize: 20),),
                    ),
                    DefaultTabController(
                        length: 2, // length of tabs
                        initialIndex: 0,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                          Container(
                            child: TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(text: 'Pending'),
                                Tab(text: 'Accepted'),
                              ],
                            ),
                          ),
                          Container(
                              height: 400, //height of TabBarView
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                              ),
                              child: TabBarView(children: <Widget>[
                                Container(
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FutureBuilder(
                                        future: mongoDatabase.getBorrowRequests(),
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
                                                    return displaysentpendingacceptedCard(MongoDbBorrowRequests.fromJson(snapshot.data[index]), data, "Pending"); // Calling fuction passing data (from json) data into our model class
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
                                ),
                                Container(
                                  child: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FutureBuilder(
                                        future: mongoDatabase.getBorrowRequests(),
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
                                                    return displaysentpendingacceptedCard(MongoDbBorrowRequests.fromJson(snapshot.data[index]), data, "Accepted"); // Calling fuction passing data (from json) data into our model class
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
                                ),
                              ])
                          )
                        ])
                    ),
                  ],
                ),

              ],
            )
        ),
      ),
    );
  }


  Widget displaysentpendingacceptedCard(MongoDbBorrowRequests data1, MongoDbModel data2, String show){
    if(data1.userid == data2.id.$oid) {
      if (show == "Pending") {
        if (data1.isaccepted == false) {
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SafeArea(
                            child: FutureBuilder(
                              future: mongoDatabase.getborrowproducts(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  var totaldata = snapshot.data.length;
                                  print("Total data: " + totaldata.toString());
                                  for (var i = 0; i < totaldata; i++) {
                                    if (MongoDbBorrow
                                        .fromJson(snapshot.data[i])
                                        .id
                                        .$oid == data1.productid) {
                                      return Column(
                                        children: [
                                          Text(MongoDbBorrow
                                              .fromJson(snapshot.data[i])
                                              .bookname, style:
                                          TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,),
                                            textAlign: TextAlign.left,),
                                        ],
                                      );
                                    }
                                  }
                                  return Container();
                                } else {
                                  return Center(
                                    child: Text("Loading..."),
                                  );
                                }
                              },
                            ), //Future builder to fetch data
                          ),
                          SizedBox(height: 5,),
                          Text(data1.authorname),
                        ],
                      ),
                      Column(
                        children: [
                          Text(data1.datetime),
                          Row(
                            children: [
                              IconButton(onPressed: () async {
                                await mongoDatabase.deleteborrowrequest(data1);
                                setState(() {

                                });
                              }, icon: Icon(
                                Icons.delete_forever, color: Colors.red,)),
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ViewBorrowRequest(isAccepted: false, id: id,);
                                        },
                                        settings: RouteSettings(
                                            arguments: data1)))
                                    .then((value) => setState(() {}));
                              }, icon: Icon(Icons.remove_red_eye_outlined,
                                color: Colors.black,)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        else {
          return Container(
          );
        }
      }
      else if (show == "Accepted") {
        if (data1.isaccepted == true) {
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                              child: FutureBuilder(
                                future: mongoDatabase.getborrowproducts(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var totaldata = snapshot.data.length;
                                    print("Total data: " + totaldata.toString());
                                    for (var i = 0; i < totaldata; i++) {
                                      if (MongoDbBorrow
                                          .fromJson(snapshot.data[i])
                                          .id
                                          .$oid == data1.productid) {
                                        return Column(
                                          children: [
                                            Text(MongoDbBorrow
                                                .fromJson(snapshot.data[i])
                                                .bookname, style:
                                            TextStyle(color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,),
                                              textAlign: TextAlign.left,),
                                          ],
                                        );
                                      }
                                    }
                                    return Container();
                                  } else {
                                    return Center(
                                      child: Text("Loading..."),
                                    );
                                  }
                                },
                              ), //Future builder to fetch data
                            ),
                            SizedBox(height: 5,),
                            Text(data1.authorname),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(data1.datetime),
                          Row(
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return ViewBorrowRequest(isAccepted: true, id: id,);
                                        },
                                        settings: RouteSettings(
                                            arguments: data1)))
                                    .then((value) => setState(() {}));
                              }, icon: Icon(Icons.remove_red_eye_outlined,
                                color: Colors.black,)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        else {
          return Container(
          );
        }
      }
      else{
        return Container(
        );
      }
    }
    else{
      return Container(
      );
    }
  }


  Widget displayreceivedborrowCard(MongoDbBorrowRequests data1, MongoDbModel data2){
    if(data1.isaccepted == false) {
      return Column(
        children: [
          SafeArea(
            child: FutureBuilder(
              future: mongoDatabase.getborrowproducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var totaldata = snapshot.data.length;
                  print("Total data: " + totaldata.toString());
                  for (var i = 0; i < totaldata; i++) {
                    print("productuser id: " + MongoDbBorrow
                        .fromJson(snapshot.data[i])
                        .userid);
                    print("user id: " + data2.id.$oid);
                    if (MongoDbBorrow
                        .fromJson(snapshot.data[i])
                        .id
                        .$oid == data1.productid) {
                      if (MongoDbBorrow
                          .fromJson(snapshot.data[i])
                          .userid == data2.id.$oid) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,
                                bottom: 5,
                                left: 10,
                                right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,

                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(data1.name, style:
                                    TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,),
                                      textAlign: TextAlign.left,),
                                    SizedBox(height: 5,),
                                    Text(data1.authorname),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(data1.datetime),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              await mongoDatabase
                                                  .deleteborrowrequest(
                                                  data1);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons
                                                .highlight_remove_outlined,
                                              color: Colors.red,)),
                                        IconButton(onPressed: () {
                                          _updateborrowProduct(MongoDbBorrow.fromJson(snapshot.data[i]), data1.userid);
                                          _acceptborrowRequest(data1,data2);


                                        },
                                            icon: Icon(Icons
                                                .check_circle_outline,
                                              color: Colors
                                                  .green,)),
                                        IconButton(onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) {
                                                    return ViewBorrowRequest(isAccepted: false, id: id,);
                                                  },
                                                  settings: RouteSettings(
                                                      arguments: data1)))
                                              .then((value) =>
                                              setState(() {}));
                                        },
                                            icon: Icon(Icons
                                                .remove_red_eye_outlined,
                                              color: Colors
                                                  .black,)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }
                  return Container();
                } else {
                  return Center(
                    child: Text("Loading..."),
                  );
                }
              },
            ), //Future builder to fetch data
          ),
        ],
      );
    }
    else{
      return Container(
      );
    }
  }


  Future<void> _updateborrowProduct(MongoDbBorrow data , String _userid) async {
    final update_product = MongoDbBorrow(id: data.id, image: data.image, userid: data.userid, bookname: data.bookname, bookwdition: data.bookwdition, authorname: data.authorname, condition: data.condition, maxnoofdays: data.maxnoofdays, description: data.description, extrainformation: data.extrainformation, datetime: data.datetime, isaccapted: true, buyerid: _userid);

    await mongoDatabase.updateborrowproduct(update_product);
  }



  Future<void> _acceptborrowRequest(MongoDbBorrowRequests data, MongoDbModel data1) async{

    final update_Request = MongoDbBorrowRequests(id: data.id, userid: data.userid, productid: data.productid, name: data.name, address: data.address, email: data.email, daterange: data.daterange, productname: data.productname, image: data.image, condition: data.condition, authorname: data.authorname, bookedition: data.bookedition, datetime: data.datetime, isaccepted: true, note: data.note, city: data.city);

    await mongoDatabase.acceptborrowrequest(update_Request).whenComplete(() => Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context){
          return LoginUserBorrowRequests(id: id,);
        },settings: RouteSettings(arguments: data1))));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Accepted ")));

  }

  Widget displayacceptedCard(MongoDbBorrowRequests data1, MongoDbModel data2){
    if(data1.isaccepted == true) {
      return Column(
        children: [
          SafeArea(
            child: FutureBuilder(
              future: mongoDatabase.getborrowproducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var totaldata = snapshot.data.length;
                  print("Total data: " + totaldata.toString());
                  for (var i = 0; i < totaldata; i++) {
                    print("productuser id: " + MongoDbBorrow
                        .fromJson(snapshot.data[i])
                        .userid);
                    print("user id: " + data2.id.$oid);
                    if (MongoDbBorrow
                        .fromJson(snapshot.data[i])
                        .id
                        .$oid == data1.productid) {
                      if (MongoDbBorrow
                          .fromJson(snapshot.data[i])
                          .userid == data2.id.$oid) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,
                                bottom: 5,
                                left: 10,
                                right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text(data1.name, style:
                                    TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,),
                                      textAlign: TextAlign.left,),
                                    SizedBox(height: 5,),
                                    Text(data1.authorname),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(data1.datetime),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) {
                                                    return ViewBorrowRequest(isAccepted: true, id: id,);
                                                  },
                                                  settings: RouteSettings(
                                                      arguments: data1)))
                                              .then((value) =>
                                              setState(() {}));
                                        },
                                            icon: Icon(Icons
                                                .remove_red_eye_outlined,
                                              color: Colors
                                                  .black,)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }
                  return Container();
                } else {
                  return Center(
                    child: Text("Loading..."),
                  );
                }
              },
            ), //Future builder to fetch data
          ),
        ],
      );
    }
    else{
      return Container(
      );
    }
  }
}

