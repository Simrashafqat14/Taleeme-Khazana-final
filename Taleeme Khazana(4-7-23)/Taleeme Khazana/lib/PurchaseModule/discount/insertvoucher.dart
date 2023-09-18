import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/discountvoucher.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:fyp_project/DBHelper/mongoDB.dart';


class insertdiscountvoucherpage extends StatefulWidget {
  final String id;
  const insertdiscountvoucherpage({Key? key, required this.id}) : super(key: key);

  @override
  State<insertdiscountvoucherpage> createState() => _insertdiscountvoucherpageState(id);
}

class _insertdiscountvoucherpageState extends State<insertdiscountvoucherpage> {
  String userid;
  _insertdiscountvoucherpageState(this.userid);
  final _formKey = GlobalKey<FormBuilderState>();
  bool type = false;
  var dicountnameController = new TextEditingController();
  var amountController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    String Shopid;

    Widget Heading = Text('Add a Voucher',
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

                    FormBuilderTextField(
                      autovalidateMode: AutovalidateMode.disabled,

                      controller: dicountnameController,
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
                    Row(
                      children: [
                        Text('Discount Type: '.padLeft(10), style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: (){
                          setState(() {
                            type = !type;
                            print('amount '+type.toString());
                          });
                        },
                            child: Row(
                              children: [
                                Icon(type ? Icons.check_box_outline_blank : Icons.check_box, color: Colors.black,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Amount', style: TextStyle(color: Colors.black, fontSize: 15),),
                              ],
                            )
                        ),
                        TextButton(onPressed: (){
                          setState(() {
                            type = !type;
                            print('percentage'+type.toString());
                          });
                        },
                            child: Row(
                              children: [
                                Icon(type ? Icons.check_box : Icons.check_box_outline_blank, color: Colors.black,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Percentage', style: TextStyle(color: Colors.black, fontSize: 15),),
                              ],
                            )
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FormBuilderTextField(
                          autovalidateMode: AutovalidateMode.disabled,
                          controller: amountController,
                          name: 'stock',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Enter amount'
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
                    SizedBox(
                      height: 20,
                    ),
                    SafeArea(
                      child: FutureBuilder(
                          future: mongoDatabase.getShops(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child:
                              CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.hasData) {
                                var totaldata = snapshot.data.length;
                                print("Total data: " + totaldata.toString());
                                for (var i = 0; i < totaldata; i++) {
                                  if(MongoDbShop.fromJson(snapshot.data[i]).userid == userid){
                                    Shopid = MongoDbShop.fromJson(snapshot.data[i]).id.$oid;
                                    return Container(
                                      child: TextButton(onPressed: () {
                                        print(dicountnameController.text);
                                        print(amountController.text);
                                        print(type);
                                        if(_formKey.currentState?.validate() == true){
                                          if(type == true){
                                            if(int.parse(amountController.text) > 100 || int.parse(amountController.text) < 1){
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text("In percentage the amount should be less than 100")));
                                            }
                                            else{
                                              _insertvoucher(userid, Shopid, dicountnameController.text, amountController.text, type);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text("Discount Voucher Added")));
                                            }
                                          }
                                          else{
                                            _insertvoucher(userid, Shopid, dicountnameController.text, amountController.text, type);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("Discount Voucher Added")));
                                          }
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
                                    );
                                  }
                                }
                              }
                              return Container();
                            }
                          }
                      ), //Future builder to fetch data
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );


    return Scaffold(
        appBar: AppBar(
          title: Text('Search here',),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CustomSearchDelegate(id: userid,);
                    }));

              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: formBody
    );
  }

  Future<void> _insertvoucher(String userid, String shopid, String _discountname,String _amount, bool _type  ) async {
    var _id = mongo.ObjectId();
    final data = Mongodbdiscount(id: _id, name: _discountname, userid: userid, shopid: shopid, amount: _amount, type: _type);
    var result = await mongoDatabase.insert_discountvoucher(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Product Uploaded ")));
  }

}
