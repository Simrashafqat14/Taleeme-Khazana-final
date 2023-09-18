import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/Product/upload_product.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:google_ml_kit/google_ml_kit.dart' as ml;

class purchaseUploadProduct extends StatefulWidget {
  final String id, category;
  const purchaseUploadProduct({Key? key,  required this.id  , required this.category,}) : super(key: key);

  @override
  State<purchaseUploadProduct> createState() => _purchaseUploadProductState(id, category);
}

class _purchaseUploadProductState extends State<purchaseUploadProduct> {
  String id, category;
  _purchaseUploadProductState(this.id, this.category);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var productnameController = new TextEditingController();
  var producrdescriptionController = new TextEditingController();
  var productPriceController = new TextEditingController();
  var productsalePriceController = new TextEditingController();
  var stockController = new TextEditingController();
  var extrainformationController = new TextEditingController();
  var bookauthorController = new TextEditingController();
  var shoeSizeController = new TextEditingController();
  var bookTypeOption = ['Novels','School Book'];
  var genderOption = ['Male','Female','Other'];
  var bagSizeOption = ['Small','Medium','Large'];
  var uniformSizeOption = ['S','M','L','XL','XXL','XXXL'];
  var shoeTypeOption = ['Boats','Snickers','School Shoes', 'Sport Shoes'];
  var shoetypecontroller;
  var uniformsizeController;
  var bagSizeController;
  var bookTypeController;
  var genderController;
  int price = 0;
  Color mycolor = Colors.white;
  bool onSale = false;
  bool islimited = false;
  bool showimage = false;

  Widget Heading = Container();
  Widget changingFields = Container();
  Widget innerChangingFields = Container();


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


    innerChangingFields = Column(
      children: [
        TextButton(
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Pick a color!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: mycolor, //default color
                        onColorChanged: (Color color){ //on color picked
                          setState(() {
                            mycolor = color;
                            print('color: '+mycolor.toString());
                          });
                        },
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('DONE'),
                        onPressed: () {
                          Navigator.of(context).pop(); //dismiss the color picker
                        },
                      ),
                    ],
                  );
                }
            );

          },
          child: Row(
            children: [
              Ink(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  child: InkWell(
                    //borderRadius: BorderRadius.circular(100.0),
                    onTap: () {},
                    child:
                       Icon(Icons.circle, color: mycolor, ),
                  )
              ),
              SizedBox(
                width: 10,
              ),
              Text('Select Color', style: TextStyle(color: Colors.black, fontSize: 15,),),
            ],
          ),
        ),
        if(category != "Stationary")...[
          FormBuilderDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            name: 'gender',
            onChanged: (value) {
              genderController = value;
              print(genderController);
            },
            decoration: InputDecoration(
                labelText: 'Gender'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: genderOption.map((genderOptions) =>
                DropdownMenuItem(
                    value: genderOptions, child: Text('$genderOptions'))
            ).toList(),
          ),
        ]
      ],
    );

    if (category == "Books") {
      Heading = Text('Upload Books',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      changingFields = Column(
        children: [
          FormBuilderTextField(
            autovalidateMode: AutovalidateMode.disabled,
            controller: bookauthorController,
            name: 'authorname',
            decoration: InputDecoration(
                labelText: 'Enter Author Name'
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FormBuilderDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            name: 'booktype',
            onChanged: (value) {
              bookTypeController = value;
              print(bookTypeController);
            },
            decoration: InputDecoration(
                labelText: 'Book Type'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: bookTypeOption.map((bookTypeOptions) =>
                DropdownMenuItem(
                    value: bookTypeOptions, child: Text('$bookTypeOptions'))
            ).toList(),
          ),
        ],
      );
    }
    if (category == "Uniforms") {
      Heading = Text('Upload Uniforms',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      changingFields = Column(
        children: [
          FormBuilderDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            name: 'uniformsize',
            onChanged: (value) {
              uniformsizeController = value;
              print(uniformsizeController);
            },
            decoration: InputDecoration(
                labelText: 'Uniform Size'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: uniformSizeOption.map((uniformSizeOptions) =>
                DropdownMenuItem(
                    value: uniformSizeOptions, child: Text('$uniformSizeOptions'))
            ).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields,
        ],
      );
    }
    if (category == "Shoes") {
      Heading = Text('Upload Shoes',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      changingFields = Column(
        children: [
          FormBuilderTextField(
            autovalidateMode: AutovalidateMode.disabled,
            controller: shoeSizeController,
            name: 'shoesize',
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            decoration: InputDecoration(
                labelText: 'Enter Shoe Size'
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FormBuilderDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            name: 'shoetype',
            onChanged: (value) {
              shoetypecontroller = value;
              print(shoetypecontroller);
            },
            decoration: InputDecoration(
                labelText: 'Shoe Type'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: shoeTypeOption.map((shoeTypeOptions) =>
                DropdownMenuItem(
                    value: shoeTypeOptions, child: Text('$shoeTypeOptions'))
            ).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields,
        ],
      );
    }
    if (category == "Bags") {
      Heading = Text('Upload Bags',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      changingFields = Column(
        children: [
          FormBuilderDropdown(
            autovalidateMode: AutovalidateMode.disabled,
            name: 'bagsize',
            onChanged: (value) {
              bagSizeController = value;
              print(bagSizeController);
            },
            decoration: InputDecoration(
                labelText: 'Bag Size'
            ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            //allowClear: true,
            items: bagSizeOption.map((bagSizeOptions) =>
                DropdownMenuItem(
                    value: bagSizeOptions, child: Text('$bagSizeOptions'))
            ).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields,
        ],
      );
    }
    if (category == "Stationary") {
      Heading = Text('Upload Stationary',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
          fontSize: 40,), textAlign: TextAlign.center,);
      changingFields = Column(
        children: [
          innerChangingFields,
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
                      autovalidateMode: AutovalidateMode.disabled,

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
                      autovalidateMode: AutovalidateMode.disabled,
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
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: productPriceController,
                      name: 'productrice',
                      onChanged: (value){
                        price = int.parse(value!)-1;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Enter product price'
                      ),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(),
                          FormBuilderValidators.integer()]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(onPressed: (){
                      setState(() {
                        onSale = !onSale;
                        print(onSale);
                      });
                    },
                        child: Row(
                          children: [
                            Icon(onSale ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.black,),
                            SizedBox(
                              width: 10,
                            ),
                            Text('OnSale', style: TextStyle(color: Colors.black, fontSize: 15),),
                          ],
                        )
                    ),
                    Visibility(
                      visible: onSale,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            controller: productsalePriceController,
                            name: 'productsalerice',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Enter product Sale price'
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(),
                                  FormBuilderValidators.integer(),
                                FormBuilderValidators.max(price)]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('Stock: '.padLeft(10), style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: (){
                          setState(() {
                            islimited = !islimited;
                            print('Unlimited'+islimited.toString());
                          });
                        },
                            child: Row(
                              children: [
                                Icon(islimited ? Icons.check_box_outline_blank : Icons.check_box, color: Colors.black,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Unlimited', style: TextStyle(color: Colors.black, fontSize: 15),),
                              ],
                            )
                        ),
                        TextButton(onPressed: (){
                          setState(() {
                            islimited = !islimited;
                            print('Limited'+islimited.toString());
                          });
                        },
                            child: Row(
                              children: [
                                Icon(islimited ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.black,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Limited', style: TextStyle(color: Colors.black, fontSize: 15),),
                              ],
                            )
                        ),
                      ],
                    ),
                    Visibility(
                      visible: islimited,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            autovalidateMode: AutovalidateMode.disabled,
                            controller: stockController,
                            name: 'stock',
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Enter stock'
                            ),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(),
                                  FormBuilderValidators.integer()]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.disabled,
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
                    changingFields,
                    SizedBox(
                      height: 20,
                    ),
                    Container(

                      child: TextButton(onPressed: () {
                        // print(image);
                        if(onSale == false){
                          productsalePriceController.clear();
                        }
                        if(islimited == false){
                          stockController.clear();
                        }
                        print(text);
                        if(text != 'bag'){
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
                        print('image: '+_base64Image);
                        if (_formKey.currentState?.validate() == true) {

                          _insertProduct(id, category, productnameController.text, producrdescriptionController.text,
                              _base64Image, productPriceController.text, productsalePriceController.text, onSale,
                              islimited, stockController.text, extrainformationController.text, formattedDate.toString(),
                              bagSizeController.toString(), bookTypeController.toString(), bookauthorController.text,
                              uniformsizeController.toString(), shoeSizeController.text, shoetypecontroller.toString(),
                              genderController.toString(), mycolor.value.toString());

                          Navigator.push(
                              context, MaterialPageRoute(builder: (BuildContext context) {
                            return MyUpload(id: id,);
                          },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));

                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All fields are required")));
                        }
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

  Future<void> _insertProduct(String userid, String _category, String _productname,String _productDescription, String _image, String _price, String _saleprice, bool _onsale, bool _islimited, String _stock, String _extrainformation, String _datetime, String _bagsize, String _booktype, String _bookauthor, String _unifomrsize, String _shoesize, String _shoestype, String _gender, String _color  ) async {
    var _id = mongo.ObjectId();
      final data = MongoDbPurchasableProducts(id: _id, userid: userid, productcategory: _category, image: _image, productname: _productname, productdescription: _productDescription, productprice: _price, saleprice: _saleprice, onSale: _onsale, islimited: _islimited, stock: _stock, extrainformation: _extrainformation, dateTime: _datetime, bagsize: _bagsize, booktype: _booktype, bookauthor: _bookauthor, uniformSize: _unifomrsize, shoesSize: _shoesize, shoesType: _shoestype, gender: _gender, color: _color);
      var result = await mongoDatabase.insert_purchase_product(data);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Uploaded ")));
  }
}
