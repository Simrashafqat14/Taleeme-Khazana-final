import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/PurchaseModule/BecomeAShopkeeper.dart';
import 'package:fyp_project/PurchaseModule/uploadproduct/upload.dart';
import 'package:fyp_project/UploadProduct/Forms/bagForm.dart';
import 'package:fyp_project/UploadProduct/Forms/bookForm.dart';
import 'package:fyp_project/UploadProduct/Forms/shoesForm.dart';
import 'package:fyp_project/UploadProduct/Forms/stationatyForm.dart';
import 'package:fyp_project/UploadProduct/Forms/uniformForm.dart';
import 'package:fyp_project/UploadProduct/userProductHistoryCategories.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:fyp_project/MainPages/serachPage.dart';

import '../MainPages/NavigationDrawer.dart';

class uploadPurchasePage extends StatefulWidget {
  final String id, type;
  const uploadPurchasePage({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  State<uploadPurchasePage> createState() => _uploadPurchasePageState(id, type);
}

class _uploadPurchasePageState extends State<uploadPurchasePage> {
  String id, type;
  _uploadPurchasePageState(this.id, this.type);
  final _formKey = GlobalKey<
      FormBuilderState>(); // View, modify, validate form data
  var categoryOptions = ['Books', 'Uniforms', 'Shoes', 'Bags', 'Stationary'];
  var productcategoryController;
  Widget Heading = Container();

  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    print("role: "+data.role);
    print(type);
    if(data.role == "ShopKeeper") {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 50, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('Upload Product', style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,), textAlign: TextAlign.center,),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderDropdown(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        name: 'Category',
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                        //allowClear: true,
                        items: categoryOptions.map((category) =>
                            DropdownMenuItem(value: category, child: Text(
                                '$category'))
                        ).toList(),
                        onChanged: (value) {
                          productcategoryController = value;
                          if (_formKey.currentState?.validate() == true) {
                            productcategoryController =
                                _formKey.currentState?.fields["Category"]
                                    ?.value;
                            print("Category:" +
                                productcategoryController.toString());

                            if (productcategoryController == "Uniforms") {
                              print(id + type);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return purchaseUploadProduct(
                                      id: id, category: "Uniforms",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                              productcategoryController = "";
                            }
                            if (productcategoryController == "Books") {
                              print(id);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return purchaseUploadProduct(
                                      id: id, category: "Books",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                            if (productcategoryController == "Stationary") {
                              print(id);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return purchaseUploadProduct(
                                      id: id, category: "Stationary",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                            if (productcategoryController == "Shoes") {
                              print(id);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return purchaseUploadProduct(
                                      id: id, category: "Shoes",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                            if (productcategoryController == "Bags") {
                              print(id);
                              Navigator.push(
                                  context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return purchaseUploadProduct(
                                      id: id, category: "Bags",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('OR', style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,), textAlign: TextAlign.center,),
                      SizedBox(
                        height: 20,
                      ),

                      ElevatedButton(onPressed: () {
                        print(id);
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UserProductHistory(id: id, type: type,);
                            }));
                      },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 30, left: 30),
                            child: Text('View Donation History', style: TextStyle(
                                fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,),
                          )
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Upgrate You Account to Shopkeeper to sell products', style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 30,), textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context){
                      return becomeShopKeeperConversion();
                    },settings: RouteSettings(arguments: data)))
                    .then((value) {setState(() {});});
              },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Upgrade Now'),
                      Icon(Icons.keyboard_double_arrow_right),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
