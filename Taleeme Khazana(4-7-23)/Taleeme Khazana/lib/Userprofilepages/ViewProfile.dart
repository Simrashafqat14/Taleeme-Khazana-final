import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/dashboardpage.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';

import '../MongoDBModels/products.dart';
import '../ViewProducts/productPage.dart';

class ViewProfile extends StatefulWidget {
  final String id, userid;
  const ViewProfile({Key? key,required this.id, required this.userid}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState(id,userid);
}

class _ViewProfileState extends State<ViewProfile> {
  String id, userid;
  _ViewProfileState(this.id, this.userid);

  get data => null;

  @override
  Widget build(BuildContext context) {
    print(id);
    MongoDbModel data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbModel;
    print('email: ' + data.email);
    Uint8List bytes = base64.decode(data.userimage);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Profile'),

      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 18, bottom: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    data.userimage != "" ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.memory(
                        bytes!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(
                        height: 100,
                        width: 100,'assets/profile.jpg')),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: FutureBuilder(
                                              future: mongoDatabase.getProductbyuser(id, false),
                                              builder: (context, AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  int productcount = 0;
                                                  var totaldata = snapshot.data.length;
                                                  print("Total data: " + totaldata.toString());
                                                  for(int i = 0; i < totaldata;i++){
                                                    if(MongoDbProducts.fromJson(snapshot.data[i]).productype == 'Exchange') {
                                                      productcount++;
                                                    }
                                                  }
                                                  return Text(productcount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  );
                                                }
                                                else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ), //Future builder to fetch data
                                        ),
                                        Text('Exchange', style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blueAccent,
                                        ),),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: FutureBuilder(
                                              future: mongoDatabase.getProductbyuser(id, false),
                                              builder: (context, AsyncSnapshot snapshot) {
                                                if (snapshot.hasData) {
                                                  int productcount = 0;
                                                  var totaldata = snapshot.data.length;
                                                  print("Total data: " + totaldata.toString());
                                                  for(int i = 0; i < totaldata;i++){
                                                    if(MongoDbProducts.fromJson(snapshot.data[i]).productype == 'Donate') {
                                                      productcount++;
                                                    }
                                                  }
                                                  return Text(productcount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  );
                                                }
                                                else {
                                                  return Container();
                                                }
                                              },
                                            ),
                                          ), //Future builder to fetch data
                                        ),
                                        Text('Donate', style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blueAccent,
                                        ),),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FutureBuilder(
                                          future: mongoDatabase.getborrowProductbyuser(id,false),
                                          builder: (context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              int productcount = 0;
                                              var totaldata = snapshot.data.length;
                                              print("Total data: " + totaldata.toString());
                                              for(int i = 0; i < totaldata;i++){
                                                  productcount++;
                                              }
                                              return Text(productcount.toString(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blueAccent,
                                                ),
                                              );
                                            }
                                            else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ), //Future builder to fetch data
                                    ),
                                    Text('Borrow', style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueAccent,
                                    ),),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Padding(padding: const EdgeInsets.only(left: 10, top: 10),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.fullname.toUpperCase(),
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0.4,)),
                        SizedBox(
                          height: 4,
                        ),
                        Text(data.address + ' ' + data.city,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0.4,)),
                        Text(data.country,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0.4,)),
                        SizedBox(
                          height: 4,
                        ),
                      ]),
                ),
                Column(
                  children: [
                    Text('Products', style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0.4,)
                    ),
                    Column(
                      children: [
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                FutureBuilder(
                                  future: mongoDatabase.getProductbyuser(id, false),
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
                                        return GridView.builder(

                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,

                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 2.0,
                                              mainAxisSpacing: 2.0,
                                              childAspectRatio: (1 / 1.2),
                                            ),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return displayCard(
                                                  MongoDbProducts.fromJson(snapshot
                                                      .data[index])); // Calling fuction passing data (from json) data into our model class
                                            });
                                      } else {
                                        return Center(
                                          child: Text("No Data Available."),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ), //Future builder to fetch data
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                FutureBuilder(
                                  future: mongoDatabase.getborrowProductbyuser(id,false),
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
                                        return GridView.builder(

                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,

                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 2.0,
                                              mainAxisSpacing: 2.0,
                                              childAspectRatio: (1 / 1.2),
                                            ),
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              return displayborrowCard(
                                                  MongoDbBorrow.fromJson(snapshot
                                                      .data[index])); // Calling fuction passing data (from json) data into our model class
                                            });
                                      } else {
                                        return Center(
                                          child: Text("No Data Available."),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ), //Future builder to fetch data
                        ),
                      ],
                    ),
                  ],
                )
              ]
          ),
        ),
      ),),
    );
  }

  Widget displayborrowCard(MongoDbBorrow data) {

    Uint8List bytes = base64.decode(data.image);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return ViewBorrowProduct(id: userid);
                }, settings: RouteSettings(arguments: data)))
                .then((value) {setState(() {});
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Text("${data.image}"),
              if(data.image == "")...[
                Image(
                  image: AssetImage(
                      'assets/product_default.jpg'),width: 100,height: 80,
                ),
              ]
              else...[
                data.image != null ? Image.memory(
                  bytes,
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ) : FlutterLogo(size: 70, ),
              ],
              //Image.memory(bytes),
              //Image.network(data.image),
              SizedBox(
                height: 10,
              ),
              RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    text: "${data.bookname}".toUpperCase()),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget displayCard(MongoDbProducts data) {
    Uint8List bytes = base64.decode(data.image);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return ViewProductPage(id: userid,type: data.productype, category: data.productcategory,);
                }, settings: RouteSettings(arguments: data)))
                .then((value) {setState(() {});
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text("${data.image}"),
              if(data.image == "")...[
                Image(
                  image: AssetImage(
                      'assets/product_default.jpg'), width: 200, height: 100,
                ),
              ]
              else
                ...[
                  data.image != null ? Image.memory(
                    bytes,
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  ) : FlutterLogo(size: 70,),
                ],
              //Image.network(data.image),
              SizedBox(
                height: 10,
              ),
              RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    text: "${data.productname}".toUpperCase()),
                textAlign: TextAlign.left,
              ),
              if(data.productype == "Exchange")...[
                if(data.isgrouped == true)...[
                  Text("Bundle of " + data.productcategory,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,),
                ]
                else
                  ...[
                    Text("Single Product",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,),
                  ]
              ],
            ],
          ),
        ),
      ),
    );
  }
}

