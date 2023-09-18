import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MainPages/searchfilterpage.dart';

class filterpageselect extends StatefulWidget {
  final String id;
  const filterpageselect({Key? key, required this.id}) : super(key: key);

  @override
  State<filterpageselect> createState() => _filterpageselectState(id);
}

class _filterpageselectState extends State<filterpageselect> {
  String userid;
  _filterpageselectState(this.userid);
  final _formKey = GlobalKey<
      FormBuilderState>(); // View, modify, validate form data
  var categoryOptions = ['Books', 'Uniforms', 'Shoes'];
  var borrowcategoryOptions = ['Books'];
  var productcategoryController;
  var TypeOptions = ['Exchange', 'Purchase', 'Donate', 'Borrow'];
  var producttypeController;
  var BookOptions = ['Author Name'];
  var uniformoptions = ['Uniform Size', 'Gender'];
  var shoeoptions = ['Shoe Size', 'Gender'];
  var productfilterController;
  bool showbook = false;
  bool showuniform = false;
  bool showbag = false;
  bool showshoes = false;
  bool showstationary = false;
  bool Showdata = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Search Anything"),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Text('Filter Products',
                  style: TextStyle(fontSize: 25,
                      color: Colors.blue),textAlign: TextAlign.center,),
                FormBuilderDropdown(
                    name: 'type',
                    decoration: InputDecoration(
                      labelText: 'Select Type',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    //allowClear: true,
                    items: TypeOptions.map((type) =>
                        DropdownMenuItem(value: type, child: Text(
                            '$type'))
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        producttypeController = value;
                      });
                    }
                ),
                if(producttypeController == "Borrow")...[
                  FormBuilderDropdown(
                      name: 'Category',
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      //allowClear: true,
                      items: borrowcategoryOptions.map((category) =>
                          DropdownMenuItem(value: category, child: Text(
                              '$category'))
                      ).toList(),
                      onChanged: (value) {
                        productcategoryController = value;
                        if(productcategoryController == "Books"){
                          setState(() {
                            showbook = true;
                            showbag = false;
                            showshoes = false;
                            showuniform = false;
                            showstationary = false;

                          });
                        }

                      }
                  ),
                ]

                else...[
                  FormBuilderDropdown(
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
                        if(productcategoryController == "Books"){
                          setState(() {
                            showbook = true;
                            showbag = false;
                            showshoes = false;
                            showuniform = false;
                            showstationary = false;

                          });
                        }
                        if(productcategoryController == "Uniforms"){
                          setState(() {
                            showbook = false;
                            showbag = false;
                            showshoes = false;
                            showuniform = true;
                            showstationary = false;
                          });
                        }
                        if(productcategoryController == "Shoes"){
                          setState(() {
                            showbook = false;
                            showbag = false;
                            showshoes = true;
                            showuniform = false;
                            showstationary = false;
                          });
                        }

                      }
                  ),
                ],
                Visibility(
                  visible: showbook,
                  child: FormBuilderDropdown(
                      name: 'book',
                      decoration: InputDecoration(
                        labelText: 'Select Book Filter',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      //allowClear: true,
                      items: BookOptions.map((book) =>
                          DropdownMenuItem(value: book, child: Text(
                              '$book'))
                      ).toList(),
                      onChanged: (value) {
                        productfilterController = value;
                      }
                  ),),
                Visibility(
                  visible: showuniform,
                  child: FormBuilderDropdown(
                      name: 'uniform',
                      decoration: InputDecoration(
                        labelText: 'Select Uniform Filter',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      //allowClear: true,
                      items: uniformoptions.map((uniform) =>
                          DropdownMenuItem(value: uniform, child: Text(
                              '$uniform'))
                      ).toList(),
                      onChanged: (value) {
                        productfilterController = value;
                      }
                  ),),
                Visibility(
                  visible: showshoes,
                  child: FormBuilderDropdown(
                      name: 'shoe',
                      decoration: InputDecoration(
                        labelText: 'Select Uniform Filter',
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      //allowClear: true,
                      items: shoeoptions.map((shoes) =>
                          DropdownMenuItem(value: shoes, child: Text(
                              '$shoes'))
                      ).toList(),
                      onChanged: (value) {
                        productfilterController = value;
                      }
                  ),),
                TextButton(onPressed: () {
                  print(producttypeController);
                  print(productcategoryController);
                  if(producttypeController != null && productcategoryController != null){
                    if(showbook == true || showuniform == true || showshoes == true){
                      if(productfilterController != null){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Products Filtered ")));
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return FilterSearchPage(id: userid, type: producttypeController, category: productcategoryController, filter: productfilterController,);
                            })
                        );
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Fill filter details ")));
                      }
                    }
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fill filter details ")));
                  }
                }, child: Text("Filter")),

                Visibility(
                    visible: Showdata,
                    child: Text('Data')),

              ],
            ),
          ),
        ),
      ],
    ),
    );
  }
}
