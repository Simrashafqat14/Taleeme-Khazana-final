// To parse this JSON data, do
//
//     final mongoDbBorrow = mongoDbBorrowFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbBorrow mongoDbBorrowFromJson(String str) => MongoDbBorrow.fromJson(json.decode(str));

String mongoDbBorrowToJson(MongoDbBorrow data) => json.encode(data.toJson());

class MongoDbBorrow {
  MongoDbBorrow({
    required this.id,
    required this.image,
    required this.userid,
    required this.bookname,
    required this.bookwdition,
    required this.authorname,
    required this.condition,
    required this.maxnoofdays,
    required this.description,
    required this.extrainformation,
    required this.datetime,
    required this.isaccapted,
    required this.buyerid
  });

  ObjectId id;
  String image;
  String userid;
  String bookname;
  String bookwdition;
  String authorname;
  double condition;
  String maxnoofdays;
  String description;
  String extrainformation;
  String datetime;
  bool isaccapted;
  String buyerid;

  factory MongoDbBorrow.fromJson(Map<String, dynamic> json) => MongoDbBorrow(
    id: json["_id"],
    image: json["image"],
    userid: json["userid"],
    bookname: json["bookname"],
    bookwdition: json["bookwdition"],
    authorname: json["authorname"],
    condition: json["condition"],
    maxnoofdays: json["maxnoofdays"],
    description: json["description"],
    extrainformation: json["extrainformation"],
    datetime: json["datetime"],
      isaccapted: json["isaccapted"],
    buyerid: json['buyerid']
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "userid": userid,
    "bookname": bookname,
    "bookwdition": bookwdition,
    "authorname": authorname,
    "condition": condition,
    "maxnoofdays": maxnoofdays,
    "description": description,
    "extrainformation": extrainformation,
    "datetime": datetime,
    "isaccapted": isaccapted,
    "buyerid": buyerid
  };
}
