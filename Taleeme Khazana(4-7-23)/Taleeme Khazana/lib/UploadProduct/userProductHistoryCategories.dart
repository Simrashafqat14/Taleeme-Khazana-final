import 'package:flutter/material.dart';
import 'package:fyp_project/UploadProduct/userproducthistory.dart';
import 'package:fyp_project/MainPages/NavigationDrawer.dart';
import 'package:fyp_project/MainPages/serachPage.dart';

class UserProductHistory extends StatefulWidget {
  final String id, type;
  const UserProductHistory({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  State<UserProductHistory> createState() => _UserProductHistoryState(id, type);
}

class _UserProductHistoryState extends State<UserProductHistory> {
  String id, type;
  _UserProductHistoryState(this.id, this.type);

  List<String> images = [
    "assets/librarian.png",
    "assets/uniform.png",
    "assets/bag.png",
    "assets/shoes.png",
    "assets/stati.png",
  ];
  List<String> category = [
    "Books",
    "Uniforms",
    "Bags",
    "Shoes",
    "Stationary"
  ];

  final double itemHeight = 60 / 2;
  final double itemWidth = 50 / 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text('Search Here ...',style: TextStyle(fontWeight: FontWeight.w900),)),
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
    padding: const EdgeInsets.only(top: 10),
    child: Column(
    children: [
    Padding(padding: EdgeInsets.all(20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    FittedBox(
    child: Text(type.toUpperCase(),
    style: TextStyle(color: Colors.blue,
    fontFamily: 'Arvo',
    fontWeight: FontWeight.bold,
    fontSize: 25,)),
    ),
    SizedBox(
    width: 05,
    ),
    ],)),
    if(type == "Exchange")...[
    Padding(
    padding: const EdgeInsets.all(15.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image(
    image: AssetImage(
    'assets/Exchnage.jpg',
    ),
    ),
    ),
    ),
    ],
    if(type == "Purchase")...[
    Padding(
    padding: const EdgeInsets.all(15.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image(
    image: AssetImage(
    'assets/purchase.png'),
    ),
    ),
    ),
    ],
    if(type == "Donate")...[
    Padding(
    padding: const EdgeInsets.all(15.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image(
    image: AssetImage(
    'assets/Donate_Img.jpg'),
    ),
    ),
    ),
    ],

    if(type == "Borrow")...[
    Padding(
    padding: const EdgeInsets.all(15.0),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image(
    image: AssetImage(
    'assets/Borrow.jpg'),
    ),
    ),
    ),
    ],
    Padding(
    padding: const EdgeInsets.only(left: 10,right: 10),

    child: FittedBox(
    child: Text("Select category below you want to explore",
    style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontFamily: 'Arvo',fontSize: 15,),),
    ),
    ),
    SizedBox(height: 20,),
    if(type == "Borrow")...[
    SafeArea(
    child: GridView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: images.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 2.0,
    mainAxisSpacing: 2.0,
    childAspectRatio: (itemWidth / itemHeight),
    ),
    scrollDirection: Axis.vertical,
    itemBuilder: (BuildContext context, int index) {
    if (category[index] == "Books") {
    return TextButton(
    child: Container(
    decoration: BoxDecoration(
    color: Colors.blue.shade300,
    border: Border.all(
    color: Colors.blue.shade300,
    width: 6,
    ),
    borderRadius: BorderRadius.circular(10),),
    child: Column(

    children: [
    Image(image: AssetImage(images[index]),
    width: 150,
    height: 150,),
    Text(category[index],
    style: const TextStyle(color: Colors.blue,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
    fontSize: 20,),
    textAlign: TextAlign.center,

    ),
    ],
    ),
    ),
    onPressed: () {
    print("Books");
    Navigator.push(
    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(
    id: id,
    category: category[index],
    type: type,);
    }));
    },
    );
    }
    //Image.network(images[index]);
    },),
    ),
    ]
    else
    ...[
    SafeArea(
    child: GridView.builder(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: images.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 2.0,
    mainAxisSpacing: 2.0,
    childAspectRatio: (itemWidth / itemHeight),
    ),
    scrollDirection: Axis.vertical,
    itemBuilder: (BuildContext context, int index) {
    return TextButton(
    child: Container(
    decoration: BoxDecoration(
    color: Colors.blue.shade300,
    border: Border.all(
    color: Colors.blue.shade300,
    width: 6,
    ),
    borderRadius: BorderRadius.circular(10),
    ),

    child:Column(
    children: [
    Image(image: AssetImage(images[index]),
    width: 150,
    height: 150,),
    FittedBox(
    child: Text(category[index],
    style: const TextStyle(color: Colors.white,
    fontFamily: 'Arvo',
    fontWeight: FontWeight.bold,
    fontSize: 20,),
    textAlign: TextAlign.center,),
    ),
    ],
    ),),
    onPressed: () {
    if (category[index] == "Books") {
    print("Books");
    Navigator.push(
    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(id: id,
    category: category[index],
    type: type,);
    }));
    }
    if (category[index] == "Uniforms") {
    print("Uniforms");
    Navigator.push(

    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(id: id,
    category: category[index],
    type: type);
    }));
    }
    if (category[index] == "Bags") {
    print("Bags");
    Navigator.push(
    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(id: id,
    category: category[index],
    type: type,);
    }));
    }
    if (category[index] == "Shoes") {
    print("Shoes");
    Navigator.push(

    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(id: id,
    category: category[index],
    type: type,);
    }));
    }
    if (category[index] == "Stationary") {
    print("Stationary");
    Navigator.push(

    context, MaterialPageRoute(
    builder: (BuildContext context) {
    return ProductHistory(id: id,
    category: category[index],
    type: type,);
    }));
    }
    },
    );
    //Image.network(images[index]);
    },),
    ),
    ]
    ]
    ),
    ));
  }
}
