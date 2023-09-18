import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fyp_project/DBHelper/mongoDB.dart';
import 'package:fyp_project/MainPages/Reccomendation/recommendationpage.dart';
import 'package:fyp_project/MainPages/serachPage.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:fyp_project/PurchaseModule/BecomeAShopkeeper.dart';
import 'package:fyp_project/PurchaseModule/discount/viewvouchers.dart';
import 'package:fyp_project/ViewProducts/Cart/ShopkeeperOrderPage.dart';
import 'package:fyp_project/ViewProducts/Cart/cartpage.dart';
import 'package:fyp_project/ViewProducts/Cart/viewuserorders.dart';
import 'package:fyp_project/ViewProducts/borrow/ViewBorrowuserequest.dart';
import 'package:fyp_project/ViewProducts/Requests/ViewUserRequests.dart';
import 'package:fyp_project/ViewProducts/categaryPage.dart';
import 'package:fyp_project/MainPages/DraweHeader.dart';
import 'package:fyp_project/Product/upload_product.dart';
import 'package:fyp_project/MainPages/dashboardpage.dart';
import 'package:fyp_project/adminpages/riderrequests.dart';
import 'package:fyp_project/adminpages/shopkeeper%20requests.dart';
import 'package:fyp_project/userActionPages/registerpage.dart';
import 'package:fyp_project/userActionPages/welcomebackpage.dart';
import 'package:fyp_project/Userprofilepages/EditProfilePage.dart';
import 'package:mongo_dart/mongo_dart.dart' as m;

class MyDashboard extends StatefulWidget {
  final String id;
  const MyDashboard({Key? key, required this.id}) : super(key: key);

  @override
  State<MyDashboard> createState() => _MyDashboardState(id);
}


class _MyDashboardState extends State<MyDashboard> {
  String _id;
  _MyDashboardState(this._id);

  var currentPage = drawerSection.dashboard;

  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var container;
    if(currentPage == drawerSection.dashboard){

        container = MydashboardPage(id: _id,);
    }
    if(currentPage == drawerSection.logout){
    }
    MongoDbModel? data = ModalRoute.of(context)?.settings.arguments as MongoDbModel?;


    Future<bool> _onBackButtonPressed() async {
      bool exitapp = await
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to close the App? '),
              actions: <Widget>[
                TextButton(onPressed: (){
                  Navigator.of(context).pop(false);
                }, child: Text('No')),
                TextButton(onPressed: (){
                  SystemNavigator.pop();
                }, child: Text('Yes'))
              ],
            );
          }
      );
      return exitapp ?? false;
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Search Here ...',style: TextStyle(fontWeight: FontWeight.w900),),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return cartPageView(id: _id,);
                      })
                  ).then((value) => setState(() {}));
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CustomSearchDelegate(id: _id,);
                      })
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          )
        ],
        leading: IconButton(
            onPressed: (){
              showGeneralDialog(
                barrierLabel: "menu",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Drawer(
                      width: 300,
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              if(_id == "")...[
                                Container(
                                    color: Colors.blueAccent,
                                    width: double.infinity,
                                    height: 200,
                                    padding: EdgeInsets.only(top: 20),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            TextButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    return myWelcomeBackPage();
                                                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                                            },
                                              child:
                                              Text('LOGIN ', style: TextStyle(color: Colors.grey[200], fontSize: 30),),
                                            ),
                                            Text('/', style: TextStyle(color: Colors.grey[200], fontSize: 30),),
                                            TextButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    //print(text);
                                                    return myRegisterPage();
                                                  }));
                                            },
                                              child:
                                              Text(' SIGNUP', style: TextStyle(color: Colors.grey[200], fontSize: 30),),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                ),
                                drawerList()
                              ]
                              else...[
                                HeaderDrawer(text: _id, userdata: data!,),
                                drawerList()
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(begin: Offset(0, 0), end: Offset(0, 0)).animate(anim1),
                    child: child,
                  );
                },
              );
            },
            icon: Icon(Icons.menu)),
      ),
      body: WillPopScope(
        onWillPop: () =>
            _onBackButtonPressed(),
        child: container,
      ),
    );
  }
  Widget drawerList(){
    MongoDbModel? data = ModalRoute.of(context)?.settings.arguments as MongoDbModel?;
    if (_id == "") {
      return Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            menuItem(data, _id, 1 ,'Dasboard', Icons.dashboard_outlined, currentPage == drawerSection.dashboard ? true : false),
            menuItem(data,_id, 2 ,'Exchange', Icons.people_alt_outlined, currentPage == drawerSection.exchange ? true : false),
            menuItem(data,_id, 7 ,'Purchase', Icons.shopping_cart, currentPage == drawerSection.purchase ? true : false),
            menuItem(data,_id, 8 ,'Borrow', Icons.shopping_bag, currentPage == drawerSection.borrow ? true : false),
            menuItem(data,_id, 3 ,'Donate', Icons.event, currentPage == drawerSection.donate ? true : false),
            Divider(),
            menuItem(data,_id, 17 ,'Recommended', Icons.thumb_up_off_alt_outlined, currentPage == drawerSection.recommended ? true : false),
            menuItem(data,_id, 5 ,'Upload Item', Icons.upload, currentPage == drawerSection.uploadItem ? true : false),
            Divider(),
            menuItem(data,_id, 5 ,'Login', Icons.login, currentPage == drawerSection.login ? true : false),

          ],
        ),
      );

    }
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(data!,_id, 1 ,'Dasboard', Icons.dashboard_outlined, currentPage == drawerSection.dashboard ? true : false),
          menuItem(data!,_id, 2 ,'Exchange', Icons.people_alt_outlined, currentPage == drawerSection.exchange ? true : false),
          menuItem(data!,_id, 7 ,'Purchase', Icons.shopping_cart, currentPage == drawerSection.purchase ? true : false),
          menuItem(data!,_id, 15 ,'Borrow', Icons.shopping_bag, currentPage == drawerSection.borrow ? true : false),

          menuItem(data!,_id, 3 ,'Donate', Icons.event, currentPage == drawerSection.donate ? true : false),
          if(data!.role == "Admin")...[
            menuItem(data!, _id, 14, "Shopkeeper Requests", Icons.request_page_outlined,currentPage == drawerSection.shopkeeperrequests? true:false ),
            menuItem(data!, _id, 19, "Rider Requests", Icons.request_page_outlined,currentPage == drawerSection.shopkeeperrequests? true:false ),

          ]
          else...[Divider(),
            menuItem(data,_id, 17 ,'Recommended', Icons.thumb_up_off_alt_outlined, currentPage == drawerSection.recommended ? true : false),
            menuItem(data!,_id, 9 ,'Requests', Icons.request_page_outlined, currentPage == drawerSection.requestsent ? true : false),
            menuItem(data!,_id, 16 ,'Borrow Requests', Icons.request_page_outlined, currentPage == drawerSection.borrowrequests ? true : false),

            menuItem(data!,_id, 4 ,'Upload Item', Icons.upload, currentPage == drawerSection.uploadItem ? true : false),
            if(data!.role == "Customer" || data!.role == "Admin")...[
              Divider(),
              menuItem(data!,_id, 11, "Become A Shopkeeper", Icons.local_convenience_store, currentPage==drawerSection.becomeashopkeeper? true:false),
              Divider(),
            ],
            menuItem(data!,_id, 12, "View Your Orders", Icons.shopping_cart_checkout, currentPage==drawerSection.orders? true:false),
            if(data!.role == "ShopKeeper" || data!.role == "Admin")...[
              Divider(),
              menuItem(data!,_id, 18, "Discount Vouchers", Icons.discount, currentPage==drawerSection.Discountvouchers? true:false),
              menuItem(data!,_id, 13, "Orders Received", Icons.shop, currentPage==drawerSection.ordersreceived? true:false),
              Divider(),
              menuItem(data!,_id, 10, "Edit Profile", Icons.edit, currentPage==drawerSection.editprofile? true:false),
            ],
          ],
          menuItem(data!,_id, 6 ,'Logout', Icons.upload, currentPage == drawerSection.logout ? true : false),
        ],
      ),
    );
  }
  Widget menuItem(MongoDbModel? data,String _id,int id, String title, IconData icon, bool selected){
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
            if(id == 1){
              currentPage = drawerSection.dashboard;
            }
            else if(id == 2){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return categoryPage(id: _id,type: "Exchange",);
                  }));
            }
            else if(id == 3){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return categoryPage(id: _id,type: "Donate",);
                  }));
            }
            else if(id == 15){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return categoryPage(id: _id,type: "Borrow",);
                  }));
            }
            else if(id == 4) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MyUpload(id: _id,);
                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
                //currentPage = drawerSection.uploadItem;

            }
            else if(id == 5){
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return myWelcomeBackPage();
                    },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
              }
            else if(id == 6) {
              this._id = "";
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return MyDashboard(id: "",);
                  },settings: RouteSettings(arguments: data)));
             // currentPage = drawerSection.logout;
            }
            else if(id == 7){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return categoryPage(id: _id,type: "Purchase",);
                  }));
            }
            else if(id == 8){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return categoryPage(id: _id,type: "Borrow",);
                  }));
            }
            else if(id == 9){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return LoginUserRequests(id: _id,);
                    },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
            }
            else if(id ==10){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return EditProfile(title: 'Edit Profile');
                  },settings: RouteSettings(arguments: data)))
                  .then((value) {setState(() {});});
            }
            else if(id ==11){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return becomeShopKeeperConversion();
                  },settings: RouteSettings(arguments: data)))
                  .then((value) {setState(() {});});
            }
            else if(id == 12){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return userOrdersPage(id: _id);
                  },settings: RouteSettings(arguments: data)))
                  .then((value) {setState(() {});});
            }
            else if(id == 13){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return shopkeeperorderpage(id: _id);
                  },settings: RouteSettings(arguments: data)))
                  .then((value) {setState(() {});});
            }
            else if(id == 14){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return ShopkeeperRequests(id: _id,);
                  },settings: RouteSettings(arguments: data)))
                  .then((value) {setState(() {});});
            }
            else if(id == 16){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return LoginUserBorrowRequests(id: _id,);
                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
            }
            else if(id == 17){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Recommendationselectpage(id: _id,);
                  })
              );
            }
            else if(id == 18){
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ViewdiscountVouchers(id: _id,);
                  })
              );
            }
            else if(id == 19){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context){
                    return RiderRequests(id: _id,);
                  },settings: RouteSettings(arguments: data))).then((value) => setState(() {}));
            }
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(child: Icon(icon, size: 20, color: Colors.black,)),
              Expanded(flex: 3, child: Text(title, style: TextStyle(color: Colors.black, fontSize: 16),))
            ],
          ),
        ),
      ),
    );
  }
  // Widget profileEdit() {
  //   print("_id: "+_id);
  //   return
  // }
}

enum drawerSection{
  dashboard,
  exchange,
  purchase,
  donate,
  borrow,
  uploadItem,
  setting,
  history,
  feedback,
  login,
  logout,
  requestsent,
  editprofile,
  becomeashopkeeper,
  orders,
  ordersreceived,
  shopkeeperrequests,
  borrowrequests,
  recommended,
  Discountvouchers,
  riderrequests
}
