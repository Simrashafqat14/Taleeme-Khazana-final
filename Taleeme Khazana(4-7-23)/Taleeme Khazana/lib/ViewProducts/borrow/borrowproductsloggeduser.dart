import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/ViewProducts/borrow/MakeaRequestBorrow.dart';

class BorrowLoggedInProducts extends StatefulWidget {
  final String id;
  const BorrowLoggedInProducts({Key? key, required this.id}) : super(key: key);

  @override
  State<BorrowLoggedInProducts> createState() => _BorrowLoggedInProductsState(id);
}

class _BorrowLoggedInProductsState extends State<BorrowLoggedInProducts> {
  String id;
  _BorrowLoggedInProductsState(this.id);
  @override
  Widget build(BuildContext context) {
    MongoDbBorrow requesteddata = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbBorrow;
    print(requesteddata.bookname);

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Your Products', style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 30,), textAlign: TextAlign.center,),

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
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              print(snapshot.data[index]);
                              return displayCard(MongoDbBorrow.fromJson(snapshot.data[index]), requesteddata); // Calling fuction passing data (from json) data into our model class
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
            ],
          ),
        ),
      ),
    );
  }

  Widget displayCard(MongoDbBorrow data, MongoDbBorrow requesteddata){
    Uint8List bytes = base64.decode(data.image);

    if(data.userid == id) {
        if(data.id.$oid != requesteddata.id.$oid){
          return Card(
            child: ListTile(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return makeARequestBorrowPage(id: id,category: 'Books',type: 'Borrow', productdata: data!, isproduct: true);
                    }, settings: RouteSettings(arguments: requesteddata),
                    ))
                    .then((value) {
                  setState(() {});
                });
              },
              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
              leading:  Column(
                children: [
                  if(data.image == "")...[
                    Image(
                      image: AssetImage(
                          'assets/product_default.jpg'),width: 70,height: 55,
                    ),
                  ]
                  else...[
                    data.image != null ? Image.memory(
                      bytes,
                      width: 70,
                      height: 55,
                      fit: BoxFit.cover,
                    ) : FlutterLogo(size: 70, ),
                  ],
                ],
              ),
              title: Text(data.bookname,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Borrow',
                style: TextStyle(color: Colors.black38,),
              ),
              trailing: Text('${data.condition}',
                style: TextStyle(color: Colors.amber,),
              ),
              //leading: Image.network(display_list[index].movie_poster_url!),
            ),
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
