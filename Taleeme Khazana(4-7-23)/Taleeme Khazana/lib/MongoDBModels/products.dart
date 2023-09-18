// To parse this JSON data, do
//
//     final mongoDbProducts = mongoDbProductsFromJson(jsonString);

import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MongoDbProducts mongoDbProductsFromJson(String str) => MongoDbProducts.fromJson(json.decode(str));

String mongoDbProductsToJson(MongoDbProducts data) => json.encode(data.toJson());

class MongoDbProducts {
  MongoDbProducts({
    required this.id,
    required this.userid,
    required this.productcategory,
    required this.productype,
    required this.image,
    required this.productname,
    required this.productdescription,
    required this.productcondition,
    //book category
    required this.authorname,
    required this.booksubject,
    required this.noofpages,
    //uniform category
    required this.uniformSize,
    required this.schoolname,
    //shoes category
    required this.shoesSize,
    required this.shoesstyle,
    //bags category
    required this.bagtype,
    //stationary category
    required this.stationaryname,
    required this.noofitemsstationary,

    required this.grade,
    required this.gender,
    required this.color,

    //Donate Fields
    required this.extrainformation,
    //Exchange Fields
    required this.isgrouped,
    required this.exchangereason,
    required this.exchangesource,
    required this.quantityofGroupedProducts,
    required this.requiredamountorproduct,
    required this.dateTime,

    required this.isaccapted,
    required this.buyerid,
  });

  ObjectId id;
  String userid;
  String productcategory;
  String productype;
  String image;
  String productname;
  String productdescription;
  double productcondition;
  String authorname;
  String booksubject;
  String noofpages;
  String uniformSize;
  String schoolname;
  String shoesSize;
  String shoesstyle;
  String bagtype;
  String stationaryname;
  String noofitemsstationary;
  String grade;
  String gender;
  String color;
  bool isgrouped;
  String extrainformation;
  String exchangereason;
  String exchangesource;
  String quantityofGroupedProducts;
  String requiredamountorproduct;
  String dateTime;
  bool isaccapted;
  String buyerid;


  factory MongoDbProducts.fromJson(Map<String, dynamic> json) => MongoDbProducts(
    id: json["_id"],
    userid: json["userid"],
    productcategory: json["productcategory"],
    productype: json["productype"],
    image: json["image"],
    productname: json["productname"],
    productdescription: json["productdescription"],
    productcondition: json["productcondition"],
    authorname: json["authorname"],
    booksubject: json["booksubject"],
    noofpages: json["noofpages"],
    uniformSize: json["uniformSize"],
    schoolname: json["schoolname"],
    shoesSize: json["shoesSize"],
    shoesstyle: json["shoesstyle"],
    bagtype: json["bagtype"],
    stationaryname: json["stationaryname"],
    noofitemsstationary: json["noofitemsstationary"],
    grade: json["grade"],
    gender: json["gender"],
    color: json["color"],
    extrainformation: json["Extrainformation"],
    isgrouped: json["isgrouped"],
    exchangereason: json["exchangereason"],
    exchangesource: json["exchangesource"],
    quantityofGroupedProducts: json["quantityofGroupedProducts"],
    requiredamountorproduct: json["requiredamountorproduct"],
    dateTime: json["dateTime"],
      isaccapted: json['isaccapted'],
      buyerid: json['buyerid'],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productcategory": productcategory,
    "productype": productype,
    "image": image,
    "productname": productname,
    "productdescription": productdescription,
    "productcondition": productcondition,
    "authorname": authorname,
    "booksubject": booksubject,
    "noofpages": noofpages,
    "uniformSize": uniformSize,
    "schoolname": schoolname,
    "shoesSize": shoesSize,
    "shoesstyle": shoesstyle,
    "bagtype": bagtype,
    "stationaryname": stationaryname,
    "noofitemsstationary": noofitemsstationary,
    "grade": grade,
    "gender": gender,
    "color": color,
    "Extrainformation": extrainformation,
    "isgrouped": isgrouped,
    "exchangereason": exchangereason,
    "exchangesource": exchangesource,
    "quantityofGroupedProducts": quantityofGroupedProducts,
    "requiredamountorproduct": requiredamountorproduct,
    "dateTime": dateTime,
    "isaccapted": isaccapted,
    "buyerid": buyerid,
  };
}
