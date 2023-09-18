
import 'dart:convert';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Product/upload_product.dart';
import 'package:fyp_project/UploadProduct/Uploadpage.dart';
import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as ml;

class uploadShoes extends StatefulWidget {
  final String id, type;
  final bool isGrouped;
  const uploadShoes({Key? key, required this.id, required this.type, required this.isGrouped}) : super(key: key);

  @override
  State<uploadShoes> createState() => _uploadShoesState(id, type, isGrouped);
}

class _uploadShoesState extends State<uploadShoes> {
  String id, type;
  bool isGrouped;
  _uploadShoesState(this.id, this.type, this.isGrouped);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var genderOptions = ['Male','Female','Other'];
  var styleOptions = ['Boats','Snickers','School Shoes', 'Sport Shoes'];
  var productnameController = new TextEditingController();
  var producrdescriptionController = new TextEditingController();
  var productimageController;
  var productconditionController;
  var sizeController = new TextEditingController();
  var GenderController;
  var StyleController;
  var ColorController = new TextEditingController();
  var OtherdetailsController = new TextEditingController();
  var reasonforexchangeController = new TextEditingController();
  var requiredamountorproductController = new TextEditingController();
  var exchangeSourceController;
  var exchangeSourceOption = ['Cash','Product'];
  var quantityofGroupedProductsController = new TextEditingController();
  var container;
  bool showimage = false;
  //File? image;
  Widget Heading = Container();
  Widget exchangeFields = Container();
  Widget donateFields = Container();
  Widget exchangeSource = Container();


  File? _ImageFile;

  late ml.InputImage _inputImage;
  File? _pickedImage;
  static final ml.ImageLabelerOptions _options =
  ml.ImageLabelerOptions(confidenceThreshold: 0.8);

  final imageLabeler = ml.ImageLabeler(options: _options);

  final ImagePicker _imagePicker = ImagePicker();

  String text = "";
  String label = "";

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  void _picBase64Image(ImageSource source) async {
    showimage= true;
    final XFile? image = await _picker.pickImage(source: source);
    if(image == null) return;

    compressFile(image);
    setState(() {
      _pickedImage = File(image.path);
    });
    _inputImage = ml.InputImage.fromFile(_pickedImage!);
    identifyImage(_inputImage);
  }
  void compressFile(XFile file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 20, percentage: 100);
    Uint8List imageByte = await compressedFile.readAsBytes();
    _base64Image = base64.encode(imageByte);
    print(_base64Image);
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFile = compressedFile;
    });
  }

  void identifyImage(ml.InputImage inputImage) async {
    final List<ml.ImageLabel> image = await imageLabeler.processImage(inputImage);

    if (image.isEmpty) {
      setState(() {
        text = "Cannot identify the image";
      });
      return;
    }

    for (ml.ImageLabel img in image) {
      setState(() {
        //text = "Label : ${img.label}\nConfidence : ${img.confidence}";
        text = img.label;

      });
    }
    imageLabeler.close();
  }

  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    print(formattedDate.toString());

    if(type == "Donate"){
      Heading = Text('Donate Shoes',
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      donateFields = Column(
        children: [
          FormBuilderTextField(
            autovalidateMode:AutovalidateMode.disabled,
            controller: OtherdetailsController,
            name: 'Otherdetails',
            maxLines: 3,
            decoration: InputDecoration(
                labelText: 'Other Details (Optional)'
            ),
            // validator: FormBuilderValidators.compose(
            //     [FormBuilderValidators.required()]),
          ),
        ],
      );
    }
    if(type == "Exchange"){
      Heading = Text('Exchange Shoes',
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      exchangeFields = Column(
        children: [
          FormBuilderTextField(
            autovalidateMode:AutovalidateMode.disabled,
            controller: reasonforexchangeController,
            name: 'ReasonForExchange',
            maxLines: 3,
            decoration: InputDecoration(
                labelText: 'Reason For Exchange'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
          ),
          if(isGrouped == true)...[
            SizedBox(
              height: 30,
            ),
            FormBuilderTextField(
              autovalidateMode:AutovalidateMode.disabled,
              controller: quantityofGroupedProductsController,
              name: 'quantity for exchange',
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: 'Quantity'
              ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
            ),
          ],
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
            autovalidateMode:AutovalidateMode.disabled,
            name: 'exchangesource',
            onChanged: (value) {
              exchangeSourceController = value;
              print(exchangeSourceController);
            },
            decoration: InputDecoration(
                labelText: 'Exchange with'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: exchangeSourceOption.map((exchangeOptions) =>
                DropdownMenuItem(value: exchangeOptions,child: Text('$exchangeOptions'))
            ).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          FormBuilderTextField(
            autovalidateMode:AutovalidateMode.disabled,
            controller: requiredamountorproductController,
            name: 'exchangeAmountorproduct',
            decoration: InputDecoration(
                labelText: 'Enter amount for exchange or product name'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
          ),

        ],
      );
    }

    Widget formBody = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Heading,
                    SizedBox(
                      height: 30,
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
                    Text(text, style: TextStyle(fontSize: 20),),

                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      autovalidateMode:AutovalidateMode.disabled,
                      controller: productnameController,
                      name: 'productname',
                      decoration: InputDecoration(
                          labelText: 'Enter Product name'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      autovalidateMode:AutovalidateMode.disabled,
                      controller: producrdescriptionController,
                      name: 'Description',
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: 'Enter Description'
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderSlider(
                      autovalidateMode:AutovalidateMode.disabled,
                      name: 'Condition',
                      initialValue: 0.0,
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
                      autovalidateMode:AutovalidateMode.disabled,
                      controller: sizeController,
                      name: 'size',
                      decoration: InputDecoration(
                          labelText: 'Enter Shoe Size'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderDropdown(
                        autovalidateMode:AutovalidateMode.disabled,
                        name: 'gender',
                        decoration: InputDecoration(
                            labelText: 'Select gender'
                        ),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                        //allowClear: true,
                        items: genderOptions.map((gender) =>
                            DropdownMenuItem(value: gender,child: Text('$gender'))
                        ).toList()
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FormBuilderDropdown(
                        autovalidateMode:AutovalidateMode.disabled,
                        name: 'style',
                        decoration: InputDecoration(
                            labelText: 'Select style'
                        ),
                        // validator: FormBuilderValidators.compose(
                        //     [FormBuilderValidators.required()]),
                        //allowClear: true,
                        items: styleOptions.map((style) =>
                            DropdownMenuItem(value: style,child: Text('$style'))
                        ).toList()
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FormBuilderTextField(
                      autovalidateMode:AutovalidateMode.disabled,
                      controller: ColorController,
                      name: 'color',
                      decoration: InputDecoration(
                          labelText: 'Enter Color of shoes'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    donateFields,
                    exchangeFields,
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: TextButton(onPressed: (){

                        print(text);
                        if(text != 'Shoe'){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text('pic not match'),
                                  content: Text('Please upload a suitable pic'),
                                  actions: <Widget>[
                                    TextButton(onPressed: (){
                                      setState(() {

                                      });
                                    }, child: Text('Ok')),
                                  ],
                                );
                              }
                          );
                        }
                        //print(image);
                        if(_formKey.currentState?.validate() == true) {
                          print("Name:" + productnameController.toString());
                          print("Description:" + producrdescriptionController.toString());
                          //productimageController = _formKey.currentState!.fields["image"]!?.value.toString();
                          //image != null ? Image.file(image!);
                         // print("Image:" + image.toString());
                          productconditionController = _formKey.currentState?.fields["Condition"]?.value;
                          print("Condition:" + productconditionController.toString());
                          print("Category:" + sizeController.toString());
                          GenderController = _formKey.currentState?.fields["gender"]?.value;
                          print("Category:" + GenderController.toString());
                          StyleController = _formKey.currentState?.fields["style"]?.value;
                          print("Category:" + StyleController.toString());
                          print("Type:" + ColorController.toString());
                          print("Type:" + OtherdetailsController.toString());


                          _insertProduct(type, context, id, productnameController.text, producrdescriptionController.text, _base64Image, productconditionController, sizeController.text, GenderController.toString(), StyleController.toString(), ColorController.text, OtherdetailsController.text, reasonforexchangeController.text, exchangeSourceController.toString(), requiredamountorproductController.text, formattedDate.toString(), isGrouped, quantityofGroupedProductsController.text);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (BuildContext context) {
                            return MyUpload(id: id,);
                          },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));


                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required" )));
                        }
                      },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          child: Center(
                              child: new Text("Upload",
                                  style: const TextStyle(
                                      color: const Color(0xfffefefe),
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 17.0))),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(34, 168, 225, 1.0),
                                    Color.fromRGBO(45, 175, 218, 1.0),
                                    Color.fromRGBO(43, 103, 215, 1.0),
                                  ],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(9.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if(type == "Donate"){
      return  Scaffold(
        appBar: AppBar(
          title: Text("Donate Products", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
        ),
        body: formBody,
      );
    }
    else if(type == "Exchange"){
      return Scaffold(
        appBar: AppBar(
          title: Text("Exchange Products", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
        ),
        body: formBody,
      );
    }
    else{
      return Container();
    }


  }
}


Future<void> _insertProduct(String _type, BuildContext context, String userid,String _productname,String _productDescription, String _image, double _condition, String _shoesize, String _gender, String _shoestyle, String _color, String _otherDetails, String _exchangereason, String _exchangesource, String _requiredamountorproduct, String _dateTime, bool _isGrouped, String _quantityofGroupedProducts ) async {
  var _id = mongo.ObjectId();
  if(_type == "Donate") {
    final data = MongoDbProducts(id: _id,
        userid: userid,
        productcategory: "Shoes",
        productype: _type,
        image: _image,
        productname: _productname,
        productdescription: _productDescription,
        productcondition: _condition,
        authorname: "",
        booksubject: "",
        noofpages: "",
        uniformSize: "",
        schoolname: "",
        shoesSize: _shoesize,
        shoesstyle: _shoestyle,
        bagtype: "",
        stationaryname: "",
        noofitemsstationary: "",
        grade: "",
        gender: _gender,
        color: _color,
        extrainformation: _otherDetails,
        exchangereason: "",
        exchangesource: "",
        requiredamountorproduct: "",
        dateTime: _dateTime, isgrouped: _isGrouped, quantityofGroupedProducts: _quantityofGroupedProducts, isaccapted: false, buyerid: "");
    var result = await mongoDatabase.insert_product(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Uploaded ")));
  }
  if(_type == "Exchange") {
    final data = MongoDbProducts(id: _id,
        userid: userid,
        productcategory: "Shoes",
        productype: _type,
        image: _image,
        productname: _productname,
        productdescription: _productDescription,
        productcondition: _condition,
        authorname: "",
        booksubject: "",
        noofpages: "",
        uniformSize: "",
        schoolname: "",
        shoesSize: _shoesize,
        shoesstyle: _shoestyle,
        bagtype: "",
        stationaryname: "",
        noofitemsstationary: "",
        grade: "",
        gender: _gender,
        color: _color,
        extrainformation: "",
        exchangereason: _exchangereason,
        exchangesource: _exchangesource,
        requiredamountorproduct: _requiredamountorproduct,
        dateTime: _dateTime, isgrouped: _isGrouped, quantityofGroupedProducts: _quantityofGroupedProducts, isaccapted: false, buyerid: "");
    var result = await mongoDatabase.insert_product(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Uploaded ")));
  }
}


class ApiImage {
  final String imageUrl;
  final String id;
  ApiImage({
    required this.imageUrl,
    required this.id,
  });
}