// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    required this.id,
    required this.userid,
    required this.productid,
    required this.productuserid,
    required this.productname,
    required this.singleprice,
    required this.quantity,
    required this.price,
    required this.stock
  });

  ObjectId id;
  String userid;
  String productid;
  String productuserid;
  String productname;
  int singleprice;
  int quantity;
  int price;
  int stock;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json["_id"],
    userid: json["userid"],
    productid: json["productid"],
      productuserid: json["productuserid"],
      productname: json["productname"],
    singleprice: json["singleprice"],
    quantity: json["quantity"],
    price: json["price"],
      stock: json["stock"]
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userid": userid,
    "productid": productid,
    "productuserid": productuserid,
    "productname": productname,
    "singleprice": singleprice,
    "quantity": quantity,
    "price": price,
    "stock": stock
  };
}
