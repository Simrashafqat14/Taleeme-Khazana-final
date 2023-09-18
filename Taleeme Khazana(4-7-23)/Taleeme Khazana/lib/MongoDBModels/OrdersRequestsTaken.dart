// To parse this JSON data, do
//
//     final mongodbordersrequesttaken = mongodbordersrequesttakenFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Mongodbordersrequesttaken mongodbordersrequesttakenFromJson(String str) => Mongodbordersrequesttaken.fromJson(json.decode(str));

String mongodbordersrequesttakenToJson(Mongodbordersrequesttaken data) => json.encode(data.toJson());

class Mongodbordersrequesttaken {
  ObjectId id;
  String riderid;
  ObjectId orderorrequestid;
  bool iscomplete;
  String type;

  Mongodbordersrequesttaken({
    required this.id,
    required this.riderid,
    required this.orderorrequestid,
    required this.iscomplete,
    required this.type,
  });

  factory Mongodbordersrequesttaken.fromJson(Map<String, dynamic> json) => Mongodbordersrequesttaken(
    id: json["_id"],
    riderid: json["riderid"],
    orderorrequestid: json["orderorrequestid"],
    iscomplete: json["iscomplete"],
      type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "riderid": riderid,
    "orderorrequestid": orderorrequestid,
    "iscomplete": iscomplete,
    "type": type,
  };
}
