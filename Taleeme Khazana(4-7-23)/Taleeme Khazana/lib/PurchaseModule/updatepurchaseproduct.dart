import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:image_picker/image_picker.dart';

class purchaseproductUpdatePage extends StatefulWidget {
  final String type, category;
  const purchaseproductUpdatePage({Key? key, required this.type, required this.category}) : super(key: key);

  @override
  State<purchaseproductUpdatePage> createState() => _purchaseproductUpdatePageState(type, category);
}

class _purchaseproductUpdatePageState extends State<purchaseproductUpdatePage> {
  String type,category;
  _purchaseproductUpdatePageState(this.type,this.category);
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
  Color mycolor = Colors.white;
  Widget innerChangingFields = Container();

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
    MongoDbPurchasableProducts data = ModalRoute.of(context)!.settings.arguments as MongoDbPurchasableProducts;
    productnameController.text = data.productname;
    producrdescriptionController.text = data.productdescription;
    productPriceController.text = data.productprice;
    productsalePriceController.text = data.saleprice;
    stockController.text = data.stock;
    extrainformationController.text = data.extrainformation;
    bookauthorController.text = data.bookauthor;
    shoeSizeController.text = data.shoesSize;
    shoetypecontroller = data.shoesType;
    uniformsizeController = data.uniformSize;
    bagSizeController = data.bagsize;
    bookTypeController = data.booktype;
    genderController = data.gender;
    Color currcolor = Color(int.parse(data.color));
    bool onSale = data.onSale;
    bool islimited = data.islimited;
    int price = int.parse(data.productprice);

    Uint8List bytes = base64.decode(data.image);

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
                        pickerColor: Color(int.parse(data.color)), //default color
                        onColorChanged: (Color color){ //on color picked
                          setState(() {
                            mycolor = color;
                            print('color: ');
                            print(mycolor.value);
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
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
              Row(
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
                        Icon(Icons.circle, color: currcolor, ),
                      )
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Current Color', style: TextStyle(color: Colors.black, fontSize: 15,),),
                ],
              ),
            ],
          ),
        ),
        if(category != "Stationary")...[
          FormBuilderDropdown(
            name: 'gender',
            initialValue: genderController,
            onChanged: (value){
              genderController = value;
              print(genderController);
            },
            decoration: InputDecoration(
                labelText: 'Gender'
            ),
            //allowClear: true,
            items: genderOption.map((genderOptions) =>
                DropdownMenuItem(value: genderOptions,child: Text('$genderOptions'))
            ).toList(),
          ),
        ]
      ],
    );


    Widget uniformfields =  Column(
      children: [
        if(category == "Uniforms")...[
          FormBuilderDropdown(
              name: 'uniformsize',
              initialValue: uniformsizeController,
              onChanged: (value){
                uniformsizeController = value;
                print(uniformsizeController);
              },
              decoration: InputDecoration(
                  labelText: 'Select size'
              ),
              //allowClear: true,
              items: uniformSizeOption.map((uniformSizeOptions) =>
                  DropdownMenuItem(value: uniformSizeOptions,child: Text('$uniformSizeOptions'))
              ).toList()
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields
        ]
      ],
    );

    Widget BooksFields = Column(
      children: [
        if(category == "Books")...[
          TextField(
            controller: bookauthorController,
            decoration: InputDecoration(labelText: 'Author Name'),
          ),
          SizedBox(
            height: 20,
          ),
          FormBuilderDropdown(
              name: 'BookType',
              initialValue: bookTypeController,
              onChanged: (value){
                bookTypeController = value;
                print(bookTypeController);
              },
              decoration: InputDecoration(
                  labelText: 'Book Type'
              ),
              //allowClear: true,
              items: bookTypeOption.map((bookTypeOptions) =>
                  DropdownMenuItem(value: bookTypeOptions,child: Text('$bookTypeOptions'))
              ).toList()
          ),
          SizedBox(
            height: 20,
          ),
        ]
      ],
    );

    Widget ShoesFields = Column(
      children: [
        if(category == "Shoes")...[
          TextField(
            controller: shoeSizeController,
            decoration: InputDecoration(labelText: 'Enter Shoe size'),
          ),
          SizedBox(
            height: 20,
          ),
          FormBuilderDropdown(
              initialValue: shoetypecontroller,
              onChanged: (value){
                shoetypecontroller = value;
                print(shoetypecontroller);
              },
              name: 'shoetype',
              decoration: InputDecoration(
                  labelText: 'Shoes Type:'
              ),
              //allowClear: true,
              items: shoeTypeOption.map((shoeTypeOptions) =>
                  DropdownMenuItem(value: shoeTypeOptions,child: Text('$shoeTypeOptions'))
              ).toList()
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields
        ]
      ],
    );

    Widget BagsFields = Column(
      children: [
        if(category == "Bags")...[
          FormBuilderDropdown(
              initialValue: bagSizeController,
              onChanged: (value){
                bagSizeController = value;
                print(bagSizeController);
              },
              name: 'bagsize',
              decoration: InputDecoration(
                  labelText: 'Bag Size:'
              ),
              //allowClear: true,
              items: bagSizeOption.map((bagSizeOptions) =>
                  DropdownMenuItem(value: bagSizeOptions,child: Text('$bagSizeOptions'))
              ).toList()
          ),
          SizedBox(
            height: 20,
          ),
          innerChangingFields
        ]
      ],
    );

    Widget StationaryFields = Column(
      children: [
        if(category == "Stationary")...[
         innerChangingFields
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
              Text('Update ' + category,
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                  fontSize: 40,), textAlign: TextAlign.center,),
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
                height: 20,
              ),
              TextField(
                controller: producrdescriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: productPriceController,
                name: 'productrice',
                onChanged: (value){
                  price = int.parse(value!)-1;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Enter product price',
                  prefixText: 'Rs/-  '
                ),
                validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(),
                      FormBuilderValidators.integer()]),
              ),
              TextButton(onPressed: (){
                setState(() {
                  productPriceController.text = price.toString();
                  data.onSale = !data.onSale;
                  print(data.onSale);
                });
              },
                  child: Row(
                    children: [
                      Icon(data.onSale ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.black,),
                      SizedBox(
                        width: 10,
                      ),
                      Text('OnSale', style: TextStyle(color: Colors.black, fontSize: 15),),
                    ],
                  )
              ),
              Visibility(
                visible: data.onSale,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      data.islimited = !data.islimited;
                      print('Unlimited'+data.islimited.toString());
                    });
                  },
                      child: Row(
                        children: [
                          Icon(data.islimited ? Icons.check_box_outline_blank : Icons.check_box, color: Colors.black,),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Unlimited', style: TextStyle(color: Colors.black, fontSize: 15),),
                        ],
                      )
                  ),
                  TextButton(onPressed: (){
                    setState(() {
                      data.islimited = !data.islimited;
                      print('Limited'+data.islimited.toString());
                    });
                  },
                      child: Row(
                        children: [
                          Icon(data.islimited ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.black,),
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
                visible: data.islimited,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
              TextField(
                controller: extrainformationController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Other Details (Optional)'),
              ),
              SizedBox(
                height: 20,
              ),
              uniformfields,
              ShoesFields,
              BooksFields,
              BagsFields,
              StationaryFields,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  ElevatedButton(onPressed: (){
                    if(onSale == false){
                      productsalePriceController.clear();
                    }
                    if(islimited == false){
                      stockController.clear();
                    }

                    print("Name:" + productnameController.toString());
                    print('description'+producrdescriptionController.toString());
                    print('price: '+productPriceController.toString());
                    print('onsale: '+onSale.toString());
                    print('sale price: '+productsalePriceController.toString());
                    print('islimites: '+islimited.toString());
                    print('stock: '+stockController.toString());
                    print('extrainformation: '+extrainformationController.toString());
                    print('bagsize: '+bagSizeController.toString());
                    print('book type: '+bookTypeController.toString());
                    print('bookauthor: '+bookauthorController.toString());
                    print('uniform size: '+uniformsizeController.toString());
                    print('Shoe size: '+shoeSizeController.toString());
                    print('shoe type: '+shoetypecontroller.toString());
                    print('gender: '+genderController.toString());
                    print('color: '+ mycolor.value.toString());

                    if(_ImageFile == null){
                      _base64Image = data.image;
                    }
                    else{
                      data.image = _base64Image;
                    }

                    _updateProduct(data.id, data.userid, data.productcategory, productnameController.text, producrdescriptionController.text,
                        data.image, productPriceController.text, productsalePriceController.text, onSale,
                        islimited, stockController.text, extrainformationController.text, data.dateTime,
                        bagSizeController.toString(), bookTypeController.toString(), bookauthorController.text,
                        uniformsizeController.toString(), shoeSizeController.text, shoetypecontroller.toString(),
                        genderController.toString(), mycolor.value.toString());

                  }, child: Text("Update")),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct(var id, String userid, String _category, String _productname,String _productDescription, String _image, String _price, String _saleprice, bool _onsale, bool _islimited, String _stock, String _extrainformation, String _datetime, String _bagsize, String _booktype, String _bookauthor, String _unifomrsize, String _shoesize, String _shoestype, String _gender, String _color  ) async {
    final update_product = MongoDbPurchasableProducts(id: id, userid: userid, productcategory: _category, image: _image, productname: _productname, productdescription: _productDescription, productprice: _price, saleprice: _saleprice, onSale: _onsale, islimited: _islimited, stock: _stock, extrainformation: _extrainformation, dateTime: _datetime, bagsize: _bagsize, booktype: _booktype, bookauthor: _bookauthor, uniformSize: _unifomrsize, shoesSize: _shoesize, shoesType: _shoestype, gender: _gender, color: _color);
    await mongoDatabase.updatepurchaseProduct(update_product).whenComplete(() => Navigator.pop(context));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Updated ")));
  }

}
