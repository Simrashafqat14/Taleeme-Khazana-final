import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/UploadProduct/updateproduct.dart';


class productViewPage extends StatefulWidget {
  final String category,type;
  const productViewPage({Key? key, required this.category, required this.type}) : super(key: key);

  @override
  State<productViewPage> createState() => _productViewPageState(category, type);
}

class _productViewPageState extends State<productViewPage> {
  String category, type;
  _productViewPageState(this.category, this.type);
  var productnameController = new TextEditingController();
  Widget donateFields = Container();
  Widget exchangeFields = Container();
  var container;


  @override
  Widget build(BuildContext context) {
    MongoDbProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbProducts;
    productnameController.text = data.productname;
    Uint8List bytes = base64.decode(data.image);

    if(type == "Donate"){
      donateFields = Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Other Details:   ',style:
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
        ],
      );}

    if(type == "Exchange"){
      exchangeFields = Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Exchange Reason:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Expanded(
                    child: Text(data.exchangereason,style:
                    TextStyle(color: Colors.black,
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ),
                ],
              ),
            ),
          ),
          if(data.isgrouped == true)...[
            SizedBox(
              height: 30,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Quantity:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.quantityofGroupedProducts,style:
                    TextStyle(color: Colors.black,
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Exchange Source   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.exchangesource,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (data.exchangesource == "Cash") ...[
            container =  Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Exchange Amount:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.requiredamountorproduct,style:
                    TextStyle(color: Colors.black,
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ],
                ),
              ),
            ),
          ]
          else ...[
            container =  Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Exchange Product:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.requiredamountorproduct,style:
                    TextStyle(color: Colors.black,
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ],
                ),
              ),
            ),
          ]
        ],
      );}

    Widget uniformfields =  Column(
        children: [
          if(category == "Uniforms")...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('School Name:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.schoolname,style:
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
                    Text('Uniform Size:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.uniformSize,style:
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
            SizedBox(
              height: 10,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Color:   ',style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                      fontSize: 18,), textAlign: TextAlign.left,),
                    Text(data.color,style:
                    TextStyle(color: Colors.black,
                      fontSize: 15,), textAlign: TextAlign.left,),
                  ],
                ),
              ),
            ),
          ]
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
                  Expanded(
                    child: Text(data.authorname,style:
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
                  Text('Subject:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.booksubject,style:
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
                  Text('Grade:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.grade,style:
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
                  Text('No of Pages:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.noofpages,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
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
                children: [
                  Text('Shoe Size:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.shoesSize,style:
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
          SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Shoe Style:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.shoesstyle,style:
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
                  Text('Color:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.color,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
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
                children: [
                  Text('Color:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.color,style:
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
                  Text('Grade:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.grade,style:
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
                  Text('Bag Type:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.bagtype,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
        ]
      ],
    );

    Widget StationaryFields = Column(
      children: [
        if(category == "Stationary")...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('No of items:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.noofitemsstationary,style:
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
                  Text('Stationary Name:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.stationaryname,style:
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
                  Text('Color:   ',style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                    fontSize: 18,), textAlign: TextAlign.left,),
                  Text(data.color,style:
                  TextStyle(color: Colors.black,
                    fontSize: 15,), textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
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
                          return productUpdatePage(type: type, category: category);
                        },settings: RouteSettings(arguments: data)))
                        .then((value) {setState(() {});}); // setstate to update list of data
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
                      Text('Type:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.productype,style:
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
                  child: Column(
                    children: [
                      Text('Condition:   ',style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      RatingBarIndicator(
                        rating: data.productcondition,
                        itemCount: 5,
                        itemSize: 30,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,),),
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
              StationaryFields,
              SizedBox(
                height: 10,
              ),
              donateFields,
              exchangeFields,
            ],
          ),
        ),
      ),
    );
  }

}
