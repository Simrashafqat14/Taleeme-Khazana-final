import 'dart:convert';
import 'dart:developer';

import 'package:fyp_project/MongoDBModels/MongoDbBorrow.dart';
import 'package:fyp_project/MongoDBModels/MongoDbRider.dart';
import 'package:fyp_project/MongoDBModels/PurchaseProducts.dart';
import 'package:fyp_project/MongoDBModels/Shops.dart';
import 'package:fyp_project/MongoDBModels/borrowrequests.dart';
import 'package:fyp_project/MongoDBModels/cartmodel.dart';
import 'package:fyp_project/MongoDBModels/discountvoucher.dart';
import 'package:fyp_project/MongoDBModels/ordermodel.dart';
import 'package:fyp_project/MongoDBModels/products.dart';
import 'package:fyp_project/MongoDBModels/requestmodel.dart';
import 'package:fyp_project/MongoDBModels/reviews.dart';
import 'package:fyp_project/MongoDBModels/users.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:fyp_project/DBHelper/constraint.dart';

class mongoDatabase{
  static var db, userCollection, productcollection, requestcollection,
      reviewcollection, shopcollection, shopproductscollection, cartcollection, ordercollection,
  borrowcollection, borrowrequestcollection, discountcollection, riderCollection, orderrequesttakenbyridercollection;
  static connect()async{
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    print(status);
    userCollection = db.collection(USER_COLLECTION);
    //print(await userCollection.find().toList());
    productcollection = db.collection(PRODUCT_COLLECTION);
    //print(await productcollection.find().toList());
    requestcollection = db.collection(REQUEST_COLLECTION);
    //print(await requestcollection.find().toList());
    reviewcollection = db.collection(REVIEW_COLLECTION);
    //print(await reviewcollection.find().toList());
    shopcollection = db.collection(SHOP_COLLECTION);
    // print("shopcollection: ");
    // print(await shopcollection.find().toList());
    shopproductscollection = db.collection(SHOP_PRODUCTS_COLLECTION);
    // print("shop products collection: ");
    // print(await shopproductscollection.find().toList());
    cartcollection = db.collection(CART_COLLECTION);
    // print("Cart collection: ");
    // print(await cartcollection.find().toList());
    ordercollection = db.collection(ORDER_COLLECTION);
    // print("order collection: ");
    // print(await ordercollection.find().toList());
    borrowcollection = db.collection(BORROW_COLLECTION);
    //print("borrow collection: ");
    //print(await borrowcollection.find().toList());
    borrowrequestcollection = db.collection(BORROW_REQUEST_COLLECTION);
    //print("borrow Request collection: ");
    //print(await borrowrequestcollection.find().toList());
    discountcollection = db.collection(DISCOUNT_VOUCHER_COLLECTION);
    //print("discount collection: ");
    //print(await discountcollection.find().toList());
    riderCollection = db.collection(RIDER_COLLECTION);
    // print("rider collection: ");
    // print(await riderCollection.find().toList());
    orderrequesttakenbyridercollection = db.collection(ORDER_REQUESTS_TAKEN_BY_RIDER_COLLECTION);
    print("orderrequesttakenbyridercollection: ");
    print(await orderrequesttakenbyridercollection.find().toList());
  }



  //search
  static Future<List<Map<String, dynamic>>> searchProducts(var name, String type) async {
    print(name);
    final arrData = await productcollection.find(where.match("productname", name.toString()).eq("productype", type)).toList();
    //eq for equal
    //gt for greater
    return arrData;
  }
  static Future<List<Map<String, dynamic>>> filterProducts(var name,String type, String filter, String Category) async {
    print(filter);
    print(type);
    print(Category);
    if(filter == "Author Name"){
      final arrData = await productcollection.find(where.match("authorname", name.toString()).eq("productcategory", Category).eq("productype", type)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Uniform Size"){
      final arrData = await productcollection.find(where.match("uniformSize", name.toString()).eq("productcategory", Category).eq("productype", type)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Shoe Size"){
      final arrData = await productcollection.find(where.match("shoesSize", name.toString()).eq("productcategory", Category).eq("productype", type)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Gender"){
      final arrData = await productcollection.find(where.match("gender", name.toString()).eq("productcategory", Category).eq("productype", type)).toList();//eq for equal
      return arrData;
    }
    else{
      final arrData = await productcollection.find().toList();//eq for equal
      return arrData;
    }
  }
  static Future<List<Map<String, dynamic>>> searchpuchaseProducts(var name) async {
    print(name);
    final arrData = await shopproductscollection.find(where.match("productname", name.toString())).toList();
    //eq for equal
    //gt for greater
    return arrData;
  }
  static Future<List<Map<String, dynamic>>> filterpuchaseProducts(var name, String filter, String Category) async {
    print(filter);
    if(filter == "Author Name"){
      final arrData = await shopproductscollection.find(where.match("bookauthor", name.toString()).eq("productcategory", Category)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Uniform Size"){
      final arrData = await shopproductscollection.find(where.match("uniformSize", name.toString()).eq("productcategory", Category)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Shoe Size"){
      final arrData = await shopproductscollection.find(where.match("shoesSize", name.toString()).eq("productcategory", Category)).toList();//eq for equal
      return arrData;
    }
    if(filter == "Gender"){
      final arrData = await shopproductscollection.find(where.match("gender", name.toString()).eq("productcategory", Category)).toList();//eq for equal
      return arrData;
    }
    else{
      final arrData = await shopproductscollection.find().toList();//eq for equal
      return arrData;
    }
  }
  static Future<List<Map<String, dynamic>>> searchBorrowProducts(var name) async {
    print(name);
    final arrData = await borrowcollection.find(where.match("bookname", name.toString())).toList();//eq for equal
    return arrData;
  }
  static Future<List<Map<String, dynamic>>> filterBorrowProducts(var name, String filter) async {
    print(filter);
    if(filter == "Author Name"){
      final arrData = await borrowcollection.find(where.match("authorname", name.toString())).toList();//eq for equal
      return arrData;
    }
    else{
      final arrData = await borrowcollection.find().toList();//eq for equal
      return arrData;
    }
  }


  //user
  static Future<String> insert(MongoDbModel data) async{
    try{
      var result = await userCollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> login() async {
    final arrData = await userCollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }

  static Future<void> forgetpassword (MongoDbModel data) async{

    await userCollection.update(where.eq("_id", data.id), modify.set("password", data.password));
  }

  static Future<void> updaterole (MongoDbModel data) async{

    await userCollection.update(where.eq("_id", data.id), modify.set("role", data.role));
  }

  static Future<void> updateUser (MongoDbModel data) async{


    await userCollection.update(where.eq("_id", data.id), modify.set("userimage", data.userimage));
    await userCollection.update(where.eq("_id", data.id), modify.set("email", data.email));
    await userCollection.update(where.eq("_id", data.id), modify.set("userName", data.userName));
    await userCollection.update(where.eq("_id", data.id), modify.set("password", data.password));
    await userCollection.update(where.eq("_id", data.id), modify.set("fullname", data.fullname));
    await userCollection.update(where.eq("_id", data.id), modify.set("nickname", data.nickname));
    await userCollection.update(where.eq("_id", data.id), modify.set("address", data.address));
    await userCollection.update(where.eq("_id", data.id), modify.set("city", data.city));
    await userCollection.update(where.eq("_id", data.id), modify.set("country", data.country));

  }

//product queries
  static Future<String> insert_product(MongoDbProducts data) async{
    try{
      var result = await productcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getProductbytypeandstatus(String type, bool status) async {
    final arrData = await productcollection.find(where.eq("productype",type).eq("isaccapted",status)).toList();
    print(arrData.length);
    return arrData;
  }


  static Future<List<Map<String, dynamic>>> getProductbycategory(String category, String type, bool status) async {
    final arrData = await productcollection.find(where.eq("productcategory",category).eq("productype", type).eq("isaccapted",status)).toList();
    print(arrData.length);

    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getProductbyuser(String userid, bool status) async {
    final arrData = await productcollection.find(where.eq("userid",userid).eq("isaccapted",status)).toList();
    print(arrData.length);

    return arrData;
  }


  static Future<List<Map<String, dynamic>>> getProductbyuserandtype(String userid, String type, bool status) async {
    final arrData = await productcollection.find(where.eq("userid",userid).eq("productype", type).eq("isaccapted",status)).toList();
    print(arrData.length);

    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final arrData = await productcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }


  static Future<void> updateProduct (MongoDbProducts data) async{


    await productcollection.update(where.eq("_id", data.id), modify.set("userid", data.userid));
    await productcollection.update(where.eq("_id", data.id), modify.set("productcategory", data.productcategory));
    await productcollection.update(where.eq("_id", data.id), modify.set("productype", data.productype));
    await productcollection.update(where.eq("_id", data.id), modify.set("image", data.image));
    await productcollection.update(where.eq("_id", data.id), modify.set("productname", data.productname));
    await productcollection.update(where.eq("_id", data.id), modify.set("productdescription", data.productdescription));
    await productcollection.update(where.eq("_id", data.id), modify.set("productcondition", data.productcondition));
    await productcollection.update(where.eq("_id", data.id), modify.set("authorname", data.authorname));
    await productcollection.update(where.eq("_id", data.id), modify.set("booksubject", data.booksubject));
    await productcollection.update(where.eq("_id", data.id), modify.set("noofpages", data.noofpages));
    await productcollection.update(where.eq("_id", data.id), modify.set("uniformSize", data.uniformSize));
    await productcollection.update(where.eq("_id", data.id), modify.set("schoolname", data.schoolname));
    await productcollection.update(where.eq("_id", data.id), modify.set("shoesSize", data.shoesSize));
    await productcollection.update(where.eq("_id", data.id), modify.set("shoesstyle", data.shoesstyle));
    await productcollection.update(where.eq("_id", data.id), modify.set("bagtype", data.bagtype));
    await productcollection.update(where.eq("_id", data.id), modify.set("stationaryname", data.stationaryname));
    await productcollection.update(where.eq("_id", data.id), modify.set("noofitemsstationary", data.noofitemsstationary));
    await productcollection.update(where.eq("_id", data.id), modify.set("grade", data.grade));
    await productcollection.update(where.eq("_id", data.id), modify.set("gender", data.gender));
    await productcollection.update(where.eq("_id", data.id), modify.set("color", data.color));
    await productcollection.update(where.eq("_id", data.id), modify.set("extrainformation", data.extrainformation));
    await productcollection.update(where.eq("_id", data.id), modify.set("exchangereason", data.exchangereason));
    await productcollection.update(where.eq("_id", data.id), modify.set("exchangesource", data.exchangesource));
    await productcollection.update(where.eq("_id", data.id), modify.set("requiredamountorproduct", data.requiredamountorproduct));
    await productcollection.update(where.eq("_id", data.id), modify.set("dateTime", data.dateTime));
    await productcollection.update(where.eq("_id", data.id), modify.set("isaccapted", data.isaccapted));
    await productcollection.update(where.eq("_id", data.id), modify.set("buyerid", data.buyerid));


  }

  static deleteProduct(MongoDbProducts data) async {
    await productcollection.deleteOne({"_id": data.id});
  }


  //Requests
  static Future<String> insertRequest(Requests data) async{
    try{
      var result = await requestcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }
  static Future<List<Map<String, dynamic>>> getRequests() async {
    final arrData = await requestcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }


  static deleterequest(Requests data) async {
    await requestcollection.deleteOne({"_id": data.id});
  }

  static Future<void> acceptrequest (Requests data) async{

    await requestcollection.update(where.eq("_id", data.id), modify.set("isaccepted", data.isaccepted));

  }


  //review
  static Future<String> insertreview(Reviewmodel data) async{
    try{
      var result = await reviewcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }
  static Future<List<Map<String, dynamic>>> getReviews() async {
    final arrData = await reviewcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }


  //shops
  static Future<String> insertShop(MongoDbShop data) async{
    try{
      var result = await shopcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<void> updateshop (MongoDbShop data) async{

    await shopcollection.update(where.eq("_id", data.id), modify.set("name", data.name));
    await shopcollection.update(where.eq("_id", data.id), modify.set("shopTagline", data.shopTagline));
    await shopcollection.update(where.eq("_id", data.id), modify.set("shopemail", data.shopemail));
    await shopcollection.update(where.eq("_id", data.id), modify.set("shopwebsite", data.shopwebsite));
    await shopcollection.update(where.eq("_id", data.id), modify.set("shopDescription", data.shopDescription));
    await shopcollection.update(where.eq("_id", data.id), modify.set("image", data.image));
    await shopcollection.update(where.eq("_id", data.id), modify.set("isApproved", data.isApproved));


  }

  static Future<List<Map<String, dynamic>>> getShops() async {
    final arrData = await shopcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }


  //purchase products
  static Future<String> insert_purchase_product(MongoDbPurchasableProducts data) async{
    try{
      var result = await shopproductscollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getpurchasableProduct() async {
    final arrData = await shopproductscollection.find().toList();
    print(arrData.length);
    return arrData;
  }


  static Future<List<Map<String, dynamic>>> getpurchasableProductbycategory(String category) async {
    final arrData = await shopproductscollection.find(where.eq("productcategory",category)).toList();
    print(arrData.length);

    return arrData;
  }


  static deletepurchaseProduct(MongoDbPurchasableProducts data) async {
    await shopproductscollection.deleteOne({"_id": data.id});
  }


  static Future<void> updatepurchaseProduct (MongoDbPurchasableProducts data) async{


    await shopproductscollection.update(where.eq("_id", data.id), modify.set("userid", data.userid));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("productcategory", data.productcategory));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("image", data.image));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("productname", data.productname));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("productdescription", data.productdescription));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("productprice", data.productprice));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("saleprice", data.saleprice));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("onSale", data.onSale));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("islimited", data.islimited));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("stock", data.stock));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("extrainformation", data.extrainformation));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("bagsize", data.bagsize));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("booktype", data.booktype));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("bookauthor", data.bookauthor));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("uniformSize", data.uniformSize));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("shoesSize", data.shoesSize));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("shoesType", data.shoesType));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("gender", data.gender));
    await shopproductscollection.update(where.eq("_id", data.id), modify.set("color", data.color));

  }

  static Future<List<Map<String, dynamic>>> getpurchaseProductbyuser(String userid) async {
    final arrData = await shopproductscollection.find(where.eq("userid",userid)).toList();
    print(arrData.length);

    return arrData;
  }


  static Future<List<Map<String, dynamic>>> getpurchaseProductbyuserandonsale(String userid, bool onsale) async {
    final arrData = await shopproductscollection.find(where.eq("userid",userid).eq("onSale", onsale)).toList();
    print(arrData.length);

    return arrData;
  }





  //cart
  static Future<String> addtocart(CartModel data) async{
    try{
      var result = await cartcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getcartbyuser(String userid) async {
    final arrData = await cartcollection.find(where.eq("userid",userid)).toList();
    print(arrData.length);

    return arrData;
  }

    static deletefromcart(CartModel data) async {
    await cartcollection.deleteOne({"_id": data.id});
  }

  static Future<void> updatecart (CartModel data) async{



    await cartcollection.update(where.eq("_id", data.id), modify.set("productid", data.productid));
    await cartcollection.update(where.eq("_id", data.id), modify.set("productname", data.productname));
    await cartcollection.update(where.eq("_id", data.id), modify.set("singleprice", data.singleprice));
    await cartcollection.update(where.eq("_id", data.id), modify.set("quantity", data.quantity));
    await cartcollection.update(where.eq("_id", data.id), modify.set("price", data.price));
    await cartcollection.update(where.eq("_id", data.id), modify.set("stock", data.stock));

  }

  static deletefromcartbyuserid(String userid) async {
    await cartcollection.deleteOne({"userid": userid});
  }


  //order
  static Future<String> orderconfimration(MongoDbOrder data) async{
    try{
      var result = await ordercollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }



  static Future<List<Map<String, dynamic>>> getorderbyinvoice(int invoice) async {
    final arrData = await ordercollection.find(where.eq("Invoice No",invoice)).toList();
    print(arrData.length);

    return arrData;
  }

  //get order for the user who placed the order
  static Future<List<Map<String, dynamic>>> getordersbystatusandid(bool status, String userid) async {
    final arrData = await ordercollection.find(where.eq("status",status).eq("userid",userid)).toList();
    print(arrData.length);
    return arrData;
  }

  //get data fof the user to ehich the product belongs to
  static Future<List<Map<String, dynamic>>> getordersbystatusandproductuserid(bool status, String productuserid) async {
    final arrData = await ordercollection.find(where.eq("status",status).eq("productuserid",productuserid)).toList();
    print(arrData.length);
    return arrData;
  }

  static Future<void> confirmorder (MongoDbOrder data) async{

    await ordercollection.update(where.eq("_id", data.id), modify.set("status", data.status));

  }



  //Borrow Products
  static Future<String> insert_borrow(MongoDbBorrow data) async{
    try{
      var result = await borrowcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getborrowproducts() async {
    final arrData = await borrowcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }


  static Future<List<Map<String, dynamic>>> getborrowProductbyuser(String userid, bool status) async {
    final arrData = await borrowcollection.find(where.eq("userid",userid).eq("isaccapted",status)).toList();
    print(arrData.length);

    return arrData;
  }
  static Future<List<Map<String, dynamic>>> getborrowProductbystatus(bool status) async {
    final arrData = await borrowcollection.find(where.eq("isaccapted",status)).toList();
    print(arrData.length);

    return arrData;
  }

  static deleteborrowproduct(MongoDbBorrow data) async {
    await borrowcollection.deleteOne({"_id": data.id});
  }

  static Future<void> updateborrowproduct (MongoDbBorrow data) async{
    //var results = await borrowcollection.findOne({"_id": data.id});
    // results['userid'] = data.userid;
    // results['bookname'] = data.bookname;
    // results['description'] = data.description;
    // results['condition'] = data.condition;
    // results['authorname'] = data.authorname;
    // results['bookwdition'] = data.bookwdit0ion;
    // results['maxnoofdays'] = data.maxnoofdays;
    // results['extrainformation'] = data.extrainformation;
    // results['image'] = data.image;

    await borrowcollection.update(where.eq("_id", data.id), modify.set("description", data.description));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("bookname", data.bookname));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("condition", data.condition));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("authorname", data.authorname));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("bookwdition", data.bookwdition));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("maxnoofdays", data.maxnoofdays));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("extrainformation", data.extrainformation));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("image", data.image));
    await borrowcollection.update(where.eq("_id", data.id), modify.set("isaccapted", data.isaccapted));

    //inspect(response);
  }

  //Borrow Products Requests
  static Future<String> insert_borrow_requests(MongoDbBorrowRequests data) async{
    try{
      var result = await borrowrequestcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }


  static Future<List<Map<String, dynamic>>> getBorrowRequests() async {
    final arrData = await borrowrequestcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }

  static deleteborrowrequest(MongoDbBorrowRequests data) async {
    await borrowrequestcollection.deleteOne({"_id": data.id});
  }

  static Future<void> acceptborrowrequest (MongoDbBorrowRequests data) async{
    await borrowrequestcollection.update(where.eq("_id", data.id), modify.set("isaccepted", data.isaccepted));
  }


  //Discount Voucher
  static Future<String> insert_discountvoucher(Mongodbdiscount data) async{
    try{
      var result = await discountcollection.insertOne(data.toJson()); // converting our model class to json
      if(result.isSuccess){
        return "Data Inserted";
      } else{
        return "Something went wrong while inserting data.";
      }
    } catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getdiscountvouchers() async {
    final arrData = await discountcollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getdiscountvouchersbyid(String id) async {
    final arrData = await discountcollection.find(where.eq("userid", id)).toList();
    //eq for equal
    //gt for greater
    return arrData;
  }

  static deletediscountvoucher(Mongodbdiscount data) async {
    await discountcollection.deleteOne({"_id": data.id});
  }

  static Future<List<Map<String, dynamic>>> getRider() async {
    final arrData = await riderCollection.find().toList();
    //eq for equal
    //gt for greater
    return arrData;
  }

  static Future<void> updateRider (MongodbRider data) async{
    await riderCollection.update(where.eq("_id", data.id), modify.set("isaccepted", data.isaccepted));
  }

  static Future<List<Map<String, dynamic>>> getrderrequesttakenbyrider() async {
    final arrData = await orderrequesttakenbyridercollection.find().toList();
    print(arrData.length);
    return arrData;
  }
}

