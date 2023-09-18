import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:image_picker/image_picker.dart';

class updateBorrowProducts extends StatefulWidget {
  final String type, category;
  const updateBorrowProducts({Key? key, required this.type, required this.category}) : super(key: key);

  @override
  State<updateBorrowProducts> createState() => _updateBorrowProductsState(type, category);
}

class _updateBorrowProductsState extends State<updateBorrowProducts> {
  String type,category;
  _updateBorrowProductsState(this.type,this.category);

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

  var booknameController = new TextEditingController();
  var productdescriptionController = new TextEditingController();
  var productconditioncontroller;
  var authornameController = new TextEditingController();
  var bookeditionController = new TextEditingController();
  var maxdateController = new TextEditingController();
  var otherdetailsController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    MongoDbBorrow data = ModalRoute.of(context)!.settings.arguments as MongoDbBorrow;
    print(data.bookname);
    booknameController.text = data.bookname;
    productdescriptionController.text = data.description;
    productconditioncontroller = data.condition;
    authornameController.text = data.authorname;
    bookeditionController.text = data.bookwdition;
    maxdateController.text = data.maxnoofdays;
    otherdetailsController.text = data.extrainformation;

    Uint8List bytes = base64.decode(data.image);

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
              Text('Update ' + category,
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: 40,), textAlign: TextAlign.center,),
              SizedBox(
                height: 30,
              ),
              Text('Upload Date ' + data.datetime,
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
                controller: booknameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: productdescriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              SizedBox(
                height: 10,
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
                height: 10,
              ),
              TextField(
                controller: bookeditionController,
                decoration: InputDecoration(labelText: 'Book Edition'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: authornameController,
                decoration: InputDecoration(labelText: 'Book Author'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: maxdateController,
                decoration: InputDecoration(labelText: 'Max No Of Days'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: otherdetailsController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Other Details(if any)'),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  ElevatedButton(onPressed: (){
                    if(_ImageFile == null){
                      _base64Image = data.image;
                    }
                    else{
                      data.image = _base64Image;
                    }

                    _updateProduct(data, booknameController.text, productdescriptionController.text, authornameController.text,
                        bookeditionController.text, otherdetailsController.text, maxdateController.text, data.image,
                        productconditioncontroller);

                  }, child: Text("Update")),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct(MongoDbBorrow data, String _name, String _description, String _authorname, String _bookedition,
      String _otherinformation, String _maxdays, String _image, double _condition) async{


    final update_Product = MongoDbBorrow(id: data.id, image: _image, userid: data.userid, bookname: _name, bookwdition: _bookedition,
        authorname: _authorname, condition: _condition, maxnoofdays: _maxdays, description: _description,
        extrainformation: _otherinformation, datetime: data.datetime, isaccapted: data.isaccapted, buyerid: data.buyerid);


    await mongoDatabase.updateborrowproduct(update_Product).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Updated ")));

  }
}
