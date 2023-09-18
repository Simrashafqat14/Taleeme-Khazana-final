import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/PurchaseModule/ViewPurchaseProduct.dart';
import 'package:fyp_project/PurchaseModule/updatepurchaseproduct.dart';
import 'package:fyp_project/UploadProduct/updateproduct.dart';
import 'package:fyp_project/UploadProduct/viewproduct.dart';

class userprofileproducteditpage extends StatefulWidget {
  final String id, type;
  const userprofileproducteditpage({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  State<userprofileproducteditpage> createState() => _userprofileproducteditpageState(id, type);
}

class _userprofileproducteditpageState extends State<userprofileproducteditpage> {
  String id, type;
  _userprofileproducteditpageState(this.id, this.type);
  @override
  Widget build(BuildContext context) {
    MongoDbModel userdata = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: DefaultTabController(
          length: 5, // length of tabs
          initialIndex: 0,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            Container(
              child: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                isScrollable: true,
                labelPadding: EdgeInsets.symmetric(horizontal: 30),
                tabs: [
                  Tab(text: 'Books'),
                  Tab(text: 'Uniforms'),
                  Tab(text: 'Bags'),
                  Tab(text: 'Shoes'),
                  Tab(text: 'Stationary'),
                ],
              ),
            ),
            Container(
                height: 550, //height of TabBarView
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
                ),
                child: TabBarView(children: <Widget>[
                  if(type == "Purchase")...[
                    Container(
                      child: getpurchaseDatebycategory('Books'),
                    ),
                    Container(
                      child: getpurchaseDatebycategory('Uniforms'),
                    ),
                    Container(
                      child: getpurchaseDatebycategory('Bags'),
                    ),
                    Container(
                      child: getpurchaseDatebycategory('Shoes'),
                    ),
                    Container(
                      child: getpurchaseDatebycategory('Stationary'),
                    ),
                  ]
                  else...[
                    Container(
                      child: getDatebycategory('Books', type),
                    ),
                    Container(
                      child: getDatebycategory('Uniforms', type),
                    ),
                    Container(
                      child: getDatebycategory('Bags', type),
                    ),
                    Container(
                      child: getDatebycategory('Shoes', type),
                    ),
                    Container(
                      child: getDatebycategory('Stationary', type),
                    ),
                  ]
                ])
            )
          ])
      ),
    );
  }
  Widget getDatebycategory(String category, String type) {
    return FutureBuilder(
        future: mongoDatabase.getProducts(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Center(child:
            CircularProgressIndicator(),
            );
          } else{
            if(snapshot.hasData){
              var totaldata = snapshot.data.length;
              print("Total data: " + totaldata.toString());
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    print(snapshot.data[index]);
                    return displayCard(MongoDbProducts.fromJson(snapshot.data[index]), category,type); // Calling fuction passing data (from json) data into our model class
                  });
            }else{
              return Center(
                child: Text("No Data Available."),
              );
            }
          }
        },
      );
  }

  Widget getpurchaseDatebycategory(String category) {
    return FutureBuilder(
      future: mongoDatabase.getpurchasableProduct(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.connectionState== ConnectionState.waiting){
          return Center(child:
          CircularProgressIndicator(),
          );
        } else{
          if(snapshot.hasData){
            var totaldata = snapshot.data.length;
            print("Total data: " + totaldata.toString());
            print(category);
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  print(snapshot.data[index]);
                  return displaypurchaseCard(MongoDbPurchasableProducts.fromJson(snapshot.data[index]), category); // Calling fuction passing data (from json) data into our model class
                });
          }else{
            return Center(
              child: Text("No Data Available."),
            );
          }
        }
      },
    );
  }

  Widget displayCard(MongoDbProducts data, String category, String type){
    if(data.userid == id) {
      print(category);
      print(data.productcategory);
      print(type);
      if(data.productcategory == category){
        if(data.productype == type){
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${data.productname}"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(" ${data.productcondition}"),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${data.productcategory}"),

                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text("${data.dateTime}",textAlign: TextAlign.right,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return productUpdatePage(type: type, category: category);
                                    },settings: RouteSettings(arguments: data)))
                                    .then((value) {setState(() {});}); // setstate to update list of data
                                print(category);
                              }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: () async {
                                await mongoDatabase.deleteProduct(data);
                                setState(() {

                                });
                              }, icon: Icon(Icons.delete)),
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return productViewPage(category: category, type: type);
                                    },settings: RouteSettings(arguments: data)))
                                    .then((value) {setState(() {});});
                              }, icon: Icon(Icons.remove_red_eye_outlined))
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
    else{
      return Container(
      );
    }
  }

  Widget displaypurchaseCard(MongoDbPurchasableProducts data, String category){
    if(data.userid == id) {
      print(data.productcategory);
      print(type);
      if(data.productcategory == category){
        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${data.productname}"),
                          SizedBox(
                            height: 5,
                          ),
                          if(data.onSale == true)...[
                            Row(
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
                                SizedBox(width: 30,),
                                Text('Rs/-'+data.saleprice,
                                  style: TextStyle(color: Colors.black),),
                              ],
                            )
                          ]
                          else...[
                            Text('Rs/-'+data.productprice,
                              style: TextStyle(color: Colors.black),),
                          ],
                          SizedBox(
                            height: 5,
                          ),
                          Text("${data.productcategory}"),

                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text("${data.dateTime}",textAlign: TextAlign.right,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () {
                              print(category);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context){
                                    return purchaseproductUpdatePage(category: category, type: type);
                                  },settings: RouteSettings(arguments: data)))
                                  .then((value) {setState(() {});});
                            }, icon: Icon(Icons.edit)),
                            IconButton(onPressed: () async {
                              await mongoDatabase.deletepurchaseProduct(data);
                              setState(() {

                              });
                            }, icon: Icon(Icons.delete)),
                            IconButton(onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context){
                                    return purchaseproductViewPage(category: category, type: type);
                                  },settings: RouteSettings(arguments: data)))
                                  .then((value) {setState(() {});});
                            }, icon: Icon(Icons.remove_red_eye_outlined))
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
}
