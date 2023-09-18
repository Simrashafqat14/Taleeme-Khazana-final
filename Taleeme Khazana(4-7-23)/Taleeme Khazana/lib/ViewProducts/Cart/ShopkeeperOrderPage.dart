import 'package:flutter/material.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/ordermodel.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/ViewProducts/Cart/vieworder.dart';

class shopkeeperorderpage extends StatefulWidget {
  final String id;
  const shopkeeperorderpage({Key? key, required this.id}) : super(key: key);

  @override
  State<shopkeeperorderpage> createState() => _shopkeeperorderpageState(id);
}

class _shopkeeperorderpageState extends State<shopkeeperorderpage> {
  String id;
  _shopkeeperorderpageState(this.id);
  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Requests", style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ), onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context){
                      return MyDashboard(id: data.id.$oid);
                    },settings: RouteSettings(arguments: data)))
                    .then((value) => setState(() {}));
              },
              ),
              bottom: const TabBar(
                  tabs: [
                    Tab(icon: Text('Pending', style: TextStyle(color: Colors.black, fontSize: 20),)),
                    Tab(icon: Text('Accepted', style: TextStyle(color: Colors.black, fontSize: 20),)),
                  ]),
            ),
            body: TabBarView(
              children: [
                Container(
                  child: getUseOrders(data, false),
                ),
                Container(
                  child: getUseOrders(data, true),
                )
              ],
            )
        ),
      ),
    );
  }
  Widget getUseOrders(MongoDbModel userdata, bool status){
    return SafeArea(
      child: FutureBuilder(
        future: mongoDatabase.getordersbystatusandproductuserid(status, id),
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
                    return displayorders(MongoDbOrder.fromJson(snapshot.data[index]), userdata); // Calling fuction passing data (from json) data into our model class
                  });
            }else{
              return Center(
                child: Text("No Data Available."),
              );
            }
          }
        },
      ),
    );
  }

  Widget displayorders(MongoDbOrder data, MongoDbModel userdata){
    return Column(
      children: [
        Card(
            child: Padding(
              padding: const EdgeInsets.only(top: 15,bottom: 15, left: 20, right: 10),
              child: Row(
                children: [
                  Container(
                    width: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invoice No:    ' + data.invoiceNo.toString(),
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text: "'Name:    ${data.productname}".toUpperCase()),
                          textAlign: TextAlign.left,
                        ),
                        Text('Quanity:    ' + data.quantity.toString(),
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,),
                        Text('Price:    ' + data.amount.toString(),
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(data.date + ' at ' + data.time,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,),
                        ],
                      ),
                      IconButton(
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return OrderViewPage(userdata: userdata, id: id,);
                                    },
                                    settings: RouteSettings(
                                        arguments: data)))
                                .then((value) => setState(() {}));
                          },
                          icon: Icon(Icons.remove_red_eye_outlined)),
                    ],
                  )
                ],
              ),
            )
        )
      ],
    );
  }
}
