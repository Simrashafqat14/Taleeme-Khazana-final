// To parse this JSON data, do
//
//     final mongoDbShop = mongoDbShopFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbShop mongoDbShopFromJson(String str) => MongoDbShop.fromJson(json.decode(str));

String mongoDbShopToJson(MongoDbShop data) => json.encode(data.toJson());

class MongoDbShop {
  MongoDbShop({
    required this.id,
    required this.userid,
    required this.image,
    required this.email,
    required this.name,
    required this.shopname,
    required this.shopTagline,
    required this.shopemail,
    required this.shopwebsite,
    required this.shopDescription,
    required this.isApproved,
    required this.isChecked,
    required this.receiptimage
  });

  ObjectId id;
  String userid;
  String image;
  String email;
  String name;
  String shopname;
  String shopTagline;
  String shopemail;
  String shopwebsite;
  String shopDescription;
  bool isApproved;
  bool? isChecked;
  String receiptimage;

  factory MongoDbShop.fromJson(Map<String, dynamic> json) => MongoDbShop(
    id: json["_id"],
    userid: json["userid"],
    image: json["image"],
    email: json["email"],
    name: json["name"],
    shopname: json["shopname"],
    shopTagline: json["shopTagline"],
    shopemail: json["shopemail"],
    shopwebsite: json["shopwebsite"],
    shopDescription: json["shopDescription"],
    isApproved: json["isApproved"],
      isChecked: json["isChecked"],
      receiptimage: json["receiptimage"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "image": image,
    "email": email,
    "name": name,
    "shopname": shopname,
    "shopTagline": shopTagline,
    "shopemail": shopemail,
    "shopwebsite": shopwebsite,
    "shopDescription": shopDescription,
    "isApproved": isApproved,
    "isChecked": isChecked,
    "receiptimage": receiptimage
  };
}
