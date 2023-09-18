import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/dashboardpage.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/userproductedit.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';

import '../MongoDBModels/products.dart';
import '../UploadProduct/userProductHistoryCategories.dart';
import '../ViewProducts/productPage.dart';

class ViewPersonalProfile extends StatefulWidget {
  final String id;
  const ViewPersonalProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewPersonalProfile> createState() => _ViewPersonalProfileState(this.id);
}

class _ViewPersonalProfileState extends State<ViewPersonalProfile> {
  final String id;

  _ViewPersonalProfileState(this.id);

  get data => null;


  @override
  Widget build(BuildContext context) {
    MongoDbModel userdata = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbModel;
    print(userdata.userName);
    Uint8List bytes = base64.decode(userdata.userimage);

    print(id);
    return Scaffold(
        appBar: AppBar(
          title: Text(userdata.fullname,style: TextStyle(fontWeight: FontWeight.bold),),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ), onPressed: () {

            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyDashboard(id: id);
                },settings: RouteSettings(arguments: userdata))).then((value) => setState(() {}));
          },
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 18, bottom: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Column(
                      children: [
                        Row(
                          children: [
                            userdata.userimage != "" ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.memory(
                                bytes!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(height: 100,
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
                                                  return  Container();
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
                                      return  Container();
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
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(padding: EdgeInsets.only(left: 0),
                      child:
                      Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("      "+userdata.fullname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 0.4,), textAlign: TextAlign.left,),
                            SizedBox(
                              height: 4,
                            ),
                            // Text(userdata.address + ' ' + userdata.city,
                            //     style: TextStyle(
                            //       color: Colors.blueAccent,
                            //       fontWeight: FontWeight.w700,
                            //       fontSize: 20,
                            //       letterSpacing: 0.4,)),
                            Text(userdata.nickname,
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 0.4,), textAlign: TextAlign.left,),
                            SizedBox(
                              height: 4,
                            ),
                            Text(userdata.country,
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
                    Divider(),
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 50),
                      child: Text(
                        'Do you want to edit your post?', style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.blueAccent),

                      ),),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              children: [
                                ElevatedButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return userprofileproducteditpage(id: id, type: 'Exchange',);
                                      },settings: RouteSettings(arguments: userdata))).then((value) => setState(() {}));
                                }, child: Text('Exchange Products')),
                                SizedBox(width: 10,),
                                ElevatedButton(onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return userprofileproducteditpage(id: id, type: 'Donate',);
                                      },settings: RouteSettings(arguments: userdata))).then((value) => setState(() {}));
                                },
                                  child: Text('Donate Products'),
                                  // SizedBox(width: 10,),
                                  // ElevatedButton(onPressed: (){}, child:Text('Purchase')),
                                  // SizedBox(width: 10,),
                                  // ElevatedButton(onPressed: (){}, child:Text('Borrow')),
                                ),
                              ]),
                        ]),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('PRODUCTS POST',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.4,)),
                    Divider(),
                    DefaultTabController(
                        length: 3, // length of tabs
                        initialIndex: 0,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                          Container(
                            child: TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(text: 'Exchange'),
                                Tab(text: 'Donate'),
                                Tab(text: 'Borrow'),
                              ],
                            ),
                          ),
                          Container(
                              height: 400, //height of TabBarView
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                              ),
                              child: TabBarView(children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                     child: getDatebytype('Exchange'),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Container(
                                      child: getDatebytype('Donate'),
                                  ),
                                ),

                                SingleChildScrollView(
                                  child: Container(
                                    child: getDatebytype('Borrow'),
                                  ),
                                ),
                              ])
                          )
                        ])
                    ),
                  ],
                ),
            ),
          ),
        )
    );
  }
  Widget getDatebytype(String type){
     if(type == "Borrow"){
       return SafeArea(
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
                                     .data[index]));
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
       );
     }
     else{
       return SafeArea(
         child: Padding(
           padding: const EdgeInsets.all(10.0),
           child: Column(
             children: [
               FutureBuilder(
                 future: mongoDatabase.getProductbyuserandtype(id, type, false),
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
                                     .data[index]));
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
       );
     }
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
                  return ViewBorrowProduct(id: id);
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
                  return ViewProductPage(id: id,type: data.productype, category: data.productcategory,);
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



