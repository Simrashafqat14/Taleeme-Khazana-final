import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/ViewProducts/Requests/requestsubmission.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:intl/intl.dart';

class makeARequestPage extends StatefulWidget {
  final String id,category,type;
  final MongoDbProducts? productdata;
  final bool isproduct;
  const makeARequestPage({Key? key, required this.id,required this.category, required this.type, required this.productdata, required this.isproduct}) : super(key: key);

  @override
  State<makeARequestPage> createState() => _makeARequestPageState(id,category,type, productdata, isproduct);
}

class _makeARequestPageState extends State<makeARequestPage> {
  String _id,category,type;
  MongoDbProducts? productdata;
  bool isproduct;
  _makeARequestPageState(this._id, this.category,this.type, this.productdata, this.isproduct);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var nameController = new TextEditingController();
  var emailController = new TextEditingController();
  var addressController = new TextEditingController();
  var cityController = new TextEditingController();
  var noteController = new TextEditingController();
  var reasonController = new TextEditingController();
  var exchnagereasonController = new TextEditingController();
  var exchnageamountorproductController = new TextEditingController();
  var exchangeconditionController;
  var getexchnagereasonController = new TextEditingController();
  var getexchnageamountorproductController = new TextEditingController();
  var getexchangeconditionController;
  var exchangeSourceOption = ['Cash','Product'];


  bool showimage = false;
  File? _ImageFile;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  void _picBase64Image(ImageSource source) async {
    showimage= true;
    final XFile? image = await _picker.pickImage(source: source);
    if(image == null) return;

    compressFile(image);
  }
  void compressFile(XFile file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 20, percentage: 100);
    Uint8List imageByte = await compressedFile.readAsBytes();
    _base64Image = base64.encode(imageByte);
    print(_base64Image);
    Uint8List bytes = base64.decode(_base64Image);
    print(bytes);
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFile = compressedFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    MongoDbProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbProducts;
    print(_id + type);
    print(data.productname);
    Uint8List bytes = base64.decode(productdata!.image);
    getexchnagereasonController.text = productdata!.exchangereason;
    getexchnageamountorproductController.text = productdata!.productname;
    getexchangeconditionController = productdata!.productcondition;


    return Scaffold(
      appBar: AppBar(
        title: Text("Make A Request", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body:  SingleChildScrollView(
        child: Padding(padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Make a Request for ' + data.productname, style: TextStyle(color: Colors.black,
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
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            name: 'Email',
                            decoration: InputDecoration(
                                labelText: 'Enter Email'
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(),
                                  FormBuilderValidators.email()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: addressController,
                            name: 'Address',
                            decoration: InputDecoration(
                                labelText: 'Enter Address'
                            ),
                            keyboardType: TextInputType.streetAddress,
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                            FormBuilderTextField(
                              autovalidateMode:AutovalidateMode.onUserInteraction,
                              controller: reasonController,
                              maxLines: 3,
                              name: 'reason',
                              decoration: InputDecoration(
                                  labelText: 'Reason for accepting'
                              ),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()]),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          if(data.productype == "Exchange")...[
                            if(isproduct == false)...[
                              FormBuilderTextField(
                                autovalidateMode:AutovalidateMode.onUserInteraction,
                                controller: exchnagereasonController,
                                maxLines: 3,
                                name: 'reason',
                                decoration: InputDecoration(
                                    labelText: 'Reason for Exchange'
                                ),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if(data.exchangesource == "Cash") ...[
                                FormBuilderTextField(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  controller: exchnageamountorproductController,
                                  name: 'exchangeAmountorproduct',
                                  decoration: InputDecoration(
                                      labelText: 'Enter amount for exchange'
                                  ),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required()]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                              if(data.exchangesource == "Product") ...[
                                FormBuilderTextField(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  controller: exchnageamountorproductController,
                                  name: 'exchangeAmountorproduct',
                                  //initialValue: data.productname,
                                  decoration: InputDecoration(
                                      labelText: 'Enter Product for exchange'
                                  ),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required()]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () => _picBase64Image(ImageSource.gallery),
                                          child: Text("Upload Picture")
                                      ),
                                      TextButton(onPressed: (){
                                        setState(() {
                                          final imagepath_empty = null;
                                          _ImageFile = imagepath_empty;
                                          _base64Image = "";
                                          print('base64: '+_base64Image);
                                          showimage = !showimage;
                                        });
                                      },
                                        child: Text("Clear"),),
                                      ElevatedButton(
                                          onPressed: () => _picBase64Image(ImageSource.camera),
                                          child: Text("Take Picture")
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: showimage,
                                    child: _ImageFile == null ? FlutterLogo(size: 0,) :
                                    Image.file(
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        _ImageFile!),),
                                FormBuilderSlider(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  name: 'Condition',
                                  initialValue: 0.5,
                                  min: 0.0,
                                  max: 5.0,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.min(0.5),

                                  ]),
                                  divisions: 20,
                                  activeColor: Colors.blueAccent,
                                  inactiveColor: Colors.grey,
                                  decoration: InputDecoration(
                                      labelText: 'Select Condition (1-10)'
                                  ),
                                ),
                              ]
                            ]
                            else...[
                              FormBuilderTextField(
                                autovalidateMode:AutovalidateMode.onUserInteraction,
                                controller: getexchnagereasonController,
                                maxLines: 3,
                                name: 'reason',
                                decoration: InputDecoration(
                                    labelText: 'Reason for Exchange'
                                ),
                                validator: FormBuilderValidators.compose(
                                    [FormBuilderValidators.required()]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              if(data.exchangesource == "Cash") ...[
                                FormBuilderTextField(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  controller: getexchnageamountorproductController,
                                  name: 'exchangeAmountorproduct',
                                  decoration: InputDecoration(
                                      labelText: 'Enter amount for exchange'
                                  ),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required()]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                              if(data.exchangesource == "Product") ...[
                                FormBuilderTextField(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  controller: getexchnageamountorproductController,
                                  name: 'exchangeAmountorproduct',
                                  //initialValue: data.productname,
                                  decoration: InputDecoration(
                                      labelText: 'Enter Product for exchange'
                                  ),
                                  validator: FormBuilderValidators.compose(
                                      [FormBuilderValidators.required()]),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                  data.image != null ? Image.memory(
                                    bytes,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ) : FlutterLogo(size: 70, ),
                                FormBuilderSlider(
                                  autovalidateMode:AutovalidateMode.onUserInteraction,
                                  name: 'Condition',
                                  initialValue: getexchangeconditionController,
                                  min: 0.0,
                                  max: 5.0,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.min(0.5),

                                  ]),
                                  divisions: 20,
                                  activeColor: Colors.blueAccent,
                                  inactiveColor: Colors.grey,
                                  decoration: InputDecoration(
                                      labelText: 'Select Condition (1-10)'
                                  ),
                                ),
                              ]
                            ]
                          ],
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: cityController,
                            name: 'City',
                            decoration: InputDecoration(
                                labelText: 'Enter city'
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            autovalidateMode:AutovalidateMode.onUserInteraction,
                            controller: noteController,
                            name: 'note',
                            decoration: InputDecoration(
                                labelText: 'Enter Note(If Any)'
                            ),
                            // validator: FormBuilderValidators.compose(
                            //     [FormBuilderValidators.required()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                    onPressed: (){
                      print(_id + data.productcategory + data.productype);
                      if(_formKey.currentState?.validate() == true){
                        DateTime date = DateTime.now();
                        String formattedDate = DateFormat('d MMM EEE').format(date);
                        print(formattedDate);
                        DateTime time = DateTime.now();
                        String formattedtime = DateFormat('kk:mm:ss').format(time);
                        print(formattedtime);
                        if(isproduct == true){
                          exchangeconditionController = getexchangeconditionController;
                          exchnageamountorproductController.text = getexchnageamountorproductController.text;
                          exchnagereasonController.text = getexchnagereasonController.text;
                          _base64Image = productdata!.image;
                        }
                        exchangeconditionController = _formKey.currentState?.fields["Condition"]?.value;
                        _insertRequest(_base64Image,context, _id, data.id.$oid, formattedDate, formattedtime, type, nameController.text,
                            emailController.text, addressController.text, cityController.text, noteController.text, reasonController.text,
                        exchnagereasonController.text, exchnageamountorproductController.text, exchangeconditionController, data);
                        print(_id + data.productcategory + data.productype);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (BuildContext context) {
                          return ViewProductPage(id: _id, category: category,type: type,);}
                            , settings: RouteSettings(arguments: data)));
                      }
                    } ,
                    style: ElevatedButton.styleFrom(
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
}

Future<void> _insertRequest(String _image,BuildContext context,String _userid, String _productid,String _date, String _time, String _type, String _name, String _email, String _address, String _city, String _note, String _reason, String _exchnagereason, String _amountorproduct, var _condition, MongoDbProducts data) async {
  var _id = mongo.ObjectId();
  if(data.productype == "Donate"){
    final request = Requests(id: _id, userid: _userid, productid: _productid, date: _date, time: _time, requestype: _type, name: _name, email: _email, address: _address, city: _city, note: _note, reason: _reason, reasonexchnage: "", exchnageamountorproduct: "", exchangecondition: "", isaccepted: false, image: _image);
    var result = await mongoDatabase.insertRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Sent")));
  }
  if(data.productype == "Exchange"){
    final request = Requests(id: _id, userid: _userid, productid: _productid, date: _date, time: _time, requestype: _type, name: _name, email: _email, address: _address, city: _city, note: _note, reason: _reason, reasonexchnage: _exchnagereason, exchnageamountorproduct: _amountorproduct, exchangecondition: _condition, isaccepted: false, image: _image);
    var result = await mongoDatabase.insertRequest(request);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request Sent")));
  }

}
