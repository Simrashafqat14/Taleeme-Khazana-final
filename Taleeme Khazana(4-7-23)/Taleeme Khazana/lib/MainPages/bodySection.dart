import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MainPages/constants.dart';
/*import 'package:untitled1/models/Slider.dart';
import 'categories.dart';
import 'Seemore_Type.dart';*/
import 'package:fyp_project/MongoDBModels/producthome.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/Product/itemCard.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';
import 'package:fyp_project/ViewProducts/categoryProducts.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:fyp_project/ViewProducts/ViewPurchaseProductPage.dart';

import '../ViewProducts/categaryPage.dart';

class Body extends StatefulWidget {
  final String id, category;
  const Body({Key? key, required this.id, required this.category}) : super(key: key);


  @override
  State<Body> createState() => _BodyState(id, category);
}

class _BodyState extends State<Body> {
  String id, category;
  _BodyState(this.id, this.category);
  File? image;
  @override
  Widget build(BuildContext context) {
    print("bode: " + id);
    print(category);

    final double itemHeight = 80 / 2;
    final double itemWidth = 80 / 2;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(
              horizontal: kDefaultPaddin,vertical: kBoxsize),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    "FOR EXCHANGE",
                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700,fontFamily: 'Arvo',fontSize: 20),
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)
                      {
                        return categoryPage(id: id,type: "Exchange",);
                      }));
                }, child: FittedBox(
                  child: Text("See More",
                    style: TextStyle(fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Anto'),),
                )),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: mongoDatabase.getProductbycategory(category, "Exchange", false),
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
                      return SizedBox(
                        width: double.infinity,
                        height: 170,
                        child:
                        GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:1,
                              childAspectRatio: (1.2 / 1),
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              int reverselist = totaldata - 1 - index;
                              return displayCard(MongoDbProducts.fromJson(snapshot.data[reverselist])); // Calling fuction passing data (from json) data into our model class
                            }),
                      );
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

          Padding(padding: EdgeInsets.symmetric(
              horizontal: kDefaultPaddin,vertical: kBoxsize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    "FOR PURCHASE",
                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700,fontFamily: 'Arvo',fontSize: 20),
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)
                      {
                        return categoryPage(id: id,type: "Purchase",);
                      }));
                }, child: FittedBox(child:Text("See More",style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w500,fontFamily: 'Anto'),)),),
              ],
            ),),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: mongoDatabase.getpurchasableProductbycategory(category),
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
                      return SizedBox(
                        width: double.infinity,
                        height: 180,
                        child:
                        GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:1,
                              childAspectRatio: (1.2 / 1),
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              int reverselist = totaldata - 1 - index;
                              return displaypurchaseCard(MongoDbPurchasableProducts.fromJson(snapshot.data[reverselist])); // Calling fuction passing data (from json) data into our model class
                            }),
                      );
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




          Padding(padding: EdgeInsets.symmetric(
              horizontal: kDefaultPaddin,vertical: kBoxsize),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    "FOR DONATE",
                    style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700,fontFamily: 'Arvo',fontSize: 20),
                  ),
                ),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context)
                      {
                        return categoryPage(id: id,type: "Donate",);
                      }));
                }, child: FittedBox(child:Text("See More",style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w500,fontFamily: 'Anto'),)),),
              ],
            ),),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future: mongoDatabase.getProductbycategory(category,"Donate", false),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child:
                    CircularProgressIndicator(),
                    );
                  }
                  else {
                    if (snapshot.hasData) {

                      var totaldata = snapshot.data.length;
                      print("Total data: " + totaldata.toString());
                      return SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:1,
                              childAspectRatio: (1.2 / 1),
                            ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              if(MongoDbProducts.fromJson(snapshot.data[index]).productype == "Donate") {
                                int reverselist = totaldata - 1 - index;
                                return displayCard(MongoDbProducts.fromJson(snapshot.data[reverselist]));
                              }
                              else{
                                return Container(
                                  width: 0,
                                  height: 0,
                                );// Calling fuction passing data (from json) data into our model class
                              }
                            }),
                      );
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

          if(category == "Books")...[
            Padding(padding: EdgeInsets.symmetric(
                horizontal: kDefaultPaddin,vertical: kBoxsize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      "FOR BORROW",
                      style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w700,fontFamily: 'Arvo',fontSize: 20),
                    ),
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context)
                        {
                          return productsCategoryPage(id: id,type: "Borrow",category: "Books",);
                        }));
                  }, child: FittedBox(child:Text("See More",style: TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.w500,fontFamily: 'Anto'),)),),
                ],
              ),),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
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
                        return SizedBox(
                          width: double.infinity,
                          height: 150,
                          child:
                          GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:1,
                                childAspectRatio: (1.2 / 1),
                              ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                int reverselist = totaldata - 1 - index;
                                return displayborrowCard(MongoDbBorrow.fromJson(snapshot.data[reverselist])); // Calling fuction passing data (from json) data into our model class
                              }),
                        );
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
          ],


          Padding(padding: EdgeInsets.only(top:10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    FittedBox(child: Text('TALEEM-E-KHAZANA',style: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Arvo',fontSize: 10,color: Colors.blue),))]))
        ],
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



  //Exchange & Donate Card
  Widget displayCard(MongoDbProducts data) {

    Uint8List bytes = base64.decode(data.image);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
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
                    text: "${data.productname}".toUpperCase()),
                textAlign: TextAlign.left,
              ),
              if(data.productype == "Exchange")...[
                if(data.isgrouped == true)...[
                  Text("Bundle of " + data.productcategory,
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,),
                ]
                else...[
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

  //Purchase Card
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
                              image: DecorationImage(
                                  image: AssetImage('assets/linethrough.png'),
                                  fit: BoxFit.fitWidth),
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


