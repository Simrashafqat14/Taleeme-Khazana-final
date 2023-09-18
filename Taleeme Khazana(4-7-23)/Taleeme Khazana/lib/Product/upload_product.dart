import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/PurchaseModule/purchaseuploadpage.dart';
import 'package:fyp_project/UploadProduct/Uploadpage.dart';
import 'package:fyp_project/UploadProduct/borrow/borrow%20upload.dart';
import 'package:fyp_project/UploadProduct/exchnageoptions.dart';
import 'package:fyp_project/ViewProducts/categoryProducts.dart';

import '../MainPages/NavigationDrawer.dart';
import '../MainPages/categorySection.dart';
import 'package:fyp_project/MainPages/serachPage.dart';


class MyUpload extends StatefulWidget {
  final String id;
  const MyUpload({Key? key, required this.id}) : super(key: key);

  @override
  State<MyUpload> createState() => _MyUploadState(id);
}

class _MyUploadState extends State<MyUpload> {
  String id;
  _MyUploadState(this.id);
  List<String> images=[
    "assets/images.jpg",
    "assets/pur.png",
    "assets/donate1.jpg",
    "assets/Borrow_img.png",

  ];
  List<String> category=[
    "Exchange",
    "Purchase",
    "Donate",
    "Borrow",
  ];


  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
    print(data.role);
    print('id'+ id);
    return Scaffold(
        appBar: AppBar(
          title: Text('Search here',),
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CustomSearchDelegate(id: id,);
                    }));

              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
              children: [
                const SizedBox(
                  height:30,
                ),
                Text("Select category for uploading the product",style: TextStyle(color:Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 30),),
                SafeArea(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      childAspectRatio: (1 / 1.25),
                    ),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index){
                      return
                        TextButton(
                          child: Column(
                            children: [
                              Image(image: AssetImage(images[index]),width: 150,height: 150,),
                              Text(category[index], style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 20,), textAlign: TextAlign.center,),
                            ],
                          ),
                          onPressed: (){
                            if(category[index] == "Exchange"){
                              print("Exchange");
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context){
                                    return exchandOptionsPage(id:id, type: "Exchange",);
                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                            if(category[index] == "Purchase") {
                              print("Purchase");
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (BuildContext context) {
                                  return uploadPurchasePage(id: id, type: "Purchase",);
                                },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));


                            }
                            if(category[index] == "Donate"){
                              print("Donate");
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (BuildContext context) {
                                return UploadPage(id: id, type: "Donate", isGrouped: false,);
                              },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                            if(category[index] == "Borrow"){
                              print("Borrow");
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (BuildContext context) {
                                return UploadborrowPage(id: id, type: "Borrow", isGrouped: false,);
                              },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                            }
                          },
                        );
                      //Image.network(images[index]);
                    },),
                ),
                SizedBox(
                  height: 70,
                ),
                Padding(padding: EdgeInsets.only(top:10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text('Taleem-e-Khazana',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.blueAccent),)]))
              ]),
        )
    );
  }
}
/*Flexible(
              child: Container(
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                */
/*child: Container(

                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                        print("Exchange");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return exchandOptionsPage(id: id, type: "Exchange",);
                            }));
                      },
                          child: Text('EXCHANGE', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                      ),
                      IconButton(
                        color: Colors.blueAccent,
                        onPressed: (){
                          print("Exchange");
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context){
                                return exchandOptionsPage(id: id, type: "Exchange",);
                              }));
                        },
                        icon: Icon(Icons.skip_next, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),*/

/*SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Container(

                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){

                      },
                          child: Text('PURCHASE', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                      ),
                      IconButton(
                        color: Colors.blueAccent,
                        onPressed: (){
                        },
                        icon: Icon(Icons.skip_next, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Container(

                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                        print("Donate");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return UploadPage(id: id, type: "Donate", isGrouped: false,);
                            }));
                      },
                          child: Text('DONATE', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                      ),
                      IconButton(
                        color: Colors.blueAccent,
                        onPressed: (){
                          print("Donate");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context){
                                return UploadPage(id: id, type: "Donate", isGrouped: false,);
                              }));
                        },
                        icon: Icon(Icons.skip_next, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Container(

                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: (){
                      },
                          child: Text('BORROW', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,)
                      ),
                      IconButton(
                        color: Colors.blueAccent,
                        onPressed: (){
                        },
                        icon: Icon(Icons.skip_next, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/

