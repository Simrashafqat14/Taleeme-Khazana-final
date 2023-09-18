// To parse this JSON data, do
//
//     final requests = requestsFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Requests requestsFromJson(String str) => Requests.fromJson(json.decode(str));

String requestsToJson(Requests data) => json.encode(data.toJson());

class Requests {
  Requests({
    required this.id,
    required this.userid,
    required this.productid,
    required this.date,
    required this.time,
    required this.requestype,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.reason,
    required this.reasonexchnage,
    required this.exchnageamountorproduct,
    required this.exchangecondition,
    required this.note,
    required this.isaccepted,
    required this.image,
  });

  ObjectId id;
  String userid;
  String productid;
  String date;
  String time;
  String requestype;
  String name;
  String email;
  String address;
  String city;
  String reason;
  String note;
  String reasonexchnage;
  String exchnageamountorproduct;
  var exchangecondition;
  bool isaccepted;
  String image;


  factory Requests.fromJson(Map<String, dynamic> json) => Requests(
    id: json["_id"],
    userid: json["userid"],
    productid: json["productid"],
    date: json["date"],
    time: json["time"],
    requestype: json["requestype"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    reason: json["reason"],
    note: json["note"],
      reasonexchnage: json["reasonexchnage"],
      exchnageamountorproduct: json["exchnageamountorproduct"],
      exchangecondition: json["exchangecondition"],
      isaccepted: json["isaccepted"],
      image: json["image"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productid": productid,
    "date": date,
    "time": time,
    "requestype": requestype,
    "name": name,
    "email": email,
    "address": address,
    "city": city,
    "reason": reason,
    "note": note,
    "reasonexchnage": reasonexchnage,
    "exchnageamountorproduct": exchnageamountorproduct,
    "exchangecondition": exchangecondition,
    "isaccepted": isaccepted,
    "image" : image
  };
}
