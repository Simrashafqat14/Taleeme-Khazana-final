import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';

class viewborrowproductdata extends StatefulWidget {
  const viewborrowproductdata({Key? key}) : super(key: key);

  @override
  State<viewborrowproductdata> createState() => _viewborrowproductdataState();
}

class _viewborrowproductdataState extends State<viewborrowproductdata> {
  @override
  Widget build(BuildContext context) {
    MongoDbBorrow data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbBorrow;
    Uint8List bytes = base64.decode(data.image);
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
                    child: Text(data.bookname.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 30,),),
                  ),
                  IconButton(onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (BuildContext context) {
                    //       return productUpdatePage(
                    //           type: type, category: category);
                    //     }, settings: RouteSettings(arguments: data)))
                    //     .then((value) {
                    //   setState(() {});
                    // }); // setstate to update list of data
                    //print(category);
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
                      Text('Description:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Expanded(
                        child: Text(data.description, style:
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
                      Text('Author Name:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.authorname, style:
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
                      Text('Book Edition:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.bookwdition, style:
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
                      Text('Condition:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      RatingBarIndicator(
                        rating: data.condition,
                        itemCount: 5,
                        itemSize: 30,
                        itemBuilder: (context, _) =>
                            Icon(
                              Icons.star,
                              color: Colors.amber,),),
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
                      Text('Max Borrow Days:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.maxnoofdays, style:
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
                      Text('Extra Information:   ', style:
                      TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,
                        fontSize: 18,), textAlign: TextAlign.left,),
                      Text(data.extrainformation, style:
                      TextStyle(color: Colors.black,
                        fontSize: 15,), textAlign: TextAlign.left,),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
