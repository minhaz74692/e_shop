// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/order_model.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/screens/order/view/order_track.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class Card5 extends StatelessWidget {
  const Card5({
    super.key,
    required this.product,
    required this.order,
  });
  final Product product;
  final OrderModel order;
  // final List<ProductsModel> thisProductList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
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
              child: Hero(
                tag: product.id!,
                child: CachedNetworkImage(
                  imageUrl: product.image!,
                  fit: BoxFit.contain,
                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // width: 60,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 1)),
                        child: Text(
                          order.status,
                          style: interStyle14_600,
                        ),
                      ),
                      CustomElevatedButton(
                        title: 'Track',
                        horizontalPadding: 12,
                        borderRadius: 8,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          openBottomSheet(
                            context,
                            OrderTrackerScreen(order: order,),
                          );
                        },
                      ),
                    ],
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
