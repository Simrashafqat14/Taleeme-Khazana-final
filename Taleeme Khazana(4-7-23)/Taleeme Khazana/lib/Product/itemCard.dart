import 'package:flutter/material.dart';
import 'package:fyp_project/MainPages/constants.dart';
import 'package:fyp_project/MongoDBModels/producthome.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;
  const ItemCard({
    Key? key,
    required this.product,
    required this.press,
  }):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children:<Widget>[
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(kDefaultPaddin/3),
            /* height:200,
            width: 160,*/
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(product.image),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin/4),
          child: Text(product.title
          ),
        ),
      ],
    );
  }
}
