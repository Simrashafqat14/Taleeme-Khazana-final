import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/PersonalProfile.dart';
import 'package:fyp_project/Userprofilepages/userproductedit.dart';
import 'package:fyp_project/ViewProducts/ViewPurchaseProductPage.dart';

class personalShopPage extends StatefulWidget {
  final String id;
  final MongoDbModel userdata;
  const personalShopPage({Key? key, required this.id, required this.userdata}) : super(key: key);

  @override
  State<personalShopPage> createState() => _personalShopPageState(id, userdata);
}

class _personalShopPageState extends State<personalShopPage> {
  String id;
  MongoDbModel userdata;
  _personalShopPageState(this.id, this.userdata);
  @override
  Widget build(BuildContext context) {
    MongoDbShop data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbShop;
    print(id);
    print(data.shopname);
    Uint8List bytes = base64.decode(data.image);

    return Scaffold(
      appBar: AppBar(
        title: Text('View Your Shop'),
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      SizedBox(width: 40,),
                      Expanded(child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child:
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: FutureBuilder(
                                            future: mongoDatabase
                                                .getpurchaseProductbyuser(
                                                data.userid),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                var totaldata = snapshot.data
                                                    .length;
                                                print("Total data: " +
                                                    totaldata.toString());
                                                return Text(totaldata.toString(),
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
                                      Text('Products', style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueAccent,
                                      ),),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: FutureBuilder(
                                            future: mongoDatabase
                                                .getpurchaseProductbyuser(
                                                data.userid),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.hasData) {
                                                int productcount = 0;
                                                var totaldata = snapshot.data
                                                    .length;
                                                print("Total data: " +
                                                    totaldata.toString());
                                                for (int i = 0; i <
                                                    totaldata; i++) {
                                                  if (MongoDbPurchasableProducts
                                                      .fromJson(snapshot.data[i])
                                                      .onSale == true) {
                                                    productcount++;
                                                  }
                                                }
                                                return Text(
                                                  productcount.toString(),
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
                                      Text('On Sale', style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueAccent,
                                      ),),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                          Column(
                              children: <Widget>[
                                ElevatedButton(onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return ViewPersonalProfile(id: id);
                                      }, settings: RouteSettings(arguments: userdata)))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                    child: Text('Your Profile'))
                              ]
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                              children: [
                                Text(data.shopname.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      letterSpacing: 0.4,)),
                                Row(
                                  children: [
                                    Text("userName    ",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          letterSpacing: 0.4,)),
                                    Text(userdata.userName,
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          letterSpacing: 0.4,
                                        )
                                    ),
                                  ],
                                ),
                              ]
                          ),
                        ),
                      ]
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
                                      return userprofileproducteditpage(id: id, type: 'Purchase',);
                                    },settings: RouteSettings(arguments: userdata))).then((value) => setState(() {}));
                              }, child: Text('Purchase Products')),
                            ]),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Text('PRODUCTS',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 0.4,)),
                  Divider(),
                  DefaultTabController(
                      length: 2, // length of tabs
                      initialIndex: 0,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                        Container(
                          child: TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(text: 'Products'),
                              Tab(text: 'Onsale'),
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
                                  child: getDatebytype(false)
                                ),
                              ),
                              SingleChildScrollView(
                                child: Container(
                                  child: getDatebytype(true)
                                ),
                              ),
                            ])
                        )
                      ])
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget getDatebytype(bool onsale){
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder(
              future: mongoDatabase.getpurchaseProductbyuserandonsale(id, onsale),
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
                          return displaypurchaseCard(
                              MongoDbPurchasableProducts.fromJson(snapshot
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
    );
  }

  Widget displaypurchaseCard(MongoDbPurchasableProducts data) {
    Uint8List bytes = base64.decode(data.image);
    //File? img = data.image.toString() as File?;
    //image = data.image;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return PurchaseProductPage(id: id, category: data.productcategory,);
                }, settings: RouteSettings(arguments: data)))
                .then((value) {setState(() {});
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
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
                        ],
                      )
                  ),
                  if(data.onSale == true)...[
                    Container(
                        height: 25,
                        width: 40,
                        alignment: Alignment.center,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.only(top: 3),//<-- SEE HERE
                            ),
                            onPressed: (){},
                            child: Column(
                              children: [
                                Text('Sale',style: TextStyle(color: Colors.white),)
                              ],
                            )
                        )
                    ),
                  ]
                ],
              ),
              //Text("${data.image}"),

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
                    text: "${data.productname}".toUpperCase()),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data.productcategory,
                    style: TextStyle(color: Colors.black),),
                  if(data.onSale == true)...[
                    Column(

                      children: [
                        Center(
                          child: Container(
                            child: Text('Rs/-'+data.productprice,
                              style: TextStyle(color: Colors.black),),
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/linethrough.png'), fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                        Text('Rs/-'+data.saleprice,
                          style: TextStyle(color: Colors.black),),
                      ],
                    )
                  ]
                  else...[
                    Text('Rs/-'+data.productprice,
                      style: TextStyle(color: Colors.black),),
                  ]

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
