import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/OrdersRequestsTaken.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/ViewProfile.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';

class viewRequestPage extends StatefulWidget {
  final bool isAccepted;
  final String id;
  const viewRequestPage({Key? key, required this.isAccepted, required this.id}) : super(key: key);

  @override
  State<viewRequestPage> createState() => _viewRequestPageState(isAccepted, id);
}

class _viewRequestPageState extends State<viewRequestPage> {
  bool isAccepted;
  String id;
  _viewRequestPageState(this.isAccepted, this.id);
  @override
  Widget build(BuildContext context) {
    print(isAccepted);
  Requests data = ModalRoute.of(context)!.settings.arguments as Requests;

    Uint8List bytes = base64.decode(data.image);

    return Scaffold(
      appBar: AppBar(
        title: Text("view Request", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Date: ',style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: 15,), textAlign: TextAlign.left,),
                          Text(data.date,style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: 15,), textAlign: TextAlign.left,),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Time: ',style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: 15,), textAlign: TextAlign.left,),
                          Text(data.time,style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                            fontSize: 15,), textAlign: TextAlign.left,),
                        ],
                      ),
                    ],
                  ),
                  if(isAccepted == true)...[
                    Container(),
                  ]
                  else...[
                    IconButton(onPressed: () {

                    }, icon: Icon(Icons.delete_forever, color: Colors.red,)),
                  ]
                ],
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Request By:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.name,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Email:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.email,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Address:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.address,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('City:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.city,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Request Type:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.requestype,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Reason:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.reason,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              if(data.note == "")...[
                Container(),
              ]
              else...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Note:   ',style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: 18,), textAlign: TextAlign.left,),
                        Expanded(
                          child: Text(data.note,style:
                          TextStyle(color: Colors.black,
                            fontSize: 15,), textAlign: TextAlign.left,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if(data.requestype == "Exchange")...[

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Reason For Exchange:   ',style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: 18,), textAlign: TextAlign.left,),
                        Expanded(
                          child: Text(data.reasonexchnage,style:
                          TextStyle(color: Colors.black,
                            fontSize: 15,), textAlign: TextAlign.left,),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('Exchange Ammount/Product:   ',style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: 18,), textAlign: TextAlign.left,),
                        Expanded(
                          child: Text(data.exchnageamountorproduct,style:
                          TextStyle(color: Colors.black,
                            fontSize: 15,), textAlign: TextAlign.left,),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                  data.image != "" ? Image.memory(
                    bytes,
                    height: 250,
                    width: 500,
                    fit: BoxFit.cover,
                  ) : Image(
                    image: AssetImage(
                        'assets/product_default.jpg'),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('Condition:   ',style:
                        TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                          fontSize: 18,), textAlign: TextAlign.left,),
                        RatingBarIndicator(
                          rating: data.exchangecondition,
                          itemCount: 5,
                          itemSize: 30,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,),),
                      ],
                    ),
                  ),
                ),
              ],
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: mongoDatabase.getProducts(),
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
                          for(int index = 0; index < totaldata; index++){
                            if(MongoDbProducts.fromJson(snapshot.data[index]).id.$oid == data.productid ){
                              Uint8List bytes = base64.decode(MongoDbProducts.fromJson(snapshot.data[index]).image);

                              return Card(
                                child: ListTile(
                                  onTap: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return ViewProductPage(id: id,type: MongoDbProducts.fromJson(snapshot.data[index]).productype, category: MongoDbProducts.fromJson(snapshot.data[index]).productcategory,);
                                        }, settings: RouteSettings(arguments: MongoDbProducts.fromJson(snapshot.data[index]))))
                                        .then((value) {setState(() {});
                                    });
                                  },
                                  contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                                  leading:  Column(
                                    children: [
                                      if(MongoDbProducts.fromJson(snapshot.data[index]).image == "")...[
                                        Image(
                                          image: AssetImage(
                                              'assets/product_default.jpg'),width: 70,height: 55,
                                        ),
                                      ]
                                      else...[
                                        MongoDbProducts.fromJson(snapshot.data[index]).image != null ? Image.memory(
                                          bytes,
                                          width: 70,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ) : FlutterLogo(size: 70, ),
                                      ],
                                    ],
                                  ),
                                  title: Text(MongoDbProducts.fromJson(snapshot.data[index]).productname,
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text('${MongoDbProducts.fromJson(snapshot.data[index]).productype}',
                                    style: TextStyle(color: Colors.black38,),
                                  ),
                                  trailing: Text('${MongoDbProducts.fromJson(snapshot.data[index]).productcondition}',
                                    style: TextStyle(color: Colors.amber,),
                                  ),
                                  //leading: Image.network(display_list[index].movie_poster_url!),
                                ),
                              );
                            }
                          }
                          return Container();
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: mongoDatabase.login(),
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
                          for(int index = 0; index < totaldata; index++){
                            if(MongoDbModel.fromJson(snapshot.data[index]).id.$oid == data.userid ){


                              return ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return ViewProfile(id: data.userid, userid: id,);
                                        }, settings: RouteSettings(arguments: MongoDbModel.fromJson(snapshot.data[index]))))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('View Profile'));
                            }
                          }
                          return Container();
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
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: mongoDatabase.getrderrequesttakenbyrider(),
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
                          for(int index=0; index < totaldata; index++){
                            print(data.id);
                            print(Mongodbordersrequesttaken.fromJson(snapshot.data[index]).orderorrequestid );
                            if(Mongodbordersrequesttaken.fromJson(snapshot.data[index]).orderorrequestid == data.id){
                              if(Mongodbordersrequesttaken.fromJson(snapshot.data[index]).iscomplete == true){
                                return Text('Order Completed',
                                  style: TextStyle(fontSize: 15, color: Colors.green),
                                  textAlign: TextAlign.left,);
                              }
                              else{
                                return Text('Order Not Complete',
                                  style: TextStyle(fontSize: 15, color: Colors.red),
                                  textAlign: TextAlign.left,);
                              }
                            }
                          }
                          return Column();
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
        ),
      ),
    );
  }

}
