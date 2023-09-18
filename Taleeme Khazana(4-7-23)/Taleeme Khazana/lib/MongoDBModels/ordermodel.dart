// To parse this JSON data, do
//
//     final mongoDbOrder = mongoDbOrderFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbOrder mongoDbOrderFromJson(String str) => MongoDbOrder.fromJson(json.decode(str));

String mongoDbOrderToJson(MongoDbOrder data) => json.encode(data.toJson());

class MongoDbOrder {
  MongoDbOrder({
    required this.id,
    required this.invoiceNo,
    required this.productid,
    required this.userid,
    required this.productuserid,
    required this.username,
    required this.useremail,
    required this.useraddress,
    required this.productname,
    required this.quantity,
    required this.amount,
    required this.date,
    required this.time,
    required this.status
  });

  ObjectId id;
  int invoiceNo;
  String productid;
  String userid;
  String productuserid;
  String username;
  String useremail;
  String useraddress;
  String productname;
  int quantity;
  int amount;
  String date;
  String time;
  bool status;

  factory MongoDbOrder.fromJson(Map<String, dynamic> json) => MongoDbOrder(
    id: json["_id"],
    invoiceNo: json["Invoice No"],
    productid: json["productid"],
    userid: json["userid"],
      productuserid: json["productuserid"],
    username: json["username"],
    useremail: json["useremail"],
    useraddress: json["useraddress"],
    productname: json["productname"],
    quantity: json["quantity"],
    amount: json["amount"],
    date: json["date"],
    time: json["time"],
      status: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "Invoice No": invoiceNo,
    "productid": productid,
    "userid": userid,
    "productuserid": productuserid,
    "username": username,
    "useremail": useremail,
    "useraddress": useraddress,
    "productname": productname,
    "quantity": quantity,
    "amount": amount,
    "date": date,
    "time": time,
    "status": status
  };
}
