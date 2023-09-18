import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/ViewProducts/borrow/viewborrowproduct.dart';
import 'package:fyp_project/ViewProducts/productPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../../MongoDBModels/borrowrequests.dart';

class makeARequestBorrowPage extends StatefulWidget {
  final String id,category,type;
  final MongoDbBorrow? productdata;
  final bool isproduct;
  const makeARequestBorrowPage({Key? key, required this.id,required this.category, required this.type, required this.productdata, required this.isproduct}) : super(key: key);

  @override
  State<makeARequestBorrowPage> createState() => _makeARequestBorrowPageState(id,category,type, productdata, isproduct);
}

class _makeARequestBorrowPageState extends State<makeARequestBorrowPage> {
  String _id,category,type;
  MongoDbBorrow? productdata;
  bool isproduct;
  _makeARequestBorrowPageState(this._id, this.category,this.type, this.productdata, this.isproduct);
  final _formKey = GlobalKey<FormBuilderState>();
  var nameController = new TextEditingController();
  var emailController = new TextEditingController();
  var addressController = new TextEditingController();
  var cityController = new TextEditingController();
  var noteController = new TextEditingController();
  var daterangecontroller = new TextEditingController();

  var borrowedproductname = new TextEditingController();
  var conditionController;
  var bookeditiomController = new TextEditingController();
  var authornameController = new TextEditingController();
  var getconditioncontroller;

  var getbooknameController = new TextEditingController();
  var getauthornameController = new TextEditingController();
  var getbookeditionController = new TextEditingController();


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
    MongoDbBorrow data = ModalRoute
        .of(context)!
        .settings
        .arguments as MongoDbBorrow;
    print(_id + type);
    print(data.bookname);
    Uint8List bytes = base64.decode(productdata!.image);
    getbooknameController.text = productdata!.bookname;
    getauthornameController.text = productdata!.authorname;
    getbookeditionController.text = productdata!.bookwdition;
    getconditioncontroller = productdata!.condition;

    return Scaffold(
        appBar: AppBar(
          title: Text("Make A Request", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Make a Request for ' + data.bookname,
                        style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,), textAlign: TextAlign.center,),
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
                      FormBuilderDateRangePicker(

                        name: 'date_range',
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2030),
                        format: DateFormat('yyyy-MM-dd'),

                        onChanged: (value) {
                          daterangecontroller.text = value.toString();
                        },
                        decoration: InputDecoration(
                          labelText: 'Date Range',
                          helperText: 'Helper text',
                          hintText: 'Hint text',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _formKey.currentState!.fields['date_range']
                                  ?.didChange(null);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if(isproduct == false)...[
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: borrowedproductname,
                          name: 'borrowedproductname',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Product name'
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
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: authornameController,
                          name: 'authorname',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Author name'
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: bookeditiomController,
                          name: 'bookeditiom',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Book Edition'
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                      ]
                      else...[
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: getbooknameController,
                          name: 'borrowedproductname',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Product name'
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        SizedBox(
                          height: 20,
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
                          initialValue: getconditioncontroller,
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
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: getauthornameController,
                          name: 'authorname',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Author name'
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          controller: getbookeditionController,
                          name: 'bookeditiom',
                          //initialValue: data.productname,
                          decoration: InputDecoration(
                              labelText: 'Enter Book Edition'
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                      ],
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
                      print(daterangecontroller.text);
                      //print(_id + data.productcategory + data.productype);
                      if(_formKey.currentState?.validate() == true){
                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
                        print(formattedDate.toString());
                        if(isproduct == true){
                          borrowedproductname.text = getbooknameController.text;
                          authornameController.text = getauthornameController.text;
                          bookeditiomController.text = getbookeditionController.text;
                          conditionController = getconditioncontroller;
                          _base64Image = productdata!.image;
                        }
                        conditionController = _formKey.currentState?.fields["Condition"]?.value;
                        _insertRequest(_base64Image,context, _id, data.id.$oid, formattedDate, daterangecontroller.text , nameController.text,
                            emailController.text, addressController.text, cityController.text, noteController.text, borrowedproductname.text,
                        authornameController.text, bookeditiomController.text, conditionController );
                        Navigator.push(
                            context, MaterialPageRoute(builder: (BuildContext context) {
                          return ViewBorrowProduct(id: _id,);}
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
            ),
          ),
        ));
  }

  Future<void> _insertRequest(String _image,BuildContext context,String _userid, String _productid,String _datetime, String _daterange, String _name, String _email, String _address, String _city, String _note, String _productname, String _authorname, String _bookedition, var _condition) async {
    var _id = mongo.ObjectId();
      final request =  MongoDbBorrowRequests(id: _id, userid: _userid, productid: _productid, name: _name, address: _address, email: _email, daterange: _daterange, productname: _productname, image: _image, condition: _condition, authorname: _authorname, bookedition: _bookedition, datetime: _datetime, isaccepted: false, note: _note, city: _city);
      var result = await mongoDatabase.insert_borrow_requests(request);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request Sent")));
  }
}
