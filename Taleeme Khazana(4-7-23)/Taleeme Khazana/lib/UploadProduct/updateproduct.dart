import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/UploadProduct/userProductHistoryCategories.dart';
import 'package:image_picker/image_picker.dart';

class productUpdatePage extends StatefulWidget {
  final String type, category;
  const productUpdatePage({Key? key, required this.type, required this.category}) : super(key: key);

  @override
  State<productUpdatePage> createState() => _productUpdatePageState(type, category);
}

class _productUpdatePageState extends State<productUpdatePage> {
  String type,category;
  _productUpdatePageState(this.type,this.category);
  var sizeOptions = ['xs','s','m','l','xl','xxl'];
  var genderOptions = ['Male','Female','Other'];
  var styleOptions = ['Boats','Snickers','School Shoes', 'Sport Shoes'];
  var productnameController = new TextEditingController();
  var productdescriptionController = new TextEditingController();
  var productconditioncontroller;
  var SchoolnameController = new TextEditingController();
  var UniformSizeController;
  var GenderController;
  var colorController = new TextEditingController();
  var shoesizeController = new TextEditingController();
  var StyleController;
  var authornamecontroller = new TextEditingController();
  var booksubjectcontroller = new TextEditingController();
  var gradeController = new TextEditingController();
  var noofpagescomtroller = new TextEditingController();
  var typeController = new TextEditingController();
  var stationarynameController = new TextEditingController();
  var noofitemsController = new TextEditingController();
  var OtherdetailsController = new TextEditingController();
  var reasonforexchangeController = new TextEditingController();
  var requiredamountorproductController = new TextEditingController();
  var exchangeSourceController;
  var exchangeSourceOption = ['Cash','Product'];
  var quantityofGroupedProductsController = new TextEditingController();
  Widget donateFields = Container();
  Widget exchangeFields = Container();
  var container;
  bool showimage = false;
  bool imageshow = true;

  File? _ImageFile;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  void _picBase64Image(ImageSource source) async {
    showimage= true;
    imageshow = false;
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
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFile = compressedFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    print(type + category);
    MongoDbProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbProducts;
    print('gender: '+ data.gender);
    productnameController.text = data.productname;
    productdescriptionController.text = data.productdescription;
    productconditioncontroller = data.productcondition;
    SchoolnameController.text = data.schoolname;
    UniformSizeController = data.uniformSize;
    GenderController = data.gender;
    colorController.text = data.color;
    shoesizeController.text = data.shoesSize;
    StyleController = data.shoesstyle;
    authornamecontroller.text = data.authorname;
    booksubjectcontroller.text =data.booksubject;
    gradeController.text = data.grade;
    noofpagescomtroller.text = data.noofpages;
    typeController.text = data.bagtype;
    stationarynameController.text = data.stationaryname;
    noofitemsController.text = data.noofitemsstationary;
    OtherdetailsController.text = data.extrainformation;
    reasonforexchangeController.text = data.exchangereason;
    exchangeSourceController = data.exchangesource;
    requiredamountorproductController.text = data.requiredamountorproduct;
    quantityofGroupedProductsController.text = data.quantityofGroupedProducts;


    Uint8List bytes = base64.decode(data.image);

    if(type == "Donate"){
    donateFields = Column(
      children: [
        TextField(
          controller: OtherdetailsController,
          decoration: InputDecoration(labelText: 'Other Details'),
        ),
      ],
    );}

    if(type == "Exchange"){
      exchangeFields = Column(
        children: [
          TextField(
            controller: reasonforexchangeController,
            decoration: InputDecoration(labelText: 'Reason for exchange'),
          ),
          if(data.isgrouped == true)...[
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: quantityofGroupedProductsController,
            decoration: InputDecoration(labelText: 'Qunaity'),
          ),
          ],
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
              name: 'size',
              initialValue: exchangeSourceController,
              onChanged: (value){
                exchangeSourceController = value;
                print(exchangeSourceController);
              },
              decoration: InputDecoration(
                  labelText: 'Exchange with'
              ),
              //allowClear: true,
            items: exchangeSourceOption.map((exchangeOptions) =>
                DropdownMenuItem(value: exchangeOptions,child: Text('$exchangeOptions'))
            ).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          if (exchangeSourceController == "Cash") ...[
            container =  TextField(
              controller: requiredamountorproductController,
              decoration: InputDecoration(labelText: 'Amount for Exchange'),
            ),
          ]
          else ...[
            container =  TextField(
              controller: requiredamountorproductController,
              decoration: InputDecoration(labelText: 'Product you require'),
            ),
          ]
        ],
      );}

    Widget uniformfields =  Column(
      children: [
        if(category == "Uniforms")...[
          TextField(
            controller: SchoolnameController,
            decoration: InputDecoration(labelText: 'School Name'),
          ),
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
              name: 'size',
              initialValue: UniformSizeController,
              onChanged: (value){
                UniformSizeController = value;
                print(UniformSizeController);
              },
              decoration: InputDecoration(
                  labelText: 'Select size'
              ),
              //allowClear: true,
              items: sizeOptions.map((size) =>
                  DropdownMenuItem(value: size,child: Text('$size'))
              ).toList()
          ),
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
              initialValue: GenderController,
              onChanged: (value){
                GenderController = value;
                print(GenderController);
              },
              name: 'gender',
              decoration: InputDecoration(
                  labelText: 'Select gender'
              ),
              //allowClear: true,
              items: genderOptions.map((gender) =>
                  DropdownMenuItem(value: gender,child: Text('$gender'))
              ).toList()
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: 'Color of uniform'),
          ),
        ]
      ],
    );

    Widget BooksFields = Column(
      children: [
        if(category == "Books")...[
          TextField(
            controller: authornamecontroller,
            decoration: InputDecoration(labelText: 'Author Name'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: booksubjectcontroller,
            decoration: InputDecoration(labelText: 'Book Subject'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: gradeController,
            decoration: InputDecoration(labelText: 'Enter Grade(If school book)'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: noofpagescomtroller,
            decoration: InputDecoration(labelText: 'No of pages'),
          ),
          SizedBox(
            height: 30,
          ),
        ]
      ],
    );

    Widget ShoesFields = Column(
      children: [
        if(category == "Shoes")...[
          TextField(
            controller: shoesizeController,
            decoration: InputDecoration(labelText: 'Enter Shoe size'),
          ),
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
              initialValue: GenderController,
              onChanged: (value){
                GenderController = value;
                print(GenderController);
              },
              name: 'gender',
              decoration: InputDecoration(
                  labelText: 'Select gender'
              ),
              //allowClear: true,
              items: genderOptions.map((gender) =>
                  DropdownMenuItem(value: gender,child: Text('$gender'))
              ).toList()
          ),
          SizedBox(
            height: 30,
          ),
          FormBuilderDropdown(
              initialValue: StyleController,
              onChanged: (value){
                StyleController = value;
                print(StyleController);
              },
              name: 'gender',
              decoration: InputDecoration(
                  labelText: 'Select gender'
              ),
              //allowClear: true,
              items: styleOptions.map((style) =>
                  DropdownMenuItem(value: style,child: Text('$style'))
              ).toList()
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: 'Color of Shoes'),
          ),
        ]
      ],
    );

    Widget BagsFields = Column(
      children: [
        if(category == "Bags")...[
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: 'Color of bag'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: gradeController,
            decoration: InputDecoration(labelText: 'Enter Grade'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: typeController,
            decoration: InputDecoration(labelText: 'Bag Type'),
          ),
        ]
      ],
    );

    Widget StationaryFields = Column(
      children: [
        if(category == "Stationary")...[
          TextField(
            controller: noofitemsController,
            decoration: InputDecoration(labelText: 'No of items'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: stationarynameController,
            decoration: InputDecoration(labelText: 'Stationary Name'),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: colorController,
            decoration: InputDecoration(labelText: 'Color of Stationary'),
          ),
        ]
      ],
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Update Products", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        leading: const BackButton(
          color: Colors.white, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
            FittedBox(
              child: Text('Update ' + category,
              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
                fontSize: 30,), textAlign: TextAlign.center,),
            ),
              SizedBox(
                height: 30,
              ),
              Text('Upload Date ' + data.dateTime,
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: 20,), textAlign: TextAlign.center,),
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
                      imageshow = !imageshow;
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _ImageFile == null ? Image(
                      image: AssetImage(
                          'assets/product_default.jpg')) :
                  Image.file(
                      height: 250,
                      width: 500,
                      fit: BoxFit.cover,
                      _ImageFile!),
                )
              ),
              Visibility(
                visible: imageshow!,
                child: ClipRRect(
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
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: productnameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: productdescriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              SizedBox(
                height: 50,
              ),
              FormBuilderSlider(
                initialValue: productconditioncontroller,
                min: 0.0,
                max: 5.0,
                divisions: 20,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey,
                decoration: InputDecoration(
                    labelText: 'Select Condition (1-10)'
                ), name: 'condition',
                onChanged: (value) {
                  productconditioncontroller = value;
                  print(productconditioncontroller);
                },
              ),
              SizedBox(
                height: 50,
              ),
              uniformfields,
              ShoesFields,
              BooksFields,
              BagsFields,
              StationaryFields,
              SizedBox(
                height: 50,
              ),
              donateFields,
              exchangeFields,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton(onPressed: (){
                    if(_ImageFile == null){
                      _base64Image = data.image;
                    }
                    else{
                      data.image = _base64Image;
                    }
                    _updateProduct(data.id, data.userid, productnameController.text, productdescriptionController.text,
                        data.image, productconditioncontroller, authornamecontroller.text, booksubjectcontroller.text,
                        gradeController.text, noofpagescomtroller.text, typeController.text, StyleController.toString(),
                        shoesizeController.text, stationarynameController.text, noofitemsController.text, SchoolnameController.text,
                        UniformSizeController.toString(), GenderController, colorController.text, reasonforexchangeController.text,
                        exchangeSourceController, requiredamountorproductController.text,
                        OtherdetailsController.text, data.dateTime, data.isgrouped, quantityofGroupedProductsController.text, data.isaccapted, data.buyerid);


                  }, child: Text("Update")),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _updateProduct(var id, String userid,String _productname,String _productDescription,
      String _image, double _condition, String _bookAuthor, String _bookSubject, String _bookGrade, String _noOfPages, String _Bagtype,
      String _shoestyle, String _shoesize,  String _stationaryname, String _noofitems, String _schoolName, String _uniformSize,
      String _gender, String _color, String _exchangereason, String _exchangesource, String _requiredamountorproduct,
      String _otherDetails, String _dateTime, bool _isGrouped, String _quanityodgroupedproducts,bool _isaccepted, String _buyerid) async{


    print("author" + _bookAuthor);

    final update_Product = MongoDbProducts(id: id, userid: userid, productcategory: category, productype: type, image: _image,
        productname: _productname, productdescription: _productDescription, productcondition: _condition, authorname: _bookAuthor,
        booksubject: _bookSubject, noofpages: _noOfPages, uniformSize: _uniformSize, schoolname: _schoolName, shoesSize: _shoesize,
        shoesstyle: _shoestyle, bagtype: _Bagtype, stationaryname: _stationaryname, noofitemsstationary: _noofitems,
        grade: _bookGrade, gender: _gender, color: _color, extrainformation: _otherDetails,
        exchangereason: _exchangereason, exchangesource: _exchangesource, requiredamountorproduct: _requiredamountorproduct, dateTime: _dateTime
        , isgrouped: _isGrouped, quantityofGroupedProducts: _quanityodgroupedproducts, isaccapted: _isaccepted, buyerid: _buyerid);

    print("author" + _bookAuthor);

      await mongoDatabase.updateProduct(update_Product).whenComplete(() => Navigator.pop(context));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Updated ")));

  }
}
