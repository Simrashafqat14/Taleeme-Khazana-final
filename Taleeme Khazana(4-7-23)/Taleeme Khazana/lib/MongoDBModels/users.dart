// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel? mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel? data) => json.encode(data!.toJson());

class MongoDbModel {
  MongoDbModel({
    required this.id,
    required this.userimage,
    required this.email,
    required this.userName,
    required this.password,
    required this.fullname,
    required this.nickname,
    required this.address,
    required this.city,
    required this.country,
    required this.role,
    required this.contactno,
  });

  ObjectId id;
  String userimage;
  String email;
  String userName;
  String password;
  String fullname;
  String nickname;
  String address;
  String city;
  String country;
  String role;
  String contactno;

  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
      id: json["_id"],
      userimage: json["userimage"],
      email: json["Email"],
      userName: json["userName"],
      password: json["password"],
      fullname: json["fullname"],
      nickname: json["nickname"],
      address: json["address"],
      city: json["city"],
      country: json["country"],
      role: json["role"],
      contactno: json["contactno"]

  );

  set stateValue(String stateValue) {}

  set cityValue(String cityValue) {}

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userimage": userimage,
    "Email": email,
    "userName": userName,
    "password": password,
    "fullname": fullname,
    "nickname": nickname,
    "address": address,
    "city": city,
    "country": country,
    "role": role,
    "contactno": contactno
  };
}
