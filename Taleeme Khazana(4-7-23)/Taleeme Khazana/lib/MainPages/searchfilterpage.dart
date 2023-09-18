import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fyp_project/MainPages/filterpage.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/ViewProducts/ViewPurchaseProductPage.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';

class FilterSearchPage extends StatefulWidget {
  final String id, type, category, filter;
  const FilterSearchPage({Key? key, required this.id, required this.type, required this.category, required this.filter}) : super(key: key);

  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState(id, type, category, filter);
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  String userid, type, category, filter;
  _FilterSearchPageState(this.userid, this.type, this.category, this.filter);
  var searchWord = new TextEditingController();
  void updateList(String value, String type, String filter){
    if(type == 'Borrow'){
      setState(() {
        mongoDatabase.filterBorrowProducts(value, filter);
      });
    }
    if(type == 'Purchase'){
      setState(() {
        mongoDatabase.filterpuchaseProducts(value, filter, category);
      });
    }
    else{
      setState(() {
        mongoDatabase.filterProducts(searchWord.text, type , filter ,category);
      });
    }
  }


  void clearSearch(String Value){
    setState(() {
      Value = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Anything"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return filterpageselect(id: userid,);
                    })
                );
              }, child: Row(
                children: [
                  Text('Filter',style: TextStyle(fontSize: 15),),
                  Icon(Icons.filter_alt_rounded)
                ],
              ),)
            ],
          ),
          if(type == "Borrow")...[
            Container(
              child: Flexible(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          // onChanged: (value) {
                          //   updateList(value);
                          //   searchWord = value;
                          // },
                          controller: searchWord,
                          name: "search",
                          style: TextStyle(color: Colors.black),
                          onChanged: (value){
                            updateList(value!, 'Borrow',  filter);
                          },
                          decoration: InputDecoration(
                              hintText: "eg: Product Name",
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.purple.shade900,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  searchWord.clear();
                                },
                                icon: const Icon(Icons.close_sharp),
                              )
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FutureBuilder(
                                future: mongoDatabase.filterBorrowProducts(searchWord.text, filter),
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
                                      TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      ): ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) => Card(
                                          child:
                                          ListTile(
                                            onTap: (){
                                              // Navigator.push(context,
                                              //     MaterialPageRoute(builder: (BuildContext context) {
                                              //       return PurchaseProductPage(id: userid, category: MongoDbPurchasableProducts.fromJson(snapshot.data[index]).productcategory,);
                                              //     }, settings: RouteSettings(arguments: MongoDbPurchasableProducts.fromJson(snapshot.data[index]))))
                                              //     .then((value) {setState(() {});
                                              // });
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                    return ViewBorrowProduct(id: userid);
                                                  }, settings: RouteSettings(arguments: MongoDbBorrow.fromJson(snapshot.data[index]))))
                                                  .then((value) {setState(() {});
                                              });
                                            },
                                            contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                                            title: Text(MongoDbBorrow.fromJson(snapshot.data[index]).bookname,
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text('${MongoDbBorrow.fromJson(snapshot.data[index]).authorname}',
                                              style: TextStyle(color: Colors.black38,),
                                            ),
                                            trailing:Text('${MongoDbBorrow.fromJson(snapshot.data[index]).condition}',
                                              style: TextStyle(color: Colors.black38,),
                                            ),

                                            //leading: Image.network(display_list[index].movie_poster_url!),
                                          ),
                                        ),
                                      );
                                    }else {
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
                  ),
                ),
              ),
            ),
          ],
          if(type == "Purchase")...[
            Container(
              child: Flexible(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          // onChanged: (value) {
                          //   updateList(value);
                          //   searchWord = value;
                          // },
                          controller: searchWord,
                          name: "search",
                          style: TextStyle(color: Colors.black),
                          onChanged: (value){
                            updateList(value!, 'Purchase', filter);
                          },
                          decoration: InputDecoration(
                              hintText: "eg: Product Name",
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.purple.shade900,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  searchWord.clear();
                                },
                                icon: const Icon(Icons.close_sharp),
                              )
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FutureBuilder(
                                future: mongoDatabase.filterpuchaseProducts(searchWord.text, filter, category),
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
                                      TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      ): ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) => Card(
                                          child:
                                          ListTile(
                                              onTap: (){
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                      return PurchaseProductPage(id: userid, category: MongoDbPurchasableProducts.fromJson(snapshot.data[index]).productcategory,);
                                                    }, settings: RouteSettings(arguments: MongoDbPurchasableProducts.fromJson(snapshot.data[index]))))
                                                    .then((value) {setState(() {});
                                                });
                                              },
                                              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                                              title: Text(MongoDbPurchasableProducts.fromJson(snapshot.data[index]).productname,
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if(category == "Books")...[
                                                    Text('${MongoDbPurchasableProducts
                                                        .fromJson(
                                                        snapshot.data[index])
                                                        .bookauthor}',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .black38,),)
                                                  ],
                                                  if(category == "Uniforms")...[
                                                    Text('${MongoDbPurchasableProducts
                                                        .fromJson(
                                                        snapshot.data[index])
                                                        .gender}',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .black38,),)
                                                  ]

                                                ],
                                              ),
                                              trailing:Column(
                                                children: [
                                                  if(MongoDbPurchasableProducts.fromJson(snapshot.data[index]).onSale == true)...[
                                                    Text('Onsale',
                                                      style: TextStyle(color: Colors.black),),
                                                  ]
                                                  else...[
                                                    Text('Rs/-'+MongoDbPurchasableProducts.fromJson(snapshot.data[index]).productprice,
                                                      style: TextStyle(color: Colors.black),),

                                                  ]
                                                ],
                                              )

                                            //leading: Image.network(display_list[index].movie_poster_url!),
                                          ),
                                        ),
                                      );
                                    }else {
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
                  ),
                ),
              ),
            ),
          ]
          else...[
            Container(
              child: Flexible(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBuilderTextField(
                          // onChanged: (value) {
                          //   updateList(value);
                          //   searchWord = value;
                          // },
                          controller: searchWord,
                          name: "search",
                          style: TextStyle(color: Colors.black),
                          onChanged: (value){
                            updateList(value!, type, filter);
                          },
                          decoration: InputDecoration(
                              hintText: "eg: Product Name",
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.purple.shade900,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  searchWord.clear();
                                },
                                icon: const Icon(Icons.close_sharp),
                              )
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FutureBuilder(
                                future: mongoDatabase.filterProducts(searchWord.text, type , filter ,category),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(child:
                                    CircularProgressIndicator(),
                                    );
                                  } else {
                                    if (snapshot.hasData) {
                                      var totaldata = snapshot.data.length;
                                      print("Total data: " +
                                          totaldata.toString());
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
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (
                                                              BuildContext context) {
                                                            return ViewProductPage(
                                                              id: userid,
                                                              type: MongoDbProducts
                                                                  .fromJson(
                                                                  snapshot
                                                                      .data[index])
                                                                  .productype,
                                                              category: MongoDbProducts
                                                                  .fromJson(
                                                                  snapshot
                                                                      .data[index])
                                                                  .productcategory,);
                                                          },
                                                          settings: RouteSettings(
                                                              arguments: MongoDbProducts
                                                                  .fromJson(
                                                                  snapshot
                                                                      .data[index]))))
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                contentPadding: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: 10,
                                                    right: 10),
                                                title: Text(MongoDbProducts
                                                    .fromJson(
                                                    snapshot.data[index])
                                                    .productname,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if(category == "Books")...[
                                                      Text('${MongoDbProducts
                                                          .fromJson(
                                                          snapshot.data[index])
                                                          .authorname}',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .black38,),)
                                                    ],
                                                    if(category == "Uniforms" || category == "Shoes")...[
                                                      Text('${MongoDbProducts
                                                          .fromJson(
                                                          snapshot.data[index])
                                                          .gender}',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .black38,),)
                                                    ],
                                                  ],
                                                ),
                                                trailing:Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if(category == "Books")...[
                                                      Text(
                                                        '${MongoDbProducts
                                                            .fromJson(
                                                            snapshot.data[index])
                                                            .productcondition}',
                                                        style: TextStyle(
                                                          color: Colors.amber,),
                                                      ),
                                                    ],
                                                    if(category == "Uniforms")...[
                                                      Text(
                                                        '${MongoDbProducts
                                                            .fromJson(
                                                            snapshot.data[index])
                                                            .uniformSize}',
                                                        style: TextStyle(
                                                          color: Colors.amber,),
                                                      ),
                                                    ],
                                                    if(category == "Shoes")...[
                                                      Text('${MongoDbProducts
                                                          .fromJson(
                                                          snapshot.data[index])
                                                          .shoesSize}',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .black38,),)
                                                    ]
                                                  ],
                                                )
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
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
