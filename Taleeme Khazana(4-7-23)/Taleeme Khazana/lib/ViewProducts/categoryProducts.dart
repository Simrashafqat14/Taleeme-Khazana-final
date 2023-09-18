import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Product/upload_product.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/ViewProducts/ViewPurchaseProductPage.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:fyp_project/MainPages/categorySection.dart';

import 'package:fyp_project/MainPages/serachPage.dart';


class productsCategoryPage extends StatefulWidget {
  final String id,category, type;
  const productsCategoryPage({Key? key, required this.id,required this.category, required this.type}) : super(key: key);

  @override
  State<productsCategoryPage> createState() => _productsCategoryPageState(id,category,type);
}

class _productsCategoryPageState extends State<productsCategoryPage> {
  String id,category,type;
  _productsCategoryPageState(this.id, this.category,this.type);

  File? image;
  @override
  Widget build(BuildContext context) {
    print(id + " " + type + " " + category);
    /*24 is for notification bar on Android*/
    final double itemHeight = 60 / 2;
    final double itemWidth = 50 / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search here',),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CustomSearchDelegate(id: id,);
                  }));
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
            child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(category.toUpperCase(),
                              style: TextStyle(color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arvo',
                                fontSize: 25,)),
                          SizedBox(
                            width: 05,
                          ),
                        ],
                      )
                  ),
                  if(type == "Purchase")...[
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: mongoDatabase.getpurchasableProductbycategory(
                                  category),
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
                                          childAspectRatio: (1 / 1),
                                        ),
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return displaypurchaseCard(
                                              MongoDbPurchasableProducts.fromJson(snapshot
                                                  .data[index])); // Calling fuction passing data (from json) data into our model class
                                        }
                                        );
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
                  if(type == "Borrow")...[
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            FutureBuilder(
                              future: mongoDatabase.getborrowProductbystatus(false),
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
                                          childAspectRatio: (1 / 1),
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
                  ]
                  else...[
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: mongoDatabase.getProductbycategory(
                                category, type, false),
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
                                        childAspectRatio: (1 / 1),
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
                  ]
                ]
            )
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
                  return ViewProductPage(
                    id: id, type: type, category: category,);
                }, settings: RouteSettings(arguments: data)))
                .then((value) {
              setState(() {});
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
                                  'assets/product_default.jpg'),width: 200,height: 100,
                            ),
                          ]
                          else...[
                            data.image != null ? Image.memory(
                              bytes,
                              width: 200,
                              height: 100,
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

                  if(data.onSale == true)...[
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ],
            ],
          ),
        ),
      ),
    );
  }
}


