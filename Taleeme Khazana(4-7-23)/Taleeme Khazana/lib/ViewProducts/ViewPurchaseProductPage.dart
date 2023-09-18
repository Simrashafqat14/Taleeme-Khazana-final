import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
//import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/categorySection.dart';
import 'package:fyp_project/MainPages/constants.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/cartmodel.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Cart/cartpage.dart';
import 'package:fyp_project/ViewProducts/Requests/makeARequest.dart';
import 'package:fyp_project/ViewProducts/Reviews/badworddetect.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:fyp_project/MainPages/serachPage.dart';


import '../Userprofilepages/ViewShop.dart';

class PurchaseProductPage extends StatefulWidget {
  final String id,category;
  const PurchaseProductPage({Key? key, required this.id,required this.category}) : super(key: key);

  @override
  State<PurchaseProductPage> createState() => _PurchaseProductPageState(id,category);
}

class _PurchaseProductPageState extends State<PurchaseProductPage> {
  String id,category;
  _PurchaseProductPageState(this.id, this.category);

  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data

  var reviewController = new TextEditingController();
  var ratingController;
  var emailController;
  var nameController;
  var quantityController = new TextEditingController();
  int priceController = 0;
  int price = 0;


  @override
  Widget build(BuildContext context) {
    print(category);
    MongoDbPurchasableProducts data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbPurchasableProducts;
    MongoDbModel? userdata;
    Uint8List bytes = base64.decode(data.image);

    Widget sizechartbutton = ElevatedButton(
        onPressed: (){
          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: FittedBox(child: Text('SIZE CHART')),
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
                              child: Text('S'),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Small'),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('M'),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Medium'),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('L'),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Large'),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('XL'),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Extra Large'),
                            )]),
                          ]),
                          TableRow( children: [
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('XXL'),
                            )]),
                            Column(children:[Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text('Double Extra Large'),
                            )]),
                          ]),
                        ],
                      )
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('CLOSE'),
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

    Widget colorfields = Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FittedBox(child:Text('Color:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontSize: 20,), textAlign: TextAlign.left,),),
                Ink(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: InkWell(
                      //borderRadius: BorderRadius.circular(100.0),
                      onTap: () {},
                      child:
                      Icon(Icons.circle, color: Color(int.parse(data.color)),),
                    )
                ),
              ],
            ),
          ]
      ),
    );

    Widget uniformfields = Column(
      children: [
        if(category == "Uniforms")...[
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
                    child: Text(data.uniformSize, style: TextStyle(color: Colors.blueAccent,
                        fontFamily: "Arvo",
                        fontSize: 15), textAlign: TextAlign.left,),
                  ),
                ],
              ),
              sizechartbutton
            ],
          ),
          colorfields
        ],
      ],
    );

    Widget BooksFields = Column(
      children: [
        if(category == "Books")...[
          Row(
            children: [
              FittedBox(child:Text('Author Name:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontFamily: "Arvo",
                fontSize: 20,), textAlign: TextAlign.left,),),
              Expanded(
                child: Text(data.bookauthor, style: TextStyle(color: Colors.blueAccent,
                    fontFamily: "Arvo",
                    fontSize: 15), textAlign: TextAlign.left,),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Book Tyoe:   ', style:
              TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                fontSize: 20,), textAlign: TextAlign.left,),
              Text(data.booktype, style: TextStyle(color: Colors.blueAccent,
                  fontSize: 20), textAlign: TextAlign.left,),
            ],
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
                    child: Text(data.shoesSize, style: TextStyle(color: Colors.blueAccent,
                        fontFamily: "Arvo",
                        fontSize: 15), textAlign: TextAlign.left,),
                  ),
                ],
              ),
              sizechartbutton
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              FittedBox(
                child: Text('Shoe Type:   ', style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                  fontFamily: "Arvo",
                  fontSize: 20,), textAlign: TextAlign.left,),
              ),
              FittedBox(child:Text(data.shoesType, style: TextStyle(color: Colors.blueAccent,
                  fontFamily: "Arvo",
                  fontSize: 15), textAlign: TextAlign.left,),),
            ],
          ),
          colorfields
        ]
      ],
    );

    Widget BagsFields = Column(
      children: [
        if(category == "Bags")...[
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FittedBox(
                    child: Text('Bag Size:   ', style:
                    TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w900,
                      fontFamily: "Arvo",
                      fontSize: 20,), textAlign: TextAlign.left,),
                  ),
                  FittedBox(
                    child: Text(data.bagsize, style: TextStyle(color: Colors.blueAccent,
                        fontFamily: "Arvo",
                        fontSize: 15), textAlign: TextAlign.left,),
                  ),
                ],
              ),
              sizechartbutton
            ],
          ),
          colorfields
        ]
      ],
    );

    Widget stationaryFields = Column(
      children: [
        if(category == "Stationary")...[
          colorfields
        ]
      ],
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Search here',style: TextStyle(
          ),),
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
                    Padding(padding: const EdgeInsets.only(
                         left: 15, right: 15, bottom: 30),
                      child: Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Container(
                                          child: FittedBox(
                                            child: Text(data.productname.toUpperCase(),
                                              style: TextStyle(color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Arvo",
                                                  fontSize: 30), textAlign: TextAlign
                                                  .left,),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
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
                                      ],
                                    )
                                ),
                                if(data.onSale == true)...[
                                  Container(
                                    margin: EdgeInsets.only(top:30),
                                      height: 30,
                                      width: 60,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            padding: EdgeInsets.only(top: 3),//<-- SEE HERE
                                          ),
                                          onPressed: (){},
                                          child: Column(
                                            children: [
                                              Text('Sale',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                                            ],
                                          )
                                      )
                                  ),
                                ]
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 100,
                                  child: FittedBox(
                                    child: Text(data.productname.toUpperCase(),
                                      style: TextStyle(color: Colors.blueAccent,
                                          fontFamily: "Arvo",
                                          fontSize: 30), textAlign: TextAlign
                                          .left,),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        FittedBox(
                                          child: Text('Price:   ',
                                            style: TextStyle(color: Colors.blueAccent,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15),
                                            textAlign: TextAlign.left,),
                                        ),
                                        if(data.onSale == true)...[
                                          Column(

                                            children: [
                                              Center(
                                                child: Container(
                                                  child:FittedBox(
                                                    child: Text(
                                                      'Rs/-' + data.productprice,
                                                      style: TextStyle(
                                                          color: Colors.blueAccent,
                                                          fontSize: 15),
                                                      textAlign: TextAlign.left,),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 0),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/linethrough.png'),
                                                        fit: BoxFit.fitWidth),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ]
                                        else
                                          ...[
                                            FittedBox(
                                              child: Text('Rs/-' + data.productprice,
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 15),
                                                textAlign: TextAlign.left,),
                                            ),
                                          ],

                                      ],
                                    ),
                                    if(data.onSale == true)...[
                                      Row(

                                        children: [
                                          Text('Sale Price:   ', style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15),
                                            textAlign: TextAlign.left,),
                                          Text('Rs/-' + data.saleprice,
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15),
                                            textAlign: TextAlign.left,),
                                        ],
                                      )
                                    ]
                                  ],
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    FittedBox(
                                      child: Text('Category:   ',
                                        style: TextStyle(color: Colors.blueAccent,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: "Arvo",
                                            fontSize: 20),
                                        textAlign: TextAlign.left,),
                                    ),
                                    FittedBox(child:Text(data.productcategory,
                                      style: TextStyle(color: Colors.blueAccent,
                                          fontFamily: "Arvo",
                                          fontSize: 15),
                                      textAlign: TextAlign.left,),),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Visibility(
                              visible: data.islimited,
                              child: Row(
                                children: [
                                  FittedBox(
                                    child: Text('Stock:   ', style:
                                    TextStyle(color: Colors.blueAccent,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "Arvo",
                                      fontSize: 20,), textAlign: TextAlign.left,),
                                  ),
                                 if(data.stock == "0")...[
                                   FittedBox(
                                     child: Text('OUT OF STOCK',
                                       style: TextStyle(color: Colors.red,
                                           fontSize: 15),
                                       textAlign: TextAlign.left,),
                                   ),
                                 ]
                                  else...[
                                   Text(data.stock,
                                     style: TextStyle(color: Colors.blueAccent,
                                         fontFamily: "Arvo",
                                         fontSize: 15),
                                     textAlign: TextAlign.left,),
                                 ]
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                FittedBox(
                                  child: Text('Desctripion:   ', style:
                                  TextStyle(color: Colors.blueAccent,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: "Arvo",
                                    fontSize: 20,), textAlign: TextAlign.left,),
                                ),
                                Expanded(child:
                                Text(data.productdescription,
                                  style: TextStyle(color: Colors.blueAccent,
                                      fontFamily: "Arvo",
                                      fontSize: 15),
                                  textAlign: TextAlign.left,),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            if(data.extrainformation != "")...[
                              Row(
                                children: [
                                  FittedBox(
                                    child: Text('Other Details:   ', style:
                                    TextStyle(color: Colors.blueAccent,
                                      fontFamily: "Arvo",
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,), textAlign: TextAlign.left,),
                                  ),
                                  Expanded(
                                    child:
                                    Text(data.extrainformation,
                                      style: TextStyle(color: Colors.blueAccent,
                                          fontFamily: "Arvo",
                                          fontSize: 20),
                                      textAlign: TextAlign.left,),

                                  ),
                                ],
                              ),
                            ],
                            uniformfields,
                            BooksFields,
                            ShoesFields,
                            BagsFields,
                            stationaryFields
                          ]
                      ),
                    ),
                    SizedBox(height: 30),
                    FittedBox(child: Text("REVIEWS", style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 25,), textAlign: TextAlign.center,)),
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
                                  itemBuilder: (context, index){
                                    print(snapshot.data[index]);
                                    if(data.id.$oid == Reviewmodel.fromJson(snapshot.data[index]).productid) {
                                      return displayCard(Reviewmodel.fromJson(
                                          snapshot.data[index]));
                                    }
                                    else{
                                      return Container();// Calling fuction passing data (from json) data into our model class
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
                          if(snapshot.connectionState== ConnectionState.waiting){
                            return Center(child:
                            CircularProgressIndicator(),
                            );
                          } else{
                            if(snapshot.hasData){
                              var totaldata = snapshot.data.length;
                              print("Total data: " + totaldata.toString());
                              for(var i = 0; i < totaldata; i++){
                                if(MongoDbModel.fromJson(snapshot.data[i]).id.$oid == data.userid){
                                  userdata = MongoDbModel.fromJson(snapshot.data[i]);
                                  return Buttons(data,userdata);
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
                    Padding(padding: EdgeInsets.only(top:10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Text('Taleem-e-Khazana',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.blueAccent),)])),
                  ]
              ),
            ),
          ),
        )
    );
  }
  Widget Buttons(MongoDbPurchasableProducts data, MongoDbModel? userdata){

    if(id == ""){
      return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                SafeArea(
                  child: FutureBuilder(
                    future: mongoDatabase.getShops(),
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
                            if(MongoDbShop.fromJson(snapshot.data[i]).userid == data.userid){
                              return ElevatedButton(onPressed: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return ViewPurchaseShop(id: data.userid, userdata:userdata!, userid: id,);
                                    }, settings: RouteSettings(arguments: MongoDbShop.fromJson(snapshot.data[i]))))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                                  child: Text('View Shop', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                              );
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
              ],
            ),
          )
      );
    }
    var stock = 0;
    int originalprice = 0;
    if(data.stock == ""){
      stock = 10000000;
    }
    else{
      if(data.onSale == false){
        stock = int.parse(data.stock);
      }
      else{
        stock = int.parse(data.stock);
      }
    }
    if(data.onSale == false){
      priceController = int.parse(data.productprice);
      price = int.parse(data.productprice);
      originalprice = int.parse(data.productprice);
    }
    else{
      priceController = int.parse(data.saleprice);
      price = int.parse(data.saleprice);
      originalprice = int.parse(data.saleprice);
    }

    int _counter = 0;

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
                    name: 'Review',
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Enter Review'
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
            child: Text('Submit')),
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
                    ElevatedButton(onPressed: (){
                      showGeneralDialog(
                        barrierLabel: "cart",
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: Duration(milliseconds: 700),
                        context: context,
                        pageBuilder: (context, anim1, anim2) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 50, left: 12, right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Scaffold(
                                    body: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:  MainAxisAlignment.center,
                                            children: [
                                              Text('Confirm Add to Cart',
                                                style: TextStyle(fontSize: 30,
                                                    color: Colors.blue),),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('Quantity:    ',
                                                      style: TextStyle(fontSize: 20,
                                                          color: Colors.blue),),
                                                    Padding(
                                                      child: SpinBox(
                                                        value: 0,
                                                        min: 1,
                                                        max: stock.toDouble(),
                                                        decoration: InputDecoration(labelText: 'Basic'),
                                                        onChanged: (val){
                                                          debugPrint(val.toString());
                                                          quantityController.text = val.toStringAsFixed(0);
                                                          if(quantityController.text.isEmpty){
                                                            quantityController.text = "0";
                                                          }
                                                          var p = priceController * val;
                                                          price = p.toInt();
                                                          print('price: '+price.toString());
                                                        },
                                                      ),
                                                      padding: const EdgeInsets.all(16),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 50, left: 50),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ElevatedButton(onPressed: (){
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context){
                                                            return AlertDialog(
                                                              title: const Text('Price'),
                                                              content: Text(price.toString()),
                                                              actions: <Widget>[
                                                                TextButton(onPressed: (){
                                                                  Navigator.of(context).pop(false);
                                                                }, child: Text('Ok')),
                                                              ],
                                                            );
                                                          }
                                                      );
                                                    }, child: Text('View price')),
                                                    ElevatedButton(
                                                        onPressed: (){
                                                          if(stock == 0){
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context){
                                                                  return AlertDialog(
                                                                    title: const Text('Stock message'),
                                                                    content: Text("Out Of Stock"),
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
                                                            print(quantityController.text);
                                                            _addtocart(data.userid,userdata!,id, data.id.$oid, data.productname, originalprice, int.parse(quantityController.text), price, int.parse(stock.toStringAsFixed(0)));
                                                          }
                                                        },
                                                        child: Text('Add to Cart'))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        transitionBuilder: (context, anim1, anim2, child) {
                          return SlideTransition(
                            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                            child: child,
                          );
                        },
                      );
                    },
                        child: Text('Add to Cart', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                    ),
                  ],
                  // Spacer(
                  //   flex: 90,
                  // ),

                  SafeArea(
                    child: FutureBuilder(
                      future: mongoDatabase.getShops(),
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
                              if(MongoDbShop.fromJson(snapshot.data[i]).userid == data.userid){
                                return ElevatedButton(onPressed: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return ViewPurchaseShop(id: data.userid, userdata:userdata!, userid: id,);
                                      }, settings: RouteSettings(arguments: MongoDbShop.fromJson(snapshot.data[i]))))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                    child: Text('View Shop', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                                );
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
  Future<void> _insertreview(String _userid, String _productid, String _name, String _email, var _rating, String _comment, MongoDbPurchasableProducts data) async {
    var _id = mongo.ObjectId();
    final review = Reviewmodel(id: _id, userid: _userid, productid: _productid, name: _name, email: _email, rating: _rating, comment: _comment);
    var result = await mongoDatabase.insertreview(review);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Review Submitted")));
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) {
      return PurchaseProductPage(id: id, category: data.productcategory,);}
        , settings: RouteSettings(arguments: data)));

  }

  Future<void> _addtocart(String _productuserid,MongoDbModel userdata,String _userid, String _productid, String _productname, int _oprice, int _quantity, int _uprice, int _stock) async {
    var _id = mongo.ObjectId();
    final addcart = CartModel(id: _id, userid: _userid, productid: _productid,productuserid:  _productuserid, productname: _productname, singleprice: _oprice, quantity: _quantity, price: _uprice, stock: _stock);
    var result = await mongoDatabase.addtocart(addcart);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added To Cart")));
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return cartPageView(id: id,);
        }));

  }
}
