import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/PurchaseModule/updatepurchaseproduct.dart';

class purchaseproductViewPage extends StatefulWidget {
  final String category,type;
  const purchaseproductViewPage({Key? key, required this.category, required this.type}) : super(key: key);

  @override
  State<purchaseproductViewPage> createState() => _purchaseproductViewPageState(category, type);
}

class _purchaseproductViewPageState extends State<purchaseproductViewPage> {
  String category, type;
  _purchaseproductViewPageState(this.category, this.type);
  var productnameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    MongoDbPurchasableProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbPurchasableProducts;
    productnameController.text = data.productname;
    Uint8List bytes = base64.decode(data.image);

    Widget sizechartbutton = ElevatedButton(
        onPressed: (){
          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('SIZE CHART'),
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

    Widget innerChangingFields = Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Color:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
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
                      Icon(Icons.circle, color: Color(int.parse(data.color)), ),
                    )
                ),
              ],
            ),
          ),
        ),
        if(category != "Stationary")...[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Gender:   ',style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                  fontSize: 18,), textAlign: TextAlign.left,),
                Text(data.gender,style:
                TextStyle(color: Colors.black,
                  fontSize: 15,), textAlign: TextAlign.left,),
              ],
            ),
          ),
        ),
        ]
      ],
    );

    Widget uniformfields =  Column(
      children: [
        if(category == "Uniforms")...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Uniform Size:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.uniformSize,style:
                      TextStyle(color: Colors.black,
                        fontSize: 15,), textAlign: TextAlign.left,),
                    ],
                  ),
                  sizechartbutton
                ],
              ),
            ),
          ),
          innerChangingFields
        ],
    ],
    );

    Widget BooksFields = Column(
      children: [
        if(category == "Books")...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Author Name:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.bookauthor,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Book Type:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.booktype,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
        ]
      ],
    );


    Widget ShoesFields = Column(
      children: [
        if(category == "Shoes")...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Shoe Size:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.shoesSize,style:
                      TextStyle(color: Colors.black,
                        fontSize: 15,), textAlign: TextAlign.left,),
                    ],
                  ),
                  sizechartbutton
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Shoes Type:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.shoesType,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
          innerChangingFields
        ]
      ],
    );

    Widget BagsFields = Column(
      children: [
        if(category == "Bags")...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Bag Size:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.bagsize,style:
                      TextStyle(color: Colors.black,
                        fontSize: 15,), textAlign: TextAlign.left,),
                    ],
                  ),
                  sizechartbutton
                ],
              ),
            ),
          ),
          innerChangingFields
        ]
      ],
    );

    Widget stationaryFields = Column(
      children: [
        if(category == "Stationary")...[
          innerChangingFields
        ]
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("View Products", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250,
                    child: Text(productnameController.text.toUpperCase(),
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                        fontSize: 30,),),
                  ),
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context){
                          return purchaseproductUpdatePage(category: category, type: type);
                        },settings: RouteSettings(arguments: data)))
                        .then((value) {setState(() {});});
                    print(category);
                  }, icon: Icon(Icons.edit)),
                ],
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
              //Image.network(data.image),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Description:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.productdescription,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Category:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.productcategory,style:
                      TextStyle(color: Colors.black,
                        fontSize: 15,), textAlign: TextAlign.left,),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Price:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      if(data.onSale == true)...[
                        Row(
                          children: [
                            Center(
                              child: Container(
                                child: Text('Rs/-'+data.productprice,
                                  style: TextStyle(color: Colors.black),),
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/linethrough.png'), fit: BoxFit.fitWidth),
                                ),
                              ),
                            ),
                            SizedBox(width: 30,),
                            Text('Rs/-'+data.saleprice,
                              style: TextStyle(color: Colors.black),),
                          ],
                        )
                      ]
                      else...[
                        Text('Rs/-'+data.productprice,
                          style: TextStyle(color: Colors.black),),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Stock:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      if(data.islimited == true)...[
                        Text(data.stock,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ]
                      else...[
                        Text('Unlimited',style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ]

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Extra Information:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.extrainformation,style:
                        TextStyle(color: Colors.black,
                          fontSize: 15,), textAlign: TextAlign.left,),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              uniformfields,
              BooksFields,
              ShoesFields,
              BagsFields,
              stationaryFields
            ],
          ),
        ),
      ),
    );
  }
}
