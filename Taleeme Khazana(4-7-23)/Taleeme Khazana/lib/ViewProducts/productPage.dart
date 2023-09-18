import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Requests/loggedinuserexchnageproducts.dart';
import 'package:fyp_project/ViewProducts/Reviews/badworddetect.dart';
import 'package:fyp_project/ViewProducts/Reviews/leavereview.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/ViewProducts/Requests/makeARequest.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:fyp_project/MainPages/serachPage.dart';


import '../MainPages/categorySection.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../Userprofilepages/ViewProfile.dart';



class ViewProductPage extends StatefulWidget {
  final String id,category, type;
  const ViewProductPage({Key? key, required this.id,required this.category, required this.type}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState(id,category,type);
}

class _ViewProductPageState extends State<ViewProductPage> {
  String id,category,type;
  _ViewProductPageState(this.id, this.category,this.type);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data

  var reviewController = new TextEditingController();
  var ratingController;
  var emailController;
  var nameController;
  Widget donateFields = Container();
  Widget exchangeFields = Container();
  var container;
  @override
  Widget build(BuildContext context) {
    print("idPR: " + id);
    MongoDbProducts data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbProducts;
    MongoDbModel? userdata;
    Uint8List bytes = base64.decode(data.image);


    Widget sizechartbutton = ElevatedButton(
        onPressed: (){
          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: FittedBox(child: Text('SIZE CHART',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)),
                  content: SingleChildScrollView(
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(120.0),
                        border: TableBorder.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 2),
                        children: [
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child:Text('S')),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Small'),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child: Text('M')),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child:Text('Medium')),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child: Text('L')),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child:Text('Large')),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child:FittedBox(child: Text('XL')),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child:Text('Extra Large')),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: FittedBox(child:Text('XXL')),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child:FittedBox(child: Text('Double Extra Large')),
                            )]),
                          ]),
                        ],
                      )
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: FittedBox(child: Text('CLOSE')),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); //dismiss the color picker
                      },
                    ),
                  ],
                );
              }
          );
        },
        child: Text('Size Chart')
    );

    if (type == "Donate") {
      donateFields = Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Other Details:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontSize: 20,
                fontFamily: 'Arvo'
              ), textAlign: TextAlign.left,),
              Expanded(
                child: FittedBox(
                  child: Text(data.extrainformation, style:
                  TextStyle(color: Colors.blueAccent,fontFamily: 'Arvo',fontWeight: FontWeight.w900,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (type == "Exchange") {
      exchangeFields = Column(
        children: [
          Row(
            children: [
              Text('Exchange reason:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontFamily: 'Arvo',
                fontSize: 20,), textAlign: TextAlign.left,),
              Expanded(
                child: Text(data.exchangereason, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: 'Arvo',
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Exchange Source:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontSize: 20,), textAlign: TextAlign.left,),
              Text(data.exchangesource, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: 'Arvo',
                fontSize: 15,), textAlign: TextAlign.left,),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (data.exchangesource == "Cash") ...[
            container = Row(
              children: [
                FittedBox(
                  child: Text('Exchange Amount:   ', style:
                  TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                    fontFamily: 'Arvo',
                    fontSize: 20,), textAlign: TextAlign.left,),
                ),
                Text(data.requiredamountorproduct, style:
                TextStyle(color: Colors.blueAccent,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
          ]
          else
            ...[
              container = Row(
                children: [
                  Text('Exchange Product:   ', style:
                  TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w900,
                    fontSize: 20,), textAlign: TextAlign.left,),
                  Text(data.requiredamountorproduct, style:
                  TextStyle(color: Colors.blueAccent,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ]
        ],
      );
    }

    Widget uniformfields = Column(
      children: [
        if(category == "Uniforms")...[
          Row(
            children: [
              FittedBox(
                child: Text('School Name:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.schoolname, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FittedBox(
                    child: Text('Uniform Size:   ', style:
                    TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                      fontFamily: "Arvo",
                      fontSize: 20,), textAlign: TextAlign.left,),
                  ),
                  FittedBox(
                    child: Text(data.uniformSize, style:
                    TextStyle(color: Colors.blueAccent,
                      fontFamily: "Arvo",
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ),
                ],
              ),
              sizechartbutton
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text('Gender:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontFamily: "Arvo",
                fontSize: 20,), textAlign: TextAlign.left,),
              Text(data.gender, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 20,), textAlign: TextAlign.left,),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Color:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              Text(data.color, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 15,), textAlign: TextAlign.left,),
            ],
          ),
        ]
      ],
    );

    Widget BooksFields = Column(
      children: [
        if(category == "Books")...[
          Row(
            children: [
              FittedBox(
                child: Text('Author Name:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              Expanded(
                child: Text(data.authorname, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Subject:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.booksubject, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Grade:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              Text(data.grade, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 15,), textAlign: TextAlign.left,),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('No of Pages:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.noofpages, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ]
      ],
    );


    Widget ShoesFields = Column(
      children: [
        if(category == "Shoes")...[
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FittedBox(
                    child: Text('Shoe Size:   ', style:
                    TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                      fontFamily: "Arvo",
                      fontSize: 20,), textAlign: TextAlign.left,),
                  ),
                  FittedBox(
                    child: Text(data.shoesSize, style:
                    TextStyle(color: Colors.blueAccent,
                      fontFamily: "Arvo",
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ),
                ],
              ),
              sizechartbutton
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Gender:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.gender, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Shoe Style:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.shoesstyle, style:
                TextStyle(color: Colors.blueAccent,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Color:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(child:Text(data.color, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 15,), textAlign: TextAlign.left,),)
            ],
          ),
        ]
      ],
    );

    Widget BagsFields = Column(
      children: [
        if(category == "Bags")...[
          Row(
            children: [
              FittedBox(
                child: Text('Color:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(child:Text(data.color, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 20,), textAlign: TextAlign.left,),),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Grade:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.grade, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Bag Type:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",

                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
              child:Text(data.bagtype, style:
              TextStyle(color: Colors.blueAccent,
                fontFamily: "Arvo",
                fontSize: 15,), textAlign: TextAlign.left,),),
            ],
          ),
        ]
      ],
    );

    Widget StationaryFields = Column(
      children: [
        if(category == "Stationary")...[
          Row(
            children: [
              FittedBox(
                child: Text('No of Items:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.noofitemsstationary, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Stationary Name:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(child:Text(data.stationaryname, style:
              TextStyle(color: Colors.blueAccent,
                fontSize: 15,), textAlign: TextAlign.left,),),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Color:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(
                child: Text(data.color, style:
                TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15,), textAlign: TextAlign.left,),
              ),
            ],
          ),
        ]
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: FittedBox(child: Text('Search here',)),
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
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          FittedBox(
                            child: Text(data.productname, style:
                            TextStyle(color: Colors.blueAccent,
                              fontWeight: FontWeight.w900,
                              fontFamily: "Roboto",
                              fontSize: 20,), textAlign: TextAlign.center,),
                          ),
                          SizedBox(height: 10,),
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
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              FittedBox(
                                child: Text('Name:   ', style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Arvo',
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                child: Text(data.productname, style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arvo',
                                  fontSize: 15,), textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text('Details:   ', style:
                              TextStyle(color: Colors.blueAccent,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Arvo',
                                fontSize: 20,), textAlign: TextAlign.left,),
                              Expanded(
                                child: Text(data.productdescription, style:
                                TextStyle(color: Colors.blueAccent,
                                  fontFamily: 'Arvo',
                                  fontSize: 15,), textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text('Condition:   ', style:
                              TextStyle(color: Colors.blueAccent,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Arvo',
                                fontSize: 20,), textAlign: TextAlign.left,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: RatingBarIndicator(
                                  rating: data.productcondition,
                                  itemCount: 5,
                                  itemSize: 30,
                                  itemBuilder: (context, _) =>
                                      Icon(
                                          Icons.star,
                                          color: Colors.orange),),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SafeArea(
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
                                    print(
                                        "Total data: " + totaldata.toString());
                                    for (var i = 0; i < totaldata; i++) {
                                      if (MongoDbModel
                                          .fromJson(snapshot.data[i])
                                          .id
                                          .$oid == data.userid) {
                                        userdata = MongoDbModel.fromJson(
                                            snapshot.data[i]);
                                        return Row(
                                          children: [
                                            if(MongoDbModel
                                                .fromJson(snapshot.data[i])
                                                .nickname == "")...[
                                              Container(),
                                            ]
                                            else
                                              ...[
                                                Text('Uploaded By:   ', style:
                                                TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Arvo',
                                                  fontSize: 20,),
                                                  textAlign: TextAlign.left,),
                                                Text(MongoDbModel
                                                    .fromJson(snapshot.data[i])
                                                    .nickname, style:
                                                TextStyle(color: Colors.black,
                                                  fontFamily: 'Arvo',
                                                  fontSize: 15,),
                                                  textAlign: TextAlign.left,),
                                              ]
                                          ],
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
                            ), //Future builder to fetch data
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          uniformfields,
                          BooksFields,
                          ShoesFields,
                          BagsFields,
                          StationaryFields,
                          SizedBox(
                            height: 20,
                          ),
                          donateFields,
                          exchangeFields,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                     Text("REVIEWS", style: TextStyle(color: Colors.blueAccent,
                        fontFamily: 'Arvo',
                        fontWeight: FontWeight.bold,
                        fontSize: 25,), textAlign: TextAlign.center,),
                    SafeArea(
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
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    print(snapshot.data[index]);
                                    if (data.id.$oid == Reviewmodel
                                        .fromJson(snapshot.data[index])
                                        .productid) {
                                      return displayCard(Reviewmodel.fromJson(
                                          snapshot.data[index]));
                                    }
                                    else {
                                      return Container(); // Calling fuction passing data (from json) data into our model class
                                    }
                                  });
                            } else {
                              return Center(
                                child: Text("No Data Available."),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SafeArea(
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
                              for (var i = 0; i < totaldata; i++) {
                                if (MongoDbModel
                                    .fromJson(snapshot.data[i])
                                    .id
                                    .$oid == data.userid) {
                                  userdata =
                                      MongoDbModel.fromJson(snapshot.data[i]);
                                  return Buttons(data, userdata);
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
                      ), //Future builder to fetch data
                    ),
                    Padding(padding: EdgeInsets.only(top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('TALEEM-E-KHAZANA', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.black),)
                            ])),
                  ],
                ),
              ),
            )
        )
    );
  }
  Widget Buttons(MongoDbProducts data, MongoDbModel? userdata){
    MongoDbProducts? productdata =  ModalRoute.of(context)?.settings.arguments as MongoDbProducts?;
    if(id == ""){
      return SafeArea(
          child: Padding(
            padding:const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return myWelcomeBackPage();
                      }));
                },
                  child:Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Text('Login Account', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ViewProfile(id: data.userid, userid: id,);
                      }, settings: RouteSettings(arguments: userdata)))
                      .then((value) {
                    setState(() {});
                  });
                },
                    child:Text('View Profile', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                ),
              ],
            ),
          )
      );
    }
    return Column(
      children: [
        FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: Column(
                children: [
                  FormBuilderTextField(
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                    controller: reviewController,
                    name: 'Comments',
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Enter Comments'
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Select Rating :',),
                  SizedBox(
                    height: 10,
                  ),
                  RatingBar.builder(
                    itemSize: 35,
                    initialRating: 1,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.blueAccent,
                    ),
                    onRatingUpdate: (rating) {
                      ratingController = rating;
                      print(rating);
                    },
                  ),
                ]
            ),
          ),
        ),
        SafeArea(
          child: FutureBuilder(
            future: mongoDatabase.login(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.connectionState== ConnectionState.waiting){
                return Center(child:
                CircularProgressIndicator(),
                );
              } else{
                if(snapshot.hasData){
                  var totaldata = snapshot.data.length;
                  print("Total data: " + totaldata.toString());
                  for(var i = 0; i < totaldata; i++){
                    if(id == MongoDbModel.fromJson(snapshot.data[i]).id.$oid){
                      nameController = MongoDbModel.fromJson(snapshot.data[i]).userName;
                      emailController = MongoDbModel.fromJson(snapshot.data[i]).email;

                      return SizedBox(height: 0,);
                    }
                  }
                  return Container();
                }else{
                  return Center(
                    child: Text("No Data Available."),
                  );
                }
              }
            },
          ), //Future builder to fetch data
        ),
        ElevatedButton(
            onPressed: (){
              print(nameController );
              print(emailController);
              if(Badworddetector(reviewController.text) == true){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text('BadWord Detected'),
                        content: Text('Please refrain from usign any badword'),
                        actions: <Widget>[
                          TextButton(onPressed: (){
                            Navigator.of(context).pop(false);
                          }, child: Text('Ok')),
                        ],
                      );
                    }
                );
              }
              else{
                if(_formKey.currentState?.validate() == true){
                  print(true);
                  if(ratingController == null){
                    ratingController = 1.0;
                  }
                  _insertreview(id, data.id.$oid, nameController,emailController, ratingController, reviewController.text, data);
                }
              }

            } ,
            style: ElevatedButton.styleFrom(
                primary: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            child: Text('Submit')
        ),
        SizedBox(
          height: 30,
        ),
        SafeArea(
          child: Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 60,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(id != productdata!.userid)...[
                    ElevatedButton(
                      onPressed: () {
                        if(type == "Exchange"){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Request Option'),
                              content: const Text('Select the option you want to request with'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {

                                          return makeARequestPage(id: id,category: category,type: type, productdata: productdata!, isproduct: false);
                                        }, settings: RouteSettings(arguments: data),
                                        ))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('Using Form', ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return Exchangeproductsforloggedinuserpage(id: id, category: category, type: type,);
                                        }, settings: RouteSettings(arguments: data),
                                        ))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: const Text('With Product'),
                                ),
                              ],
                            ),
                          );
                        }
                        else{
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return makeARequestPage(id: id,category: category,type: type, productdata: productdata!, isproduct: false);
                              }, settings: RouteSettings(arguments: data),
                              ))
                              .then((value) {
                            setState(() {});
                          });
                        }
                      },
                      child: const Text('Request', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                    ),
                  ],
                  SizedBox(width: 40,
                    height: 10,),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return ViewProfile(id: data.userid, userid: id,);
                        }, settings: RouteSettings(arguments: userdata)))
                        .then((value) {
                      setState(() {});
                    });
                  },
                    child: Text('View Profile', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),


                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget displayCard(Reviewmodel data){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${data.name}"),
                RatingBarIndicator(
                  rating: data.rating,
                  itemCount: 5,
                  itemSize: 15,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,),),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(" ${data.email}",textAlign: TextAlign.left,),
            SizedBox(
              height: 5,
            ),
            Text(" ${data.comment}",textAlign: TextAlign.left,),

          ],
        ),
      ),
    );
  }


  //For inserting Reviews in database
  Future<void> _insertreview(String _userid, String _productid, String _name, String _email, var _rating, String _comment, MongoDbProducts data) async {
    var _id = mongo.ObjectId();
    final review = Reviewmodel(id: _id, userid: _userid, productid: _productid, name: _name, email: _email, rating: _rating, comment: _comment);
    var result = await mongoDatabase.insertreview(review);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Review Submitted")));
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) {
      return ViewProductPage(id: id, category: data.productcategory,type: data.productype,);}
        , settings: RouteSettings(arguments: data)));

  }
}