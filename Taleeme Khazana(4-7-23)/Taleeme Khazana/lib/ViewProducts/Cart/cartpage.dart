import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:flutter_touch_spin/flutter_touch_spin.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/cartmodel.dart';
import 'package:fyp_project/MongoDBModels/discountvoucher.dart';
import 'package:fyp_project/MongoDBModels/ordermodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:intl/intl.dart';

class cartPageView extends StatefulWidget {
  final String id;
  const cartPageView({Key? key, required this.id}) : super(key: key);

  @override
  State<cartPageView> createState() => _cartPageViewState(id);
}

class _cartPageViewState extends State<cartPageView> {
  String id;
  _cartPageViewState(this.id);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data

  var quantitycontroller = new TextEditingController();
  var type = new TextEditingController();
  var amount = new TextEditingController();
  var price =  new TextEditingController();
  var shopeuserid =  new TextEditingController();
  var discountshopeuserid =  new TextEditingController();
  var discountedprice = new TextEditingController();
  var updateprice =  new TextEditingController();
  var subTotal = new TextEditingController();
  var vouchernamecontroller = new TextEditingController();
  int total = 0;
  String name = "";
  String email = "";
  String address = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('ADD TO CART'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              children: [
                if(id == "")...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('LOGIN TO VIEW CART', style: TextStyle(fontSize: 30, color: Colors.blue),),
                      ),
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return myWelcomeBackPage();
                            }));
                      }, child: Text('Login'))
                    ],
                  )
                ]
                else...[
                  FutureBuilder(
                    future: mongoDatabase.getcartbyuser(id),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return
                          Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                      else {
                        if (snapshot.hasData) {
                          total = 0;

                          var totaldata = snapshot.data.length;
                          print("Total data Cart: " + totaldata.toString());
                          if(totaldata == 0) {
                            return Column(
                              children: [
                                SizedBox(height: 30,),
                                Center(
                                  child: Text('NO ITEMS IN CART', style: TextStyle(fontSize: 30, color: Colors.blue),),
                                ),
                                SizedBox(height: 30,),
                                subTotalCard(subTotal.text, totaldata),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              ListView.builder(
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    total = CartModel.fromJson(snapshot.data[index]).price + total;
                                    subTotal.text = total.toString();
                                    print('total: '+ subTotal.text);
                                    return Column(
                                      children: [
                                        displayCard(CartModel.fromJson(snapshot.data[index])),
                                        if(index == totaldata-1)...[
                                          Column(
                                            children: [
                                              SizedBox(height: 30,),
                                              subTotalCard(subTotal.text, totaldata),
                                            ],
                                          )
                                        ]
                                      ],
                                    );
                                  }
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    },
                  ),
                ]
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget displayCard(CartModel data) {
    quantitycontroller.text = data.quantity.toString();
    updateprice.text = data.singleprice.toString();
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child:Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          child: Text(data.productname.toUpperCase(),
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.left,),
                        ),
                        SizedBox(height: 5,),
                        Text('Rs/- ' + data.singleprice.toString(),
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text('Amount:   ', style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,),
                        Text('Rs/- ' + data.price.toString(),
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.left,),
                      ],
                    )
                  ],
                ),
                Divider(),
                Padding(
                  child: SpinBox(
                    value: data.quantity.toDouble(),
                    min: 1,
                    max: data.stock.toDouble(),
                    decoration: InputDecoration(labelText: 'Basic'),
                    onChanged: (val){
                      debugPrint(val.toString());
                      quantitycontroller.text = val.toStringAsFixed(0);
                      var p = data.singleprice * val;
                      updateprice.text = p.toStringAsFixed(0);
                      print('price: ' + updateprice.toString());
                    },
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TouchSpin(
                    //   key: UniqueKey(),
                    //   value: int.parse(quantitycontroller.text),
                    //   min: 1,
                    //   max: data.stock,
                    //   step: 1,
                    //   textStyle: const TextStyle(fontSize: 20),
                    //   iconSize: 25,
                    //   addIcon: const Icon(Icons.add),
                    //   subtractIcon: const Icon(Icons.remove),
                    //   iconActiveColor: Colors.blue,
                    //   iconDisabledColor: Colors.grey,
                    //   onChanged: (val) {
                    //     debugPrint(val.toString());
                    //     quantitycontroller.text = val.toString();
                    //     var p = data.singleprice * val;
                    //     updateprice.text = p.toString();
                    //     print('price: ' + updateprice.toString());
                    //   },
                    //   enabled: true,
                    // ),
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                onPressed: (){
                                  _updatecart(data, int.parse(quantitycontroller.text) , int.parse(updateprice.text));
                                },
                                child: Text('Update Quantity'))
                          ],
                        ),
                        IconButton(
                            onPressed: () async {
                              await mongoDatabase.deletefromcart(data);
                              setState(() {

                              });
                            },
                            icon: Icon(Icons.delete_forever, size: 25,)),
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

  Widget subTotalCard(String subtotal, int carttotal){

    String discountprice = "0";
    bool discounttype = false;
    String discountedshipid = "";
    String productshopid = "";
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('d MMM EEE').format(date);
    print(formattedDate);
    DateTime time = DateTime.now();
    String formattedtime = DateFormat('kk:mm:ss').format(time);

   return Column(
     children: [
       Card(
         child: Padding(
           padding: const EdgeInsets.all(20),
           child: Column(
             children: [
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
                         for(var i = 0; i < totaldata; i++) {
                           if (MongoDbModel.fromJson(snapshot.data[i]).id.$oid == id) {
                             MongoDbModel userdata = MongoDbModel.fromJson(snapshot.data[i]);
                             name = userdata.fullname;
                             email = userdata.email;
                             address = userdata.address + ' \n' + userdata.city + ' \n' + userdata.country;
                             return Column(
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment
                                       .spaceBetween,
                                   children: [
                                     Text('Name:   ',
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                     Text(userdata.fullname,
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment
                                       .spaceBetween,
                                   children: [
                                     Text('Email:   ',
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                     Text(userdata.email,
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                   ],
                                 ),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment
                                       .spaceBetween,
                                   children: [
                                     Text('Address:   ',
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                     Text(userdata.country + ' \n' + userdata.city + ' \n' + userdata.address,
                                       style: TextStyle(fontSize: 15),
                                       textAlign: TextAlign.left,),
                                   ],
                                 ),
                               ],
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
               Divider(),
               Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: [
                   Text('Subtotal:   ',
                     style: TextStyle(fontSize: 15),
                     textAlign: TextAlign.left,),
                   Text('Rs/- '+ subtotal,
                     style: TextStyle(fontSize: 15),
                     textAlign: TextAlign.left,),
                 ],

               ),
               Divider(),
               Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: [
                   Text('Payment Method',
                     style: TextStyle(fontSize: 15),
                     textAlign: TextAlign.left,),
                   Text('Cash On Delivery',
                     style: TextStyle(fontSize: 15),
                     textAlign: TextAlign.left,),
                 ],

               ),
               Divider(),

               SafeArea(
                 child: FutureBuilder(
                     future: mongoDatabase.getdiscountvouchers(),
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
                             if(Mongodbdiscount.fromJson(snapshot.data[i]).name == vouchernamecontroller.text){
                               discountedshipid = Mongodbdiscount.fromJson(snapshot.data[i]).userid;
                               discountshopeuserid.text = discountedshipid;
                               discountprice = Mongodbdiscount.fromJson(snapshot.data[i]).amount;
                               discounttype = Mongodbdiscount.fromJson(snapshot.data[i]).type;

                               print(discountprice);
                               print(discounttype);
                               type.text = discounttype.toString();
                               amount.text = discountprice;
                               if(Mongodbdiscount.fromJson(snapshot.data[i]).type == false){
                                 int a = int.parse(subtotal) - int.parse(discountprice);
                                 discountedprice.text = a.toString();
                               }
                               else{
                                 double a = (int.parse(subtotal) / 100) * int.parse(discountprice);
                                 int b = int.parse(subtotal) - a.toInt();
                                 discountedprice.text = b.toString();
                               }
                             }
                           }
                         }
                         return Container();
                       }
                     }
                 ), //Future builder to fetch data
               ),
               SafeArea(
                 child: FutureBuilder(
                     future: mongoDatabase.getShops(),
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
                             if(MongoDbShop.fromJson(snapshot.data[i]).userid == discountshopeuserid.text){
                               productshopid = MongoDbShop.fromJson(snapshot.data[i]).userid;
                               shopeuserid.text = productshopid;
                               print(shopeuserid);

                             }
                           }
                         }
                         return Container();
                       }
                     }
                 ), //Future builder to fetch data
               ),

               Padding(
                 padding: const EdgeInsets.all(20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       width: 150,
                       child: FormBuilderTextField(
                         autovalidateMode:AutovalidateMode.disabled,
                         controller: vouchernamecontroller,
                         name: 'voucher',
                         decoration: InputDecoration(
                           labelText: 'Enter Discount Voucher',
                           contentPadding: EdgeInsets.all(0),
                         ),
                         validator: FormBuilderValidators.compose(
                             [FormBuilderValidators.required()]),
                       ),
                     ),
                     SizedBox(width: 20,),
                     ElevatedButton(
                         onPressed: () {
                           print(shopeuserid);
                           print(discountshopeuserid);
                           if(shopeuserid.text == discountshopeuserid.text){
                             if(vouchernamecontroller.text == ""){
                               ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Add a voucher ")));
                             }
                             else{
                               setState(() {
                                 if(carttotal == 0){
                                   showDialog(
                                       context: context,
                                       builder: (BuildContext context){
                                         return AlertDialog(
                                           title: const Text('VCart Empty'),
                                           content: Text('Please Add Items In Cart '),
                                           actions: <Widget>[
                                             TextButton(onPressed: (){
                                               setState(() {

                                               });
                                             }, child: Text('Ok')),
                                           ],
                                         );
                                       }
                                   );
                                 }
                                 else{
                                   showDialog(
                                       context: context,
                                       builder: (BuildContext context){
                                         return AlertDialog(
                                           title: const Text('Voucher Added'),
                                           content: Text('Voucher Name: '+vouchernamecontroller.text),
                                           actions: <Widget>[
                                             TextButton(onPressed: (){
                                               setState(() {

                                               });
                                             }, child: Text('Ok')),
                                           ],
                                         );
                                       }
                                   );
                                 }
                               });
                             }
                           }
                           else{
                             ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text("This voucher doesnot belong to this user / It doesnot exist")));
                           }
                         }, child: Text('Submit')),
                   ],
                 ),
               ),

               if(vouchernamecontroller.text != "" && carttotal != 0)...[
                 Row(
                   mainAxisAlignment: MainAxisAlignment
                       .spaceBetween,
                   children: [
                     Text('Voucher applied',
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                     Text(vouchernamecontroller.text,
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                   ],

                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment
                       .spaceBetween,
                   children: [
                     Text('Type',
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                     Text(type.text,
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment
                       .spaceBetween,
                   children: [
                     Text('Amount: ',
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                     Text(amount.text,
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                   ],
                 ),
                 Divider(),
                 Row(
                   mainAxisAlignment: MainAxisAlignment
                       .spaceBetween,
                   children: [
                     Text('After Discount:   ',
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                     Text('Rs/- '+ discountedprice.text,
                       style: TextStyle(fontSize: 15),
                       textAlign: TextAlign.left,),
                   ],

                 ),
                 Divider()
               ],
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   ElevatedButton(
                       onPressed: () async {
                         if(carttotal == 0){
                           showDialog(
                               context: context,
                               builder: (BuildContext context){
                                 return AlertDialog(
                                   title: const Text('Empty Cart'),
                                   content: Text('No items in Cart'),
                                   actions: <Widget>[
                                     TextButton(onPressed: (){
                                       Navigator.of(context).pop(false);
                                     }, child: Text('Ok')),
                                   ],
                                 );
                               }
                           );
                         }else{
                           showDialog(
                               context: context,
                               builder: (BuildContext context){
                                 var random = new Random();
                                 var invoiceno = random.nextInt(900000) + 100000;
                                 return AlertDialog(
                                   title: const Text('Order Confirmation'),
                                   content: SingleChildScrollView(
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         SafeArea(
                                           child: FutureBuilder(
                                             future: mongoDatabase.getcartbyuser(id),
                                             builder: (context, AsyncSnapshot snapshot) {
                                               if(snapshot.connectionState== ConnectionState.waiting){
                                                 return Center(child:
                                                 CircularProgressIndicator(),
                                                 );
                                               } else{
                                                 if(snapshot.hasData){
                                                   var totaldata = snapshot.data.length;
                                                   print("Total data order: " + totaldata.toString());
                                                   for(var i = 0; i < totaldata; i++) {
                                                       print(i);
                                                       print(CartModel.fromJson(snapshot.data[i]).productname);
                                                       print(name);
                                                       print(email);
                                                       print(address);
                                                       print(invoiceno);
                                                       print(formattedDate);
                                                       print(formattedtime);

                                                       _orderconfimration(CartModel.fromJson(snapshot.data[i]).productuserid ,name, email, address, invoiceno, id, CartModel.fromJson(snapshot.data[i]).productid, CartModel.fromJson(snapshot.data[i]).productname, CartModel.fromJson(snapshot.data[i]).quantity, int.parse(discountedprice.text), formattedDate.toString(), formattedtime.toString());
                                                       mongoDatabase.deletefromcartbyuserid(id);
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
                                         Text('Order Sent Successfully'),
                                         SafeArea(
                                           child: FutureBuilder(
                                             future: mongoDatabase.getcartbyuser(id),
                                             builder: (context, AsyncSnapshot snapshot) {
                                               if(snapshot.connectionState== ConnectionState.waiting){
                                                 return Center(child:
                                                 CircularProgressIndicator(),
                                                 );
                                               } else{
                                                 if(snapshot.hasData){
                                                   var totaldata = snapshot.data.length;
                                                   print("Total data: " + totaldata.toString());
                                                   return Column(
                                                     children: [
                                                       Padding(
                                                         padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                         child: Row(
                                                           mainAxisAlignment: MainAxisAlignment
                                                               .spaceBetween,
                                                           children: [
                                                             Text(formattedDate.toString(),
                                                               style: TextStyle(fontSize: 15),
                                                               textAlign: TextAlign.left,),
                                                             Text('Time: '+formattedtime.toString(),
                                                               style: TextStyle(fontSize: 15),
                                                               textAlign: TextAlign.left,),
                                                           ],
                                                         ),
                                                       ),
                                                       Divider(),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment
                                                             .spaceBetween,
                                                         children: [
                                                           Text('Invoice No:   ',
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                           Text(invoiceno.toString(),
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                         ],
                                                       ),
                                                       SizedBox(
                                                         height: 8,
                                                       ),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment
                                                             .spaceBetween,
                                                         children: [
                                                           Text('Name:   ',
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                           Text(name,
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                         ],
                                                       ),
                                                       SizedBox(
                                                         height: 8,
                                                       ),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment
                                                             .spaceBetween,
                                                         children: [
                                                           Text('Email:   ',
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                           Text(email,
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                         ],
                                                       ),
                                                       SizedBox(
                                                         height: 8,
                                                       ),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment
                                                             .spaceBetween,
                                                         children: [
                                                           Text('Address:   ',
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                           Text(address.toString(),
                                                             style: TextStyle(fontSize: 15),
                                                             textAlign: TextAlign.left,),
                                                         ],
                                                       ),
                                                       SizedBox(
                                                         height: 8,
                                                       ),
                                                       Divider(),
                                                       for(var index = 0; index < totaldata; index++)...[
                                                         Column(
                                                           children: [
                                                             Row(
                                                               mainAxisAlignment: MainAxisAlignment
                                                                   .spaceBetween,
                                                               children: [
                                                                 Text(
                                                                   'Order ${index}:   ',
                                                                   style: TextStyle(
                                                                       fontSize: 15),
                                                                   textAlign: TextAlign
                                                                       .left,),
                                                                 Column(
                                                                   children: [
                                                                     Container(
                                                                       width: 150,
                                                                       child: Text(
                                                                         CartModel
                                                                             .fromJson(
                                                                             snapshot
                                                                                 .data[index])
                                                                             .productname,
                                                                         style: TextStyle(
                                                                             fontSize: 15),
                                                                         textAlign: TextAlign
                                                                             .left,),
                                                                     ),
                                                                     Text(
                                                                       CartModel
                                                                           .fromJson(
                                                                           snapshot
                                                                               .data[index])
                                                                           .quantity
                                                                           .toString(),
                                                                       style: TextStyle(
                                                                           fontSize: 15),
                                                                       textAlign: TextAlign
                                                                           .left,),
                                                                     Text(
                                                                       CartModel
                                                                           .fromJson(
                                                                           snapshot
                                                                               .data[index])
                                                                           .price
                                                                           .toString(),
                                                                       style: TextStyle(
                                                                           fontSize: 15),
                                                                       textAlign: TextAlign
                                                                           .left,),
                                                                   ],
                                                                 ),
                                                               ],
                                                             ),
                                                             Divider(),
                                                             SizedBox(
                                                               height: 8,
                                                             ),
                                                           ],
                                                         )
                                                       ],
                                                       Padding(
                                                         padding: const EdgeInsets.only(top: 10),
                                                         child: Row(
                                                           mainAxisAlignment: MainAxisAlignment
                                                               .spaceBetween,
                                                           children: [
                                                             Text('Subtotal:   ',
                                                               style: TextStyle(fontSize: 15),
                                                               textAlign: TextAlign.left,),
                                                             Text(discountedprice.text,
                                                               style: TextStyle(fontSize: 15),
                                                               textAlign: TextAlign.left,),
                                                           ],
                                                         ),
                                                       ),
                                                     ],
                                                   );
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
                                   actions: <Widget>[
                                     TextButton(onPressed: (){
                                       Navigator.of(context).pop(false);
                                       setState(() {

                                       });
                                     }, child: Text('Ok')),
                                   ],
                                 );
                               }
                           );
                         }
                       },
                       child: Text('Place Order'))
                 ],
               )
             ],
           ),
         ),
       )
     ],
   );
  }

  Future<void> _updatecart(CartModel data, int _quantity, int _updatedprice) async{
    final update_cart = CartModel(id: data.id, userid: data.userid, productid: data.productid,productuserid: data.productuserid, productname: data.productname, singleprice: data.singleprice, quantity: _quantity, price: _updatedprice, stock: data.stock);
    await mongoDatabase.updatecart(update_cart);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cart Updated ")));
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return cartPageView(id: id,);
        })
    ).then((value) => setState(() {}));
  }


  Future<void> _orderconfimration(String _productuserid,String _name, String _email, String _address, int _invoiceno,String _userid, String _productid, String _productname, int _quantity, int _amount, String _date, String _time) async {
    var _id = mongo.ObjectId();
    final order = MongoDbOrder(id: _id, invoiceNo: _invoiceno, productid: _productid, userid: _userid, productuserid: _productuserid, username: _name, useremail: _email, useraddress: _address, productname: _productname, quantity: _quantity, amount: _amount,date: _date, time: _time, status: false);
    var result = await mongoDatabase.orderconfimration(order);
  }
}
