// To parse this JSON data, do
//
//     final reviewmodel = reviewmodelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Reviewmodel? reviewmodelFromJson(String str) => Reviewmodel.fromJson(json.decode(str));

String reviewmodelToJson(Reviewmodel? data) => json.encode(data!.toJson());

class Reviewmodel {
  Reviewmodel({
    required this.id,
    required this.userid,
    required this.productid,
    required this.name,
    required this.email,
    required this.rating,
    required this.comment,
  });

  ObjectId id;
  String userid;
  String productid;
  String name;
  String email;
  var rating;
  String comment;

  factory Reviewmodel.fromJson(Map<String, dynamic> json) => Reviewmodel(
    id: json["_id"],
    userid: json["userid"],
    productid: json["productid"],
    name: json["name"],
    email: json["email"],
    rating: json["rating"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productid": productid,
    "name": name,
    "email": email,
    "rating": rating,
    "comment": comment,
  };
}
