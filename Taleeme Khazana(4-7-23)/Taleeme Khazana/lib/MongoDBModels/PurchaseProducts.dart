// To parse this JSON data, do
//
//     final mongoDbPurchasableProducts = mongoDbPurchasableProductsFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbPurchasableProducts mongoDbPurchasableProductsFromJson(String str) => MongoDbPurchasableProducts.fromJson(json.decode(str));

String mongoDbPurchasableProductsToJson(MongoDbPurchasableProducts data) => json.encode(data.toJson());

class MongoDbPurchasableProducts {
  MongoDbPurchasableProducts({
    required this.id,
    required this.userid,
    required this.productcategory,
    required this.image,
    required this.productname,
    required this.productdescription,
    required this.productprice,
    required this.saleprice,
    required this.onSale,
    required this.islimited,
    required this.stock,
    required this.extrainformation,
    required this.dateTime,
    required this.bagsize,
    required this.booktype,
    required this.bookauthor,
    required this.uniformSize,
    required this.shoesSize,
    required this.shoesType,
    required this.gender,
    required this.color,
  });

  ObjectId id;
  String userid;
  String productcategory;
  String image;
  String productname;
  String productdescription;
  String productprice;
  String saleprice;
  bool onSale;
  bool islimited;
  String stock;
  String extrainformation;
  String dateTime;
  String bagsize;
  String booktype;
  String bookauthor;
  String uniformSize;
  String shoesSize;
  String shoesType;
  String gender;
  String color;

  factory MongoDbPurchasableProducts.fromJson(Map<String, dynamic> json) => MongoDbPurchasableProducts(
    id: json["_id"],
    userid: json["userid"],
    productcategory: json["productcategory"],
    image: json["image"],
    productname: json["productname"],
    productdescription: json["productdescription"],
    productprice: json["productprice"],
    saleprice: json["saleprice"],
    onSale: json["onSale"],
    islimited: json["islimited"],
    stock: json["Stock"],
    extrainformation: json["Extrainformation"],
    dateTime: json["dateTime"],
    bagsize: json["bagsize"],
    booktype: json["booktype"],
    bookauthor: json["bookauthor"],
    uniformSize: json["uniformSize"],
    shoesSize: json["shoesSize"],
    shoesType: json["shoesType"],
    gender: json["gender"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productcategory": productcategory,
    "image": image,
    "productname": productname,
    "productdescription": productdescription,
    "productprice": productprice,
    "saleprice": saleprice,
    "onSale": onSale,
    "islimited": islimited,
    "Stock": stock,
    "Extrainformation": extrainformation,
    "dateTime": dateTime,
    "bagsize": bagsize,
    "booktype": booktype,
    "bookauthor": bookauthor,
    "uniformSize": uniformSize,
    "shoesSize": shoesSize,
    "shoesType": shoesType,
    "gender": gender,
    "color": color
  };
}
