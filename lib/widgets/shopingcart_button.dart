// ignore_for_file: prefer_const_constructors

import 'package:e_waste/models/product_model.dart';
import 'package:flutter/material.dart';

class ShopingCartButton extends StatelessWidget {
  const ShopingCartButton({super.key, required this.productListInCart});
  final List<Product> productListInCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          IconButton(
            onPressed: () {
              // nextScreen(context, Cart());
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.grey,
            ),
          ),
          Positioned(
            right: 0,
            child: Text(
              productListInCart.isEmpty
                  ? ''
                  : productListInCart.length.toString(),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
