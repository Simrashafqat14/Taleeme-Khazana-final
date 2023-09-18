import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/categorySection.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Userprofilepages/ViewProfile.dart';
import 'package:fyp_project/ViewProducts/Reviews/badworddetect.dart';
import 'package:fyp_project/ViewProducts/borrow/MakeaRequestBorrow.dart';
import 'package:fyp_project/ViewProducts/borrow/borrowproductsloggeduser.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;


class ViewBorrowProduct extends StatefulWidget {
  final String id;
  const ViewBorrowProduct({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewBorrowProduct> createState() => _ViewBorrowProductState(id);
}

class _ViewBorrowProductState extends State<ViewBorrowProduct> {
  String id;
  _ViewBorrowProductState(this.id);

  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data

  var reviewController = new TextEditingController();
  var ratingController;
  var emailController;
  var nameController;
  @override
  Widget build(BuildContext context) {
    MongoDbBorrow data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbBorrow;
    MongoDbModel? userdata;
    Uint8List bytes = base64.decode(data.image);
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
            padding: const EdgeInsets.only(),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                         top:10, left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                            Text(data.bookname, style:
                            TextStyle(color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Arvo",
                              fontSize: 20,), textAlign: TextAlign.left,),
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
                                  fontFamily: "Arvo",
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                child: Text(data.bookname, style:
                                TextStyle(color: Colors.blueAccent,
                                  fontFamily: "Arvo",
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              FittedBox(
                                child: Text('Details:   ', style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Arvo",
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                child: Text(data.description, style:
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
                                child: Text('Author Name:   ', style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,
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
                                child: Text('BookEdition:   ', style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Arvo",
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                              Expanded(
                                child: Text(data.bookwdition, style:
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
                                child: Text('Condition:   ', style:
                                TextStyle(color: Colors.blueAccent,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "Arvo",
                                  fontSize: 20,), textAlign: TextAlign.left,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: RatingBarIndicator(
                                  rating: data.condition,
                                  itemCount: 5,
                                  itemSize: 40,
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
                                                  fontSize: 20,),
                                                  textAlign: TextAlign.left,),
                                                Text(MongoDbModel
                                                    .fromJson(snapshot.data[i])
                                                    .nickname, style:
                                                TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,),
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("REVIEWS", style: TextStyle(color: Colors.blueAccent,
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
                              Text('Taleem-e-Khazana', style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.blueAccent),)
                            ])),
                  ],
                ),
              ),
            )
        )
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


  Widget Buttons(MongoDbBorrow data, MongoDbModel? userdata){
    MongoDbBorrow? productdata =  ModalRoute.of(context)?.settings.arguments as MongoDbBorrow?;
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
                  if(id != data.userid)...[
                    ElevatedButton(
                      onPressed: () {
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

                                        return makeARequestBorrowPage(id: id,category: 'Books',type: 'Borrow', productdata: productdata!, isproduct: false);
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
                                        return BorrowLoggedInProducts(id: id,);
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

  //For inserting Reviews in database
  Future<void> _insertreview(String _userid, String _productid, String _name, String _email, var _rating, String _comment, MongoDbBorrow data) async {
    var _id = mongo.ObjectId();
    final review = Reviewmodel(id: _id, userid: _userid, productid: _productid, name: _name, email: _email, rating: _rating, comment: _comment);
    var result = await mongoDatabase.insertreview(review);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Review Submitted")));
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) {
      return ViewBorrowProduct(id: id);}
        , settings: RouteSettings(arguments: data)));

  }
}
