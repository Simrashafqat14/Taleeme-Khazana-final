import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/ViewProducts/ViewPurchaseProductPage.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

class Recommendationselectpage extends StatefulWidget {
  final String id;
  const Recommendationselectpage({Key? key, required this.id}) : super(key: key);

  @override
  State<Recommendationselectpage> createState() => _RecommendationselectpageState(id);
}

class _RecommendationselectpageState extends State<Recommendationselectpage> {

  String userid;
  _RecommendationselectpageState(this.userid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search here',),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CustomSearchDelegate(id: userid,);
                  }));
              // method to show the search bar
              // showSearch(
              //     context: context,
              //     // delegate to customize the search bar
              //     delegate: CustomSearchDelegate()
              //);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Product Recommendations",
                        style: TextStyle(color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,),textAlign: TextAlign.center,),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Note",
                          style: TextStyle(color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,),textAlign: TextAlign.center,),
                        Text("These recommendations are based on ratinga.\n (Rating >= 3.5)",
                          style: TextStyle(color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,),textAlign: TextAlign.center,),
                      ],
                    )
                  ],
                )
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: mongoDatabase.getReviews(),
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
                        return Column(
                          children: [
                            ListView.builder(
                                physics: ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  int temp = 0;
                                  for(int i = 0; i < index ; i++){
                                    if(Reviewmodel.fromJson(snapshot.data[index]).productid == Reviewmodel.fromJson(snapshot.data[i]).productid){
                                      temp++;
                                      print('temp: ' + temp.toString());

                                    }
                                  }
                                  return Column(
                                    children: [
                                       if(Reviewmodel.fromJson(snapshot.data[index]).rating >= 3.5)...[
                                         if(temp == 0)...[
                                           displaypurchaseCard(Reviewmodel.fromJson(snapshot.data[index]))
                                         ]
                                       ]
                                    ],
                                  );
                                }
                            ),
                          ],
                        );
                        // for(int i = 0; i < totaldata ; ){
                        //   int temp = i;
                        //   i++;
                        //   print('temp: ' + temp.toString());
                        //   print(Reviewmodel.fromJson(snapshot.data[temp]).productid);
                        //   return displaypurchaseCard(Reviewmodel.fromJson(snapshot.data[i]));
                        // }
                        // return Container();

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
        ),

    );
  }

  Widget displaypurchaseCard(Reviewmodel data) {
    print(data.productid);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            SafeArea(
              child: FutureBuilder(
                  future: mongoDatabase.getpurchasableProduct(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child:
                      CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        var totaldata = snapshot.data.length;
                        print("Total data: " + totaldata.toString());
                        for (var i = 0; i < totaldata; i++) {
                          if(MongoDbPurchasableProducts.fromJson(snapshot.data[i]).userid != userid){
                            if (data.productid == MongoDbPurchasableProducts
                                .fromJson(snapshot.data[i])
                                .id
                                .$oid) {
                              Uint8List bytes = base64.decode(
                                  MongoDbPurchasableProducts
                                      .fromJson(snapshot.data[i])
                                      .image);
                              return ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return PurchaseProductPage(
                                                id: userid,
                                                category: MongoDbPurchasableProducts
                                                    .fromJson(snapshot.data[i])
                                                    .productcategory,);
                                            },
                                            settings: RouteSettings(
                                                arguments: MongoDbPurchasableProducts
                                                    .fromJson(snapshot.data[i]))))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  contentPadding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 10, right: 10),
                                  leading: Column(
                                    children: [
                                      if(MongoDbPurchasableProducts
                                          .fromJson(snapshot.data[i])
                                          .image == "")...[
                                        Image(
                                          image: AssetImage(
                                              'assets/product_default.jpg'),
                                          width: 70,
                                          height: 55,
                                        ),
                                      ]
                                      else
                                        ...[
                                          MongoDbPurchasableProducts
                                              .fromJson(snapshot.data[i])
                                              .image != null ? Image.memory(
                                            bytes,
                                            width: 70,
                                            height: 55,
                                            fit: BoxFit.cover,
                                          ) : FlutterLogo(size: 70,),
                                        ],
                                    ],
                                  ),
                                  title: Text(MongoDbPurchasableProducts
                                      .fromJson(snapshot.data[i])
                                      .productname,
                                    style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('${MongoDbPurchasableProducts
                                      .fromJson(snapshot.data[i])
                                      .productcategory}',
                                    style: TextStyle(color: Colors.black38,),
                                  ),
                                  trailing: Column(
                                    children: [
                                      if(MongoDbPurchasableProducts
                                          .fromJson(snapshot.data[i])
                                          .onSale == true)...[
                                        Text('Onsale',
                                          style: TextStyle(color: Colors.black),),
                                      ]
                                      else
                                        ...[
                                          Text('Rs/-' + MongoDbPurchasableProducts
                                              .fromJson(snapshot.data[i])
                                              .productprice,
                                            style: TextStyle(
                                                color: Colors.black),),
                                        ]
                                    ],
                                  )

                                //leading: Image.network(display_list[index].movie_poster_url!),
                              );
                            }
                          }
                        }
                      }
                      return Container();
                    }
                  }
              ), //Future builder to fetch data
            ),
          ],
        ),
      ),
    );
  }
}
