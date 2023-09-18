import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/UploadProduct/borrow/borrow%20upload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:google_ml_kit/google_ml_kit.dart' as ml;


class borrowformsforproducts extends StatefulWidget {
  final String id, type, category;
  const borrowformsforproducts({Key? key,  required this.id , required this.type , required this.category,}) : super(key: key);

  @override
  State<borrowformsforproducts> createState() => _borrowformsforproductsState(id, type, category);
}

class _borrowformsforproductsState extends State<borrowformsforproducts> {
  String id, type, category;
  _borrowformsforproductsState(this.id, this.type, this.category);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var productnameController = new TextEditingController();
  var bookeditioncontroller = new TextEditingController();
  var authornamecontrooller = new TextEditingController();
  var productconditionController;
  var maxdaysborrowcontroller = new TextEditingController();
  var producrdescriptionController = new TextEditingController();
  var extrainformationController = new TextEditingController();
  bool showimage = false;



  File? _ImageFile;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';

  late ml.InputImage _inputImage;
  File? _pickedImage;
  static final ml.ImageLabelerOptions _options =
  ml.ImageLabelerOptions(confidenceThreshold: 0.8);

  final imageLabeler = ml.ImageLabeler(options: _options);

  final ImagePicker _imagePicker = ImagePicker();

  String text = "";
  String label = "";


  void _picBase64Image(ImageSource source) async {
    showimage= true;
    final XFile? image = await _picker.pickImage(source: source);
    if(image == null) return;

    compressFile(image);
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
    print(data.fullname);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    print(formattedDate.toString());

    Widget Heading = Text('Upload '+ category,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
        fontSize: 40,), textAlign: TextAlign.center,);

    Widget formBody = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 0, bottom: 20),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: productnameController,
                      name: 'bookname',
                      decoration: InputDecoration(
                          labelText: 'Enter Book name'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: bookeditioncontroller,
                      name: 'bookedition',
                      decoration: InputDecoration(
                          labelText: 'Edition of book(If any)'
                      ),

                      // validator: FormBuilderValidators.compose(
                      //     [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: authornamecontrooller,
                      name: 'authorname',
                      decoration: InputDecoration(
                          labelText: 'Enter Author name'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderSlider(
                      autovalidateMode:AutovalidateMode.onUserInteraction,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: maxdaysborrowcontroller,
                      name: 'daysforborrow',
                      decoration: InputDecoration(
                          labelText: 'Max Days for borrow'
                      ),

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: extrainformationController,
                      name: 'extrainformation',
                      maxLines: 3,
                      decoration: InputDecoration(
                          labelText: 'Other Details (Optional)'
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //changingFields,
                    SizedBox(
                      height: 20,
                    ),
                    Container(



                      child: TextButton(onPressed: () {
                        print(productnameController);
                        print(bookeditioncontroller);
                        print(authornamecontrooller);
                        productconditionController = _formKey.currentState
                            ?.fields["Condition"]?.value;
                        print(productconditionController);
                        print(maxdaysborrowcontroller);
                        print(producrdescriptionController);
                        print(extrainformationController);

                        print(text);
                        if(text != 'book' || text != 'notes'){
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
                        if (_formKey.currentState?.validate() == true) {
                          _insertProduct(id, productnameController.text, bookeditioncontroller.text, authornamecontrooller.text, _base64Image, productconditionController, maxdaysborrowcontroller.text, extrainformationController.text, producrdescriptionController.text, formattedDate.toString());
                          Navigator.push(
                              context, MaterialPageRoute(builder: (BuildContext context) {
                            return UploadborrowPage(id: id, type: type, isGrouped: false,);
                          },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                        }

                        // print(image);
                      },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
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


    return  Scaffold(
      appBar: AppBar(
        title: Text("Upload Products", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
      ),
      body: formBody,
    );
  }


  Future<void> _insertProduct(String _userid, String _bookname, String _bookedition,String _authorname, String _image, double _condition, String _maxdays, String _extrainformation, String _productdescription, String _datetime) async {
    var _id = mongo.ObjectId();
    final data =  MongoDbBorrow(id: _id, image: _image, userid: _userid, bookname: _bookname, bookwdition: _bookedition, authorname: _authorname, condition: _condition, maxnoofdays: _maxdays, description: _productdescription, extrainformation: _extrainformation, datetime: _datetime, isaccapted: false, buyerid: "");
    var result = await mongoDatabase.insert_borrow(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Uploaded ")));
  }
}
