import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;


class leaveAReiview extends StatefulWidget {
  final String id;
  const leaveAReiview({Key? key, required this.id}) : super(key: key);

  @override
  State<leaveAReiview> createState() => _leaveAReiviewState(id);
}

class _leaveAReiviewState extends State<leaveAReiview> {
  String id;
  _leaveAReiviewState(this.id);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data

  @override
  Widget build(BuildContext context) {
    MongoDbProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbProducts;
    var reviewController = new TextEditingController();
    var ratingController;
    var emailController = new TextEditingController();
    var nameController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Leave A Review", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.blueAccent, // <-- SEE HERE
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Leave a Review for ' + data.productname, style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,),textAlign: TextAlign.center,),
                    ),
                  ],),
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
                            initialRating: 0,
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
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            name: 'Email',
                            decoration: InputDecoration(
                                labelText: 'Enter Email'
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(),
                                FormBuilderValidators.email()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: nameController,
                            name: 'name',
                            decoration: InputDecoration(
                                labelText: 'Enter Name'
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState?.validate() == true){
                        _insertreview("", data.id.$oid, nameController.text,emailController.text, ratingController, reviewController.text, data);
                      }
                    } ,
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    child: Text('Submit'))
              ],
            )),
      ),
    );
  }
  Future<void> _insertreview(String _userid, String _productid, String _name, String _email, var _rating, String _comment, MongoDbProducts data) async {
    var _id = mongo.ObjectId();
    final review = Reviewmodel(id: _id, userid: _userid, productid: _productid, name: _name, email: _email, rating: _rating, comment: _comment);
    var result = await mongoDatabase.insertreview(review);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Review Sent")));
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) {
      return ViewProductPage(id: id, category: data.productcategory,type: data.productype,);}
        , settings: RouteSettings(arguments: data)));

  }
}

