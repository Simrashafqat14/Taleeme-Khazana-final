import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/PurchaseModule/shopdetailform.dart';
import 'package:image_picker/image_picker.dart';

class becomeShopKeeperConversion extends StatefulWidget {
  const becomeShopKeeperConversion({Key? key}) : super(key: key);

  @override
  State<becomeShopKeeperConversion> createState() => _becomeShopKeeperConversionState();
}

class _becomeShopKeeperConversionState extends State<becomeShopKeeperConversion> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool? ifchecked = false;

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
    final imagepath = File(compressedFile.path);
    setState(() {
      this._ImageFile = compressedFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Become A Shopkeeper'),
      ),
      body: PageView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Become a Shopkeeper', style: TextStyle(fontSize: 30),),
                    Text('*Note: Read the instructions Carefully. *', style: TextStyle(color: Colors.blue),),
                    SizedBox(height: 30,),
                    Text('By upgrading you account to shopkeeper you will have access to your own shop where you can upload products for selling maybe it be a new or a used products its your choice.',
                          style: TextStyle(fontSize: 20),textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 100,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Swipe Right'.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),),
                        Icon(Icons.keyboard_double_arrow_right)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upload Paid receipt',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                        fontSize: 30,), textAlign: TextAlign.center,),
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
                    SizedBox(
                      height: 20,
                    ),
                    FormBuilder(
                        key: _formKey,
                        child: FormBuilderCheckbox(
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          name: 'accept_terms',
                          initialValue: false,
                          onChanged: (value){
                            ifchecked = value;
                          },
                          title: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I have read and agree to the ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          validator: FormBuilderValidators.equal(
                            true,
                            errorText:
                            'You must accept terms and conditions to continue',
                          ),
                        ),),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.keyboard_double_arrow_left),
                            Text('Swipe Left'.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),),
                          ],
                        ),
                        TextButton(onPressed: (){
                          if(_base64Image != ""){
                            if(_formKey.currentState?.validate() == true){
                              print(ifchecked);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (BuildContext context) {
                                return shopDetailFormPage(ischecked: ifchecked, base64Image: _base64Image,);
                              },settings: RouteSettings(arguments: data)));
                            }
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please upload your payment receipt ")));
                          }
                        },child: Row(
                          children: [
                            Text('Next'.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),),
                            Icon(Icons.keyboard_double_arrow_right)
                          ],
                        ),)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
