// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:flutter/material.dart';

class Card4 extends StatelessWidget {
  const Card4({
    super.key,
    required this.product,
  });
  final Product product;
  // final List<ProductsModel> thisProductList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Shadow color
            offset: Offset(0, 0), // Offset in the x and y direction
            blurRadius: 1, // Spread of the shadow
            spreadRadius: 0, // Extends the shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: 120,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              // child: Image(
              //   fit: BoxFit.cover,
              //   image: NetworkImage(product.image!),
              // )
              child: CachedNetworkImage(
                imageUrl: product.image!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 100,
            width: 1,
            color: Colors.grey,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    product.description.length > 55
                        ? '${product.description.substring(0, 55)}...'
                        : product.description,
                    // overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    '\u{09F3}${product.price}',
                    // overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
