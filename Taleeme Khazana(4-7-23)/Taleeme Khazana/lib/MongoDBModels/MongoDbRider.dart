// To parse this JSON data, do
//
//     final mongodbRider = mongodbRiderFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongodbRider mongodbRiderFromJson(String str) => MongodbRider.fromJson(json.decode(str));

String mongodbRiderToJson(MongodbRider data) => json.encode(data.toJson());

class MongodbRider {
  ObjectId id;
  String name;
  String email;
  String contactno;
  String address;
  String city;
  String country;
  String image;
  String username;
  String role;
  bool isaccepted;
  String password;

  MongodbRider({
    required this.id,
    required this.name,
    required this.email,
    required this.contactno,
    required this.address,
    required this.city,
    required this.country,
    required this.image,
    required this.username,
    required this.role,
    required this.isaccepted,
    required this.password,
  });

  factory MongodbRider.fromJson(Map<String, dynamic> json) => MongodbRider(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    contactno: json["contactno"],
    address: json["address"],
    city: json["city"],
    country: json["country"],
    image: json["image"],
    username: json["username"],
    role: json["role"],
      isaccepted: json["isaccepted"],
      password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "contactno": contactno,
    "address": address,
    "city": city,
    "country": country,
    "image": image,
    "username": username,
    "role": role,
    "isaccepted": isaccepted,
    "password": password,
  };
}
