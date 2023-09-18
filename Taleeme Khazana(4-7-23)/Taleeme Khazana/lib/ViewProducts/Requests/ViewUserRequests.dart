import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Requests/Viewrequest.dart';

class LoginUserRequests extends StatefulWidget {
  final String id;
  const LoginUserRequests({Key? key, required this.id}) : super(key: key);

  @override
  State<LoginUserRequests> createState() => _LoginUserRequestsState(id);
}

class _LoginUserRequestsState extends State<LoginUserRequests> {
  String id;
  _LoginUserRequestsState(this.id);
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
                  Expanded(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder(
                          future: mongoDatabase.getRequests(),
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
                                      return displayreceivedCard(Requests.fromJson(snapshot.data[index]), data); // Calling fuction passing data (from json) data into our model class
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
                          future: mongoDatabase.getRequests(),
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
                                      return displayacceptedCard(Requests.fromJson(snapshot.data[index]), data); // Calling fuction passing data (from json) data into our model class
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
                                      future: mongoDatabase.getRequests(),
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
                                                  return displaysentpendingacceptedCard(Requests.fromJson(snapshot.data[index]), data, "Pending"); // Calling fuction passing data (from json) data into our model class
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
                                      future: mongoDatabase.getRequests(),
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
                                                  return displaysentpendingacceptedCard(Requests.fromJson(snapshot.data[index]), data, "Accepted"); // Calling fuction passing data (from json) data into our model class
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
  Widget displaysentpendingacceptedCard(Requests data1, MongoDbModel data2, String show){
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
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                              child: FutureBuilder(
                                future: mongoDatabase.getProducts(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var totaldata = snapshot.data.length;
                                    print("Total data: " + totaldata.toString());
                                    for (var i = 0; i < totaldata; i++) {
                                      if (MongoDbProducts
                                          .fromJson(snapshot.data[i])
                                          .id
                                          .$oid == data1.productid) {
                                        return Column(
                                          children: [
                                            Text(MongoDbProducts
                                                .fromJson(snapshot.data[i])
                                                .productname, style:
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
                            Text(data1.requestype),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(data1.date + " " + data1.time),
                          Row(
                            children: [
                              IconButton(onPressed: () async {
                                await mongoDatabase.deleterequest(data1);
                                setState(() {

                                });
                              }, icon: Icon(
                                Icons.delete_forever, color: Colors.red,)),
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return viewRequestPage(isAccepted: false, id: id,);
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
                                future: mongoDatabase.getProducts(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    var totaldata = snapshot.data.length;
                                    print("Total data: " + totaldata.toString());
                                    for (var i = 0; i < totaldata; i++) {
                                      if (MongoDbProducts
                                          .fromJson(snapshot.data[i])
                                          .id
                                          .$oid == data1.productid) {
                                        return Column(
                                          children: [
                                            Text(MongoDbProducts
                                                .fromJson(snapshot.data[i])
                                                .productname, style:
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
                            Text(data1.requestype),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(data1.date + " " + data1.time),
                          Row(
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return viewRequestPage(isAccepted: true, id: id,);
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

  Widget displayreceivedCard(Requests data1, MongoDbModel data2){
    if(data1.isaccepted == false) {
      return Column(
        children: [
          SafeArea(
            child: FutureBuilder(
              future: mongoDatabase.getProducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var totaldata = snapshot.data.length;
                  print("Total data: " + totaldata.toString());
                  for (var i = 0; i < totaldata; i++) {
                    print("productuser id: " + MongoDbProducts
                        .fromJson(snapshot.data[i])
                        .userid);
                    print("user id: " + data2.id.$oid);
                    if (MongoDbProducts
                        .fromJson(snapshot.data[i])
                        .id
                        .$oid == data1.productid) {
                      if (MongoDbProducts
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
                                    Text(data1.requestype),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(data1.date + " " +
                                        data1.time),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              await mongoDatabase
                                                  .deleterequest(
                                                  data1);
                                              setState(() {});
                                            },
                                            icon: Icon(Icons
                                                .highlight_remove_outlined,
                                              color: Colors.red,)),
                                        IconButton(onPressed: () {
                                          _updateProduct(MongoDbProducts.fromJson(snapshot.data[i]), data1.userid);
                                            _acceptRequest(data1,data2);

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
                                                    return viewRequestPage(isAccepted: false, id: id,);
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



  Future<void> _updateProduct(MongoDbProducts data , String _userid) async {
    final update_product = MongoDbProducts(id: data.id, userid: data.userid, productcategory: data.productcategory, productype: data.productype, image: data.image,
        productname: data.productname, productdescription: data.productdescription, productcondition: data.productcondition, authorname: data.authorname,
        booksubject: data.booksubject, noofpages: data.noofpages, uniformSize: data.uniformSize, schoolname: data.schoolname, shoesSize: data.shoesSize,
        shoesstyle: data.shoesstyle, bagtype: data.bagtype, stationaryname: data.stationaryname, noofitemsstationary: data.noofitemsstationary,
        grade: data.grade, gender: data.gender, color: data.color, extrainformation: data.extrainformation,
        exchangereason: data.exchangereason, exchangesource: data.exchangesource, requiredamountorproduct: data.requiredamountorproduct, dateTime: data.dateTime
        , isgrouped: data.isgrouped, quantityofGroupedProducts: data.quantityofGroupedProducts, isaccapted: true, buyerid: _userid);

    await mongoDatabase.updateProduct(update_product);
  }


  Future<void> _acceptRequest(Requests data, MongoDbModel data1) async{

    final update_Request = Requests(id: data.id, userid: data.userid, productid: data.productid, date: data.date, time: data.time, requestype: data.requestype, name: data.name, email: data.email, address: data.address, city: data.city, reason: data.reasonexchnage, reasonexchnage: data.reasonexchnage, exchnageamountorproduct: data.exchnageamountorproduct, exchangecondition: data.exchangecondition, note: data.note, isaccepted: true, image: data.image);

    await mongoDatabase.acceptrequest(update_Request).whenComplete(() => Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context){
          return LoginUserRequests(id: id,);
        },settings: RouteSettings(arguments: data1))));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Accepted ")));

  }

  Widget displayacceptedCard(Requests data1, MongoDbModel data2){
    if(data1.isaccepted == true) {
      return Column(
        children: [
          SafeArea(
            child: FutureBuilder(
              future: mongoDatabase.getProducts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var totaldata = snapshot.data.length;
                  print("Total data: " + totaldata.toString());
                  for (var i = 0; i < totaldata; i++) {
                    print("productuser id: " + MongoDbProducts
                        .fromJson(snapshot.data[i])
                        .userid);
                    print("user id: " + data2.id.$oid);
                    if (MongoDbProducts
                        .fromJson(snapshot.data[i])
                        .id
                        .$oid == data1.productid) {
                      if (MongoDbProducts
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
                                    Text(data1.requestype),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(data1.date + " " +
                                        data1.time),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) {
                                                    return viewRequestPage(isAccepted: true, id: id,);
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

