import 'package:flutter/material.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/PurchaseModule/discount/insertvoucher.dart';

import '../../DBHelper/mongoDB.dart';
import '../../MongoDBModels/discountvoucher.dart';

class ViewdiscountVouchers extends StatefulWidget {
  final String id;
  const ViewdiscountVouchers({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewdiscountVouchers> createState() => _ViewdiscountVouchersState(id);
}

class _ViewdiscountVouchersState extends State<ViewdiscountVouchers> {
  String userid;

  _ViewdiscountVouchersState(this.userid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search here',),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CustomSearchDelegate(id: userid,);
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
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Vouchers',
                    style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 30,), textAlign: TextAlign.center,),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return insertdiscountvoucherpage(id: userid,);
                        })
                    );
                  },
                    icon: Icon(
                      Icons.add_box_outlined, size: 40, color: Colors.blue,),)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Flexible(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FutureBuilder(
                      future: mongoDatabase.getdiscountvouchersbyid(userid),
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
                            return snapshot.data.length == 0 ?
                            Center(child:
                            Text("No Results Found", style:
                            TextStyle(color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            ),
                            ) : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) =>
                                  Card(
                                    child:
                                    ListTile(
                                      onTap: () {

                                      },
                                      contentPadding: EdgeInsets.only(top: 0,
                                          bottom: 0,
                                          left: 10,
                                          right: 10),
                                      title: Text(Mongodbdiscount
                                          .fromJson(snapshot.data[index])
                                          .name,
                                        style: TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if(Mongodbdiscount
                                              .fromJson(snapshot.data[index])
                                              .type == false)...[
                                            Text('Amount', style: TextStyle(
                                              color: Colors.black38,),)
                                          ]
                                          else
                                            ...[
                                              Text('Percentage',
                                                style: TextStyle(
                                                  color: Colors.black38,),)
                                            ]
                                        ],
                                      ),
                                      trailing: Text('Rs/-' + Mongodbdiscount
                                          .fromJson(snapshot.data[index])
                                          .amount,
                                        style: TextStyle(color: Colors.black),),
                                      leading: IconButton(onPressed: () async {
                                        await mongoDatabase
                                            .deletediscountvoucher(
                                            Mongodbdiscount.fromJson(
                                                snapshot.data[index]));
                                        setState(() {

                                        });
                                      }, icon: Icon(Icons.delete, size: 25,)),

                                      //leading: Image.network(display_list[index].movie_poster_url!),
                                    ),
                                  ),
                            );
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
              ),
            ],
          ),
        )
    );
  }
}
