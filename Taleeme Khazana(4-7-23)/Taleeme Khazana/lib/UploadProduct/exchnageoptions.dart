import 'package:flutter/material.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/UploadProduct/Uploadpage.dart';

class exchandOptionsPage extends StatefulWidget {
  final String id, type;
  const exchandOptionsPage({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  State<exchandOptionsPage> createState() => _exchandOptionsPageState(id, type);
}

class _exchandOptionsPageState extends State<exchandOptionsPage> {
  String id, type;
  _exchandOptionsPageState(this.id, this.type);
  List<String> NumberofProducts=[
    "Single Prduct",
    "Mutliple Product"
  ];

  @override
  Widget build(BuildContext context) {
    MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;

    return  Scaffold(
      appBar: AppBar(
        title: Text('Upload Products'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Select type for Exchange', style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold, fontSize: 30,),textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              child: Container(
                // height: 60,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset("assets/single.png"),
                      TextButton(onPressed: (){
                        print("Exchange");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return UploadPage(id: id, type: "Exchange", isGrouped: false);
                            },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                      },
                        child: Text('Single Product', style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                      ),
                      /* IconButton(
                        color: Colors.blueAccent,
                        onPressed: (){
                          print("Exchange");
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context){
                                return UploadPage(id: id, type: "Exchange", isGrouped: false,);
                              }));
                        },
                        icon: Icon(Icons.skip_next, color: Colors.white,),
                      ),*/
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
                height: 140,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset("assets/multipleProduct.png"),
                      TextButton(onPressed: (){
                        print("Exchange");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return UploadPage(id: id, type: "Exchange", isGrouped: true,);
                            },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                      },
                        child: Text('Grouped Product', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
