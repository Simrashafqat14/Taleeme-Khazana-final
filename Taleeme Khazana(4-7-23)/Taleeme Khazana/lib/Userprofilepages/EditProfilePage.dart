import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/Userprofilepages/ChangePassword.dart';
import 'package:fyp_project/userActionPages/ForgetPassword.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/dashboardpage.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:image_picker/image_picker.dart';



class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.title});
  final String title;

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {

  var imageController = new TextEditingController();
  var fullNameController = new TextEditingController();
  var nicknameController = new TextEditingController();
  var addressController = new TextEditingController();
  var cityController = new TextEditingController();
  var countryController = new TextEditingController();
  var shopTagLineController = new TextEditingController();
  var shopEmailController = new TextEditingController();
  var shopWebsiteController = new TextEditingController();
  var shopDescriptionController = new TextEditingController();
  var image = new TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();


  File? _ImageFile;
  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  File? _ImageFileshop;
  String _base64Imageshop = '';
  void _picBase64Image(ImageSource source, String userrole) async {
    final XFile? image = await _picker.pickImage(source: source);
    if(image == null) return;
    compressFile(image, userrole);
  }
  void compressFile(XFile file, String userrole) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 20, percentage: 100);
    Uint8List imageByte = await compressedFile.readAsBytes();
   if(userrole == 'Customer'){
     _base64Image = base64.encode(imageByte);
     print('Customer'+ _base64Image);
     final imagepath = File(compressedFile.path);
     setState(() {
       this._ImageFile = compressedFile;
     }
     );
   }
   else{
      _base64Imageshop = base64.encode(imageByte);
      print("ShopKeeper"+_base64Imageshop);
      final imagepath = File(compressedFile.path);
      setState(() {
        this._ImageFileshop = compressedFile;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    MongoDbShop? shopData;
    fullNameController.text = data.fullname;
    nicknameController.text = data.nickname;
    addressController.text = data.address;
    cityController.text = data.city;
    countryController.text = data.country;
    print('nick name: '+ data.nickname);
    String? countryValue = "";
    String? stateValue = "";
    String? cityValue = "";
    Uint8List? bytes;


    bytes = base64.decode(data.userimage);

    //print('databaseimage '+ data.userimage);


    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {

          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MyDashboard(id: data.id.$oid);
              },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
        },
        ),

        actions: [
          IconButton(
            onPressed: (){
              this.setState(() {
                if(_ImageFile == null){
                  _base64Image = data.userimage;
                }
                else{
                  data.userimage = _base64Image;
                }
                if(data.role == "ShopKeeper"){
                  _updatename(shopData!, shopData!.image,fullNameController.text, shopTagLineController.text, shopEmailController.text, shopWebsiteController.text, shopDescriptionController.text);
                }
                _updateuser(data, data.id,  data.userimage, data.email, data.userName, data.password, fullNameController.text, nicknameController.text, data.address, data.city, data.country);
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MyDashboard(id: data.id.$oid);
                    },settings: RouteSettings(arguments: data))).then((value) => this.setState(() {}));

              });
            },
            icon: Icon(Icons.done_outline),
            color: Colors.white,)
        ],
      ),
      body: Container(
        //padding: EdgeInsets.only(left: 15,top: 20,right: 15, bottom: 30),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: FormBuilder(

            key: _formKey,
            child: ListView(
              padding: EdgeInsets.only(left: 15,top: 20,right: 15, bottom: 30),
              children: [
                Center(
                  child:Stack(
                    children:[
                      Container(
                          width: 130,
                          height: 130,
                          child: Column(
                            children: [
                              if(data.userimage == "")...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child:
                                  _ImageFile == null ? ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('assets/profile.jpg')) :
                                  Image.file(
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                      _ImageFile!),
                                ),
                              ]
                              else...[
                                data.userimage != "" ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.memory(
                                    bytes!,
                                    height: 130,
                                    width: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('assets/profile.jpg'))
                              ]

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
                              width: 2,
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
                                                              onPressed: () {
                                                                data.userimage = "";
                                                                _picBase64Image(ImageSource.gallery, 'Customer');
                                                                },
                                                              child: Text("Upload Picture")
                                                          ),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                data.userimage = "";
                                                                _picBase64Image(
                                                                    ImageSource
                                                                        .camera, 'Customer');
                                                              },
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
                SizedBox(height: 10,),
                FormBuilderTextField(
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  controller: fullNameController,
                  name: 'FullName',
                  onChanged: (value){
                    data.fullname = value.toString();
                  },
                  //initialValue: data.fullname,
                  decoration: InputDecoration(
                      labelText: 'FullName'
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  //controller: productnameController,
                  name: 'email',
                  initialValue: data.email,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.email()]),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  //controller: productnameController,
                  name: 'username',
                  initialValue: data.userName,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'UserName'
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FormBuilderTextField(
                  //autovalidateMode:AutovalidateMode.onUserInteraction,
                  controller: nicknameController,
                  onChanged: (value){
                    data.nickname = value.toString();
                  },
                  //initialValue: data.nickname,
                  name: 'nickName',
                  decoration: InputDecoration(
                      labelText: 'NickName'
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                FormBuilderTextField(
                  autovalidateMode:AutovalidateMode.onUserInteraction,
                  initialValue: countryController.text + " " + cityController.text + " " + addressController.text,
                  name: 'Address',
                  decoration: InputDecoration(
                      labelText: 'Address',
                    suffixIcon: IconButton(
                      onPressed: (){
                        showGeneralDialog(
                          barrierLabel: "cart",
                          barrierDismissible: true,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 700),
                          context: context,
                          pageBuilder: (context, anim1, anim2) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 330,
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
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CSCPicker(
                                                    showStates: true,
                                                    showCities: true,
                                                    dropdownDecoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        color: Colors.white,
                                                        border:
                                                        Border.all(color: Colors.grey.shade300, width: 1)),
                                                    countrySearchPlaceholder: "Country",
                                                    stateSearchPlaceholder: "State",
                                                    citySearchPlaceholder: "City",
                                                    countryDropdownLabel: "*Country",
                                                    stateDropdownLabel: "*State",
                                                    cityDropdownLabel: "*City",
                                                    selectedItemStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    dropdownHeadingStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight: FontWeight.bold),
                                                    dropdownItemStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                    dropdownDialogRadius: 10.0,
                                                    searchBarRadius: 10.0,
                                                    onCountryChanged: (value) {
                                                      countryValue = value;
                                                    },
                                                    onStateChanged: (value) {
                                                      stateValue = value;
                                                    },
                                                    onCityChanged: (value) {
                                                      cityValue = value;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: FormBuilderTextField(
                                                    autovalidateMode:AutovalidateMode.onUserInteraction,
                                                    controller: addressController,
                                                    //initialValue: data.address,

                                                    name: 'Address',
                                                    onChanged: (value){
                                                      data.address = value.toString();
                                                    },
                                                    decoration: InputDecoration(
                                                        labelText: 'Address'
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: (){
                                                          countryController.text = countryValue.toString();
                                                          cityController.text = stateValue.toString() + " " + cityValue.toString();
                                                          print(countryController.text + cityController.text + addressController.text);
                                                          data.city = cityController.text;
                                                          data.country = countryController.text;
                                                          _updateuser(data, data.id, imageController.text, data.email, data.userName, data.password, fullNameController.text, nicknameController.text, addressController.text, cityController.text, countryController.text);
                                                          Navigator.push(context, MaterialPageRoute(
                                                              builder: (BuildContext context) {
                                                                return MyDashboard(id: data.id.$oid);
                                                              },settings: RouteSettings(arguments: data))).then((value) => this.setState(() {}));
                                                          setState(() {
                                                            data.city = cityController.text;
                                                            data.country = countryController.text;
                                                          });
                                                        },
                                                        child: Text('Save'))
                                                  ],
                                                )
                                              ],
                                            ),
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
                      icon: Icon(Icons.edit),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                SizedBox(
                  height: 30,
                ),

               SafeArea(
                  child: FutureBuilder(
                    future: mongoDatabase.getShops(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(snapshot.connectionState== ConnectionState.waiting){
                        return Center(child:
                        CircularProgressIndicator(),
                        );
                      } else{
                        if(snapshot.hasData){
                          var totaldata = snapshot.data.length;
                          print("Total data: " + totaldata.toString());
                          for(var i = 0; i < totaldata; i++){
                            if(MongoDbShop.fromJson(snapshot.data[i]).userid == data.id.$oid){
                              shopData = MongoDbShop.fromJson(snapshot.data[i]);
                              shopTagLineController.text = shopData!.shopTagline;
                              shopEmailController.text = shopData!.shopemail;
                              shopWebsiteController.text = shopData!.shopwebsite;
                              shopDescriptionController.text = shopData!.shopDescription;

                              Uint8List bytesshop = base64.decode(shopData!.image);

                              return Container(
                                child:Column(
                                  children: [
                                    SizedBox(height: 30,),
                                    if(data.role == "ShopKeeper")...[
                                      Center(child: Text('Shop Details', style: TextStyle(fontSize: 25),)),
                                      SizedBox(height: 25,),
                                      Center(
                                        child:Stack(
                                          children:[
                                            Container(
                                                width: 130,
                                                height: 130,
                                                child: Column(
                                                  children: [
                                                    if(shopData!.image == "")...[
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
                                                    ]
                                                    else...[
                                                      shopData!.image != "" ? ClipRRect(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child: Image.memory(
                                                          bytesshop!,
                                                          height: 130,
                                                          width: 130,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ) : ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset(height: 130,
                                                          width: 130, 'assets/defaultshop.png'))
                                                    ]

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
                                                                                    onPressed: () {
                                                                                      shopData!.image = "";
                                                                                      _picBase64Image(ImageSource.gallery, 'ShopKeeper');
                                                                                    },
                                                                                    child: Text("Upload Picture")
                                                                                ),
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      shopData!.image = "";
                                                                                      _picBase64Image(
                                                                                          ImageSource
                                                                                              .camera, 'ShopKeeper');
                                                                                    },
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
                                      SizedBox(height: 25,),
                                      FormBuilderTextField(
                                        autovalidateMode:AutovalidateMode.onUserInteraction,
                                        //controller: productnameController,
                                        name: 'shopname',
                                        initialValue: shopData!.shopname,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                            labelText: 'Shop Name'
                                        ),
                                        validator: FormBuilderValidators.compose(
                                            [FormBuilderValidators.required()]),
                                      ),
                                      FormBuilderTextField(
                                        autovalidateMode:AutovalidateMode.onUserInteraction,
                                        controller: shopTagLineController,
                                        onChanged: (value){
                                          shopData!.shopTagline = value.toString();
                                        },
                                        //initialValue: data.city,
                                        name: 'tagLine',
                                        decoration: InputDecoration(
                                            labelText: 'Shop TagLine'
                                        ),

                                      ),
                                      FormBuilderTextField(
                                        autovalidateMode:AutovalidateMode.onUserInteraction,
                                        controller: shopEmailController,
                                        onChanged: (value){
                                          shopData!.shopemail = value.toString();
                                        },
                                        //initialValue: data.city,
                                        name: 'shopemail',
                                        decoration: InputDecoration(
                                            labelText: 'Shop Email'
                                        ),

                                        validator: FormBuilderValidators.compose(
                                            [FormBuilderValidators.email()]),
                                      ),
                                      FormBuilderTextField(
                                        autovalidateMode:AutovalidateMode.onUserInteraction,
                                        controller: shopWebsiteController,
                                        onChanged: (value){
                                          shopData!.shopwebsite = value.toString();
                                        },
                                        //initialValue: data.city,
                                        name: 'website',
                                        decoration: InputDecoration(
                                            labelText: 'Shop Website'
                                        ),

                                        validator: FormBuilderValidators.compose(
                                            [FormBuilderValidators.url(),]),
                                      ),
                                      FormBuilderTextField(
                                        autovalidateMode:AutovalidateMode.onUserInteraction,
                                        controller: shopDescriptionController,
                                        onChanged: (value){
                                          shopData!.shopwebsite = value.toString();
                                        },
                                        //initialValue: data.city,
                                        name: 'description',
                                        decoration: InputDecoration(
                                            labelText: 'Shop Descirption'
                                        ),

                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(onPressed: (){
                                            if(_ImageFileshop  == null){
                                              _base64Imageshop = shopData!.image;
                                            }
                                            else{
                                              shopData!.image = _base64Imageshop;
                                            }
                                            if(_formKey.currentState?.validate() == true) {
                                              _updatename(shopData!, shopData!.image ,fullNameController.text, shopTagLineController.text, shopEmailController.text, shopWebsiteController.text, shopDescriptionController.text);
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    return MyDashboard(id: data.id.$oid);
                                                  },settings: RouteSettings(arguments: data))).then((value) => this.setState(() {}));

                                            }
                                          }, child: Text('Update Shop'))
                                        ],
                                      )
                                    ],
                                  ],
                                ),
                              );
                            }
                          }
                          return Container();
                        }else{
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    },
                  ), //Future builder to fetch data
                ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MyDashboard(id: data.id.$oid);
                          },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                    },
                      child: Text("Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black
                        ),),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context){
                            return PasswordChnagePage();
                          },settings: RouteSettings(arguments: data)))
                          .then((value) => setState(() {}));
                    },
                      child: Text(
                        "Change Pass",style: TextStyle(
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
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _updateuser(MongoDbModel data,var id,String _image,String _email, String _userName, String _password, String _fullname, String _nickname, String _address, String _city, String _country) async{
    print(id);
    print(_userName+_email+_password);
    //final password_update = MongoDbModel(id: id, email: _email, userName: _userName, password: _password);
    final user_update = MongoDbModel(id: id, userimage: _image, email: _email, userName: _userName, password: _password, fullname: _fullname, nickname: _nickname, address: _address, city: _city, country: _country, role: data.role, contactno: data.contactno);

    await mongoDatabase.updateUser(user_update);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile Updated ")));

  }

  Future<void> _updatename(MongoDbShop shopdata, String _image,String _fullname, String _ShopTagline, String _shopemail, String _Shopwebsite, String _Shopdescription) async{
      final name_update = MongoDbShop(id: shopdata.id, userid: shopdata.userid, image: _image, email: shopdata.email, name: _fullname, shopname: shopdata.shopname, shopTagline: _ShopTagline, shopemail: _shopemail, shopwebsite: _Shopwebsite, shopDescription: _Shopdescription, isApproved: shopdata.isApproved, isChecked: shopdata.isChecked, receiptimage: shopdata.receiptimage);
      await mongoDatabase.updateshop(name_update);
  }
}
