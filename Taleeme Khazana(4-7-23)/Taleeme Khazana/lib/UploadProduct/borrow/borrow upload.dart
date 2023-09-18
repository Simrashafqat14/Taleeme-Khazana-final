import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/UploadProduct/Forms/bagForm.dart';
import 'package:fyp_project/UploadProduct/Forms/bookForm.dart';
import 'package:fyp_project/UploadProduct/Forms/shoesForm.dart';
import 'package:fyp_project/UploadProduct/Forms/stationatyForm.dart';
import 'package:fyp_project/UploadProduct/Forms/uniformForm.dart';
import 'package:fyp_project/UploadProduct/borrow/borrowforms.dart';
import 'package:fyp_project/UploadProduct/borrow/viewborrowproduct.dart';
import 'package:fyp_project/UploadProduct/userProductHistoryCategories.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:fyp_project/MainPages/serachPage.dart';


class UploadborrowPage extends StatefulWidget {
  final String id, type;
  final bool isGrouped;
  const UploadborrowPage({Key? key, required this.id, required this.type, required this.isGrouped}) : super(key: key);

  @override
  State<UploadborrowPage> createState() => _UploadborrowPageState(id, type, isGrouped);
}

class _UploadborrowPageState extends State<UploadborrowPage> {
  String id, type;
  bool isGrouped;

  _UploadborrowPageState(this.id, this.type, this.isGrouped);

  final _formKey = GlobalKey<
      FormBuilderState>(); // View, modify, validate form data
  var categoryOptions = ['Books'];
  var productcategoryController;
  Widget Heading = Container();

  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbModel;

    print(type);
    if (type == "Borrow") {
      Heading = Text('Upload an item for borrowing', style: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 30,), textAlign: TextAlign.center,);
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
                  }
              )
              );
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
                    Heading,
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

                          if (productcategoryController == "Books") {
                            print(id);
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return borrowformsforproducts(
                                    id: id, type: type, category: productcategoryController,);
                                }, settings: RouteSettings(arguments: data)))
                                .then((value) => setState(() {}));
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

                    if (type == "Borrow") ...[
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
                            child: Text('Borrow History', style: TextStyle(
                                fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,),
                          )
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
