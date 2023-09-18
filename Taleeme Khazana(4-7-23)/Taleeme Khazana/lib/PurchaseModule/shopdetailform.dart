import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class shopDetailFormPage extends StatefulWidget {
  final bool? ischecked;
  final String base64Image;
  const shopDetailFormPage({Key? key, required this.ischecked, required this.base64Image}) : super(key: key);

  @override
  State<shopDetailFormPage> createState() => _shopDetailFormPageState(ischecked, base64Image);
}

class _shopDetailFormPageState extends State<shopDetailFormPage> {
  bool? ischecked;
  String base64Image;
  _shopDetailFormPageState(this.ischecked, this.base64Image);
  final _formKey = GlobalKey<FormBuilderState>(); // View, modify, validate form data
  var shopNameController = new TextEditingController();
  var shopTagLineController = new TextEditingController();
  var shopEmailController = new TextEditingController();
  var shopWebsiteController = new TextEditingController();
  var shopDescriptionController = new TextEditingController();

  File? _ImageFileshop;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  void _picBase64Image(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if(image == null) return;

    compressFile(image);
  }
  void compressFile(XFile file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 30, percentage: 70);
    Uint8List imageByte = await compressedFile.readAsBytes();
    _base64Image = base64.encode(imageByte);
    print(_base64Image);
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFileshop = compressedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(ischecked);
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    print(data.email);
    print(base64Image);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Details", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
              Text('Enter Details', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                fontSize: 40,), textAlign: TextAlign.center,),
                SizedBox(height: 30,),
                FormBuilder(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child:Stack(
                            children:[ Container(
                                width: 130,
                                height: 130,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child:
                                      _ImageFileshop == null ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(height: 130,
                                          width: 130, 'assets/defaultshop.png')) :
                                      Image.file(
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.cover,
                                          _ImageFileshop!),
                                    ),
                                  ],
                                )
                            ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                    height:40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Colors.white,
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      onPressed: (){
                                        showGeneralDialog(
                                          barrierLabel: "profileimage",
                                          barrierDismissible: true,
                                          barrierColor: Colors.black.withOpacity(0.5),
                                          transitionDuration: Duration(milliseconds: 700),
                                          context: context,
                                          pageBuilder: (context, anim1, anim2) {
                                            return Align(
                                              alignment: Alignment.bottomCenter,
                                              child: SizedBox(
                                                height: 150,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 50, left: 12, right: 12),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(40),
                                                    child: Scaffold(
                                                      body: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(40),
                                                        ),
                                                        height: 500,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(20),
                                                          child: Column(
                                                            children: [

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
                                                                      _ImageFileshop = imagepath_empty;
                                                                      _base64Image = "";
                                                                      print('base64: '+_base64Image);
                                                                    });
                                                                  },
                                                                    child: Text("Clear"),),
                                                                  ElevatedButton(
                                                                      onPressed: () => _picBase64Image(ImageSource.camera),
                                                                      child: Text("Take Picture")
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          transitionBuilder: (context, anim1, anim2, child) {
                                            return SlideTransition(
                                              position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                                              child: child,
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.edit, color: Colors.white,),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        Text('*Note: Logo is optional*', style: TextStyle(color: Colors.blue),),
                        SizedBox(height: 30,),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          //controller: productnameController,
                          name: 'email',
                          initialValue: data.email,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: 'Email'
                          ),
                        ),
                        FormBuilderTextField(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          //controller: productnameController,
                          name: 'username',
                          initialValue: data.fullname,
                          readOnly: true,
                          decoration: InputDecoration(
                              labelText: 'Name'
                          ),

                        ),
                        SizedBox(height: 5,),
                        Text('*Note: Please fill your name in edit profile first*', style: TextStyle(color: Colors.blue),),
                        SizedBox(height: 5,),
                        FormBuilderTextField(
                          controller: shopNameController,
                          name: 'shopname',
                          decoration: InputDecoration(
                              labelText: 'Enter Shop name'
                          ),

                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        SizedBox(height: 15,),
                        FormBuilderTextField(
                          controller: shopTagLineController,
                          name: 'shoptagliine',
                          decoration: InputDecoration(
                              labelText: 'Enter Shop TagLine(Optional)'
                          ),

                          // validator: FormBuilderValidators.compose(
                          //     [FormBuilderValidators.required()]),
                        ),
                        SizedBox(height: 15,),
                        FormBuilderTextField(
                          controller: shopEmailController,
                          name: 'shopemail',
                          decoration: InputDecoration(
                              labelText: 'Enter Shop Email(if any)'
                          ),

                          // validator: FormBuilderValidators.compose(
                          //     [FormBuilderValidators.email()]),
                        ),
                        SizedBox(height: 15,),
                        FormBuilderTextField(
                          controller: shopWebsiteController,
                          name: 'shopwebsite',
                          decoration: InputDecoration(
                              labelText: 'Enter Shop Website(If Any)'
                          ),

                          // validator: FormBuilderValidators.compose(
                          //     [FormBuilderValidators.url()]),
                        ),
                        SizedBox(height: 15,),
                        FormBuilderTextField(
                          controller: shopDescriptionController,
                          name: 'shopdescription',
                          decoration: InputDecoration(
                              labelText: 'Enter Shop Description'
                          ),
                          maxLines: 3,
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                        ),
                        SizedBox(height: 30,),
                        ElevatedButton(onPressed: (){
                          if(_formKey.currentState?.validate() == true) {
                            // print("Name:" + shopNameController.toString());
                            // print("Shop name:" + shopNameController.toString());
                            // print("email:" + shopNameController.toString());
                            // print("decription:" + shopNameController.toString());
                            _insertShop(data, _base64Image, shopNameController.text, shopTagLineController.text, shopEmailController.text, shopWebsiteController.text, shopDescriptionController.text);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return MyDashboard(id: data.id.$oid);
                                },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required" )));
                          }
                        },
                          child: Text(
                            "Submit",style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.white
                          ),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30),
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _insertShop(MongoDbModel userdata, String _image,String _shopname, String _ShopTagline, String _shopemail, String _Shopwebsite, String _Shopdescription) async {
    print("after button press: "+ base64Image);
    var _id = mongo.ObjectId();
      final data = MongoDbShop(id: _id, userid: userdata.id.$oid, image: _image, email: userdata.email, name: userdata.fullname, shopname: _shopname, shopTagline: _ShopTagline, shopemail: _shopemail, shopwebsite: _Shopwebsite, shopDescription: _Shopdescription, isApproved: false, isChecked: ischecked, receiptimage: base64Image);
      var result = await mongoDatabase.insertShop(data);
    // final role_update = MongoDbModel(id: userdata.id, userimage: userdata.userimage, email: userdata.email, userName: userdata.userName, password: userdata.password, fullname: userdata.fullname, nickname: userdata.nickname, address: userdata.address, city: userdata.city, country: userdata.country, role: "ShopKeeper");
    // await mongoDatabase.updaterole(role_update);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account Upgrade is waiting for approval. ")));
  }
}
