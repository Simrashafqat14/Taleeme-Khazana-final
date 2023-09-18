// To parse this JSON data, do
//
//     final mongodbdiscount = mongodbdiscountFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Mongodbdiscount mongodbdiscountFromJson(String str) => Mongodbdiscount.fromJson(json.decode(str));

String mongodbdiscountToJson(Mongodbdiscount data) => json.encode(data.toJson());

class Mongodbdiscount {
  ObjectId id;
  String name;
  String userid;
  String shopid;
  String amount;
  bool type;

  Mongodbdiscount({
    required this.id,
    required this.name,
    required this.userid,
    required this.shopid,
    required this.amount,
    required this.type,
  });

  factory Mongodbdiscount.fromJson(Map<String, dynamic> json) => Mongodbdiscount(
    id: json["_id"],
    name: json["name"],
    userid: json["userid"],
    shopid: json["shopid"],
    amount: json["amount"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "userid": userid,
    "shopid": shopid,
    "amount": amount,
    "type": type,
  };
}
