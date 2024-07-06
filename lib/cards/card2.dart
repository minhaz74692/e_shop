// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/screens/buy/buy_screen.dart';
import 'package:e_waste/screens/ewaste_details.dart';
import 'package:e_waste/widgets/bookmark_button.dart';
import 'package:e_waste/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:hive/hive.dart';

class Card2 extends StatelessWidget {
  const Card2({
    super.key,
    required this.product,
  });
  final Product product;
  // final List<ProductsModel> thisProductList;

  @override
  Widget build(BuildContext context) {
    final Box bookmarkedList = Hive.box(AppConstants.favouriteTag);
    return InkWell(
      onTap: () {
        nextScreen(context, EWasteDetailsScreen(product: product));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 239, 239, 239)),
          boxShadow: const [
            // BoxShadow(
            //   color: Colors.grey, // Shadow color
            //   offset: Offset(0, 1), // Offset in the x and y direction
            //   blurRadius: 1, // Spread of the shadow
            //   spreadRadius: 0, // Extends the shadow
            // )
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              // onTap: () => nextScreen(
              //   context,
              //   ProductDetails(id: product.id!, product: product),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    height: 100,
                    width: double.infinity,
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
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      product.productName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Text(
                          '\u{09F3}${product.price.toString()}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red),
                        ),
                        Spacer(),
                        BookmarkIcon(
                          bookmarkedList: bookmarkedList,
                          service: product,
                          iconSize: 22,
                          iconColor: Colors.pinkAccent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 35,
                width: 150,
                child: Hero(
                  tag: '${product.id}button',
                  child: CustomElevatedButton(
                    style: interStyle14_600.copyWith(color: Colors.white),
                    verticlaPadding: 0,
                    borderRadius: 8,
                    title: 'Buy',
                    onPressed: () {
                      nextScreen(context, BuyProductScreen(product: product));
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
