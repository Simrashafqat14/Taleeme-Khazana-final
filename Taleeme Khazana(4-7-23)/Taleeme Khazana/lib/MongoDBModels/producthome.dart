import 'package:flutter/material.dart';

class Product{
  final String image,title,description;
  final int price,id;
  Product({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.description,

  });
}
List<Product> products=
[
  Product(
      id: 1,
      title: 'Book1',
      price: 234,
      description: 'dummyText',
      image: 'assets/book1.jpg'
  ),
  Product(
    id: 2,
    title: 'Book2',
    price: 234,
    description: 'dummyText',
    image: 'assets/book2.jpg',
  ),
  Product(
    id: 3,
    title: 'Book3',
    price: 234,
    description: 'dummyText',
    image: 'assets/book3.jpg',
  ),
  Product(
    id: 4,
    title: 'Book4',
    price: 234,
    description: 'dummyText',
    image: 'assets/book4.jpg',
  )
];
