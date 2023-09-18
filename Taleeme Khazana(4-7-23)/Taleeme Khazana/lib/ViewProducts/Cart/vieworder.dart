import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/OrdersRequestsTaken.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/ordermodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Cart/viewuserorders.dart';

class OrderViewPage extends StatefulWidget {
  final String id;
  final MongoDbModel userdata;
  const OrderViewPage({Key? key, required this.userdata, required this.id}) : super(key: key);

  @override
  State<OrderViewPage> createState() => _OrderViewPageState(userdata, id);
}

class _OrderViewPageState extends State<OrderViewPage> {
  MongoDbModel userdata;
  String id;
  _OrderViewPageState(this.userdata, this.id);
  @override
  Widget build(BuildContext context) {
    MongoDbOrder data = ModalRoute.of(context)!.settings.arguments as MongoDbOrder;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Invoice", style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Text(data.date,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,),
                  Text(data.time,
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
                  style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,),
                Text(data.invoiceNo.toString(),
                  style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold
                  ),
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
                Text('Username:   ',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Text(data.username,
                  style: TextStyle(fontSize: 15,color: Colors.black),
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
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Text(data.useremail,
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Text('Address:   ',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Text(data.useraddress,
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Text('Product Name:   ',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Container(
                  // width: 150,
                  child: Text(data.productname,
                    style: TextStyle(fontSize: 15,color: Colors.black),
                    textAlign: TextAlign.left,),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Text('Product Quantity:   ',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Text(data.quantity.toString(),
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween,
              children: [
                Text('Product Amount:   ',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
                Text('Rs. ' + data.amount.toString()+' only',
                  style: TextStyle(fontSize: 15,color: Colors.black),
                  textAlign: TextAlign.left,),
              ],
            ),
            Divider(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: mongoDatabase.getpurchasableProduct(),
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
                        for(int index=1; index < totaldata; index++){
                          if(MongoDbPurchasableProducts.fromJson(snapshot.data[index]).id.$oid == data.productid){
                            if(MongoDbPurchasableProducts.fromJson(snapshot.data[index]).stock != ""){
                              int updatedstock = int.parse(MongoDbPurchasableProducts.fromJson(snapshot.data[index]).stock) - data.quantity;
                              return Column(
                                children: [
                                  if(userdata.role == "ShopKeeper")...[
                                    if(data.status == false)...[
                                      ElevatedButton(onPressed: (){
                                          _updateProduct(MongoDbPurchasableProducts.fromJson(snapshot.data[index]), updatedstock.toString());
                                          _orderconfirm(data, true, userdata);


                                      },
                                          child: Text('Dispatch'))
                                    ]
                                    else...[
                                      Text('Order Dispatched',
                                        style: TextStyle(fontSize: 15, color: Colors.green),
                                        textAlign: TextAlign.left,),
                                    ]
                                  ]
                                  else...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text('Status:   ',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.left,),
                                        if(data.status == false)...[
                                          Text('Order Not Yet Dispatched',
                                            style: TextStyle(fontSize: 15, color: Colors.red),
                                            textAlign: TextAlign.left,),
                                        ]
                                        else...[
                                          Text('Order Dispatched',
                                            style: TextStyle(fontSize: 15, color: Colors.green),
                                            textAlign: TextAlign.left,),
                                        ]
                                      ],
                                    ),
                                  ]
                                ],
                              );
                            }
                            else{
                              return Column(
                                children: [
                                  if(userdata.role == "ShopKeeper")...[
                                    if(data.status == false)...[
                                      ElevatedButton(onPressed: (){

                                          _orderconfirm(data, true, userdata);
                                      },
                                          child: Text('Dispatch'))
                                    ]
                                    else...[
                                      Text('Order Dispatched',
                                        style: TextStyle(fontSize: 15, color: Colors.green),
                                        textAlign: TextAlign.left,),
                                    ]
                                  ]
                                  else...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text('Status:   ',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.left,),
                                        if(data.status == false)...[
                                          Text('Order Not Yet Dispatched',
                                            style: TextStyle(fontSize: 15, color: Colors.red),
                                            textAlign: TextAlign.left,),
                                        ]
                                        else...[
                                          Text('Order Dispatched',
                                            style: TextStyle(fontSize: 15, color: Colors.green),
                                            textAlign: TextAlign.left,),
                                        ]
                                      ],
                                    ),
                                  ]
                                ],
                              );
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
    );
  }


  Future<void> _orderconfirm(MongoDbOrder data, bool _status, MongoDbModel userdata) async{
    final update_order = MongoDbOrder(id: data.id, invoiceNo: data.invoiceNo, productid: data.productid, userid: data.userid, productuserid: data.productuserid, username: data.username, useremail: data.useremail, useraddress: data.useraddress, productname: data.productname, quantity: data.quantity, amount: data.amount, date: data.date, time: data.time, status: _status);
    await mongoDatabase.confirmorder(update_order).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order Dispateched ")));

  }

  Future<void> _updateProduct(MongoDbPurchasableProducts data,  String _stock ) async {
    final update_product = MongoDbPurchasableProducts(id: data.id, userid: data.userid, productcategory: data.productcategory, image: data.image, productname: data.productname, productdescription: data.productdescription, productprice: data.productprice, saleprice: data.saleprice, onSale: data.onSale, islimited: data.islimited, stock: _stock, extrainformation: data.extrainformation, dateTime: data.dateTime, bagsize: data.bagsize, booktype: data.booktype, bookauthor: data.bookauthor, uniformSize: data.uniformSize, shoesSize: data.shoesSize, shoesType: data.shoesType, gender: data.gender, color: data.color);
    await mongoDatabase.updatepurchaseProduct(update_product);
  }

}
