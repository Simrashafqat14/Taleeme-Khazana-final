// To parse this JSON data, do
//
//     final mongoDbBorrowRequests = mongoDbBorrowRequestsFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbBorrowRequests mongoDbBorrowRequestsFromJson(String str) => MongoDbBorrowRequests.fromJson(json.decode(str));

String mongoDbBorrowRequestsToJson(MongoDbBorrowRequests data) => json.encode(data.toJson());

class MongoDbBorrowRequests {
  ObjectId id;
  String userid;
  String productid;
  String name;
  String address;
  String email;
  String daterange;
  String productname;
  String image;
  var condition;
  String authorname;
  String bookedition;
  String datetime;
  bool isaccepted;
  String note;
  String city;

  MongoDbBorrowRequests({
    required this.id,
    required this.userid,
    required this.productid,
    required this.name,
    required this.address,
    required this.email,
    required this.daterange,
    required this.productname,
    required this.image,
    required this.condition,
    required this.authorname,
    required this.bookedition,
    required this.datetime,
    required this.isaccepted,
    required this.note,
     required this.city
  });

  factory MongoDbBorrowRequests.fromJson(Map<String, dynamic> json) => MongoDbBorrowRequests(
    id: json["_id"],
    userid: json["userid"],
      productid: json["productid"],
    name: json["name"],
    address: json["address"],
    email: json["email"],
    daterange: json["daterange"],
    productname: json["productname"],
    image: json["image"],
    condition: json["condition"],
    authorname: json["authorname"],
    bookedition: json["bookedition"],
    datetime: json["datetime"],
      isaccepted: json['isaccepted'],
      note: json['note'],
    city: json['city']
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productid": productid,
    "name": name,
    "address": address,
    "email": email,
    "daterange": daterange,
    "productname": productname,
    "image": image,
    "condition": condition,
    "authorname": authorname,
    "bookedition": bookedition,
    "datetime": datetime,
    "isaccepted": isaccepted,
    "note": note,
    "city": city
  };
}
