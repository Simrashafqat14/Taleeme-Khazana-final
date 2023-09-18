import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/PurchaseModule/ViewPurchaseProduct.dart';
import 'package:fyp_project/PurchaseModule/updatepurchaseproduct.dart';
import 'package:fyp_project/UploadProduct/borrow/updateborrowproduct.dart';
import 'package:fyp_project/UploadProduct/borrow/viewborrowproduct.dart';
import 'package:fyp_project/UploadProduct/updateproduct.dart';
import 'package:fyp_project/UploadProduct/viewproduct.dart';
import 'package:fyp_project/MainPages/serachPage.dart';

class ProductHistory extends StatefulWidget {
  final String id, category,type;
  const ProductHistory({Key? key, required this.id, required this.category, required this.type}) : super(key: key);

  @override
  State<ProductHistory> createState() => _ProductHistoryState(id, category, type);
}

class _ProductHistoryState extends State<ProductHistory> {
  String id, category, type;
  _ProductHistoryState(this.id, this.category, this.type);
  
  @override
  Widget build(BuildContext context) {
    print(id);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(category, style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 30,), textAlign: TextAlign.center,),
              if(type == "Purchase")...[
                Expanded(
                  child: FutureBuilder(
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
                          return SizedBox(
                            height: 575,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index){
                                  print(snapshot.data[index]);
                                  return displaypurchaseCard(MongoDbPurchasableProducts.fromJson(snapshot.data[index])); // Calling fuction passing data (from json) data into our model class
                                }),
                          );
                        }else{
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
              if(type == "Borrow")...[
                Expanded(
                  child: FutureBuilder(
                    future: mongoDatabase.getborrowproducts(),
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
                                return displayborrowCard(MongoDbBorrow.fromJson(snapshot.data[index])); // Calling fuction passing data (from json) data into our model class
                              });
                        }else{
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    },
                  ),
                ),
              ]
              else...[
              Expanded(
                child: FutureBuilder(
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
                        print(category);
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              print(snapshot.data[index]);
                              return displayCard(MongoDbProducts.fromJson(snapshot.data[index])); // Calling fuction passing data (from json) data into our model class
                            });
                      }else{
                        return Center(
                          child: Text("No Data Available."),
                        );
                      }
                    }
                  },
                ),
              ),
              ]
            ],
          ),
        ), //Future builder to fetch data
      ),
    );
  }

  Widget displayborrowCard(MongoDbBorrow data){
    if(data.userid == id) {
      print(category);
      print(type);
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
                            Text("${data.bookname}"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(" ${data.condition}"),
                            SizedBox(
                              height: 5,
                            ),
                            Text("${data.authorname}"),

                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text("${data.datetime}",textAlign: TextAlign.right,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return updateBorrowProducts(type: type, category: category);
                                    },settings: RouteSettings(arguments: data)))
                                    .then((value) {setState(() {});}); // setstate to update list of data
                                print(category);
                              }, icon: Icon(Icons.edit)),
                              IconButton(onPressed: () async {
                                await mongoDatabase.deleteborrowproduct(data);
                                setState(() {

                                });
                              }, icon: Icon(Icons.delete)),
                              IconButton(onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context){
                                      return viewborrowproductdata();
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


  Widget displayCard(MongoDbProducts data){
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


  Widget displaypurchaseCard(MongoDbPurchasableProducts data){
    if(data.userid == id) {
      print(category);
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
