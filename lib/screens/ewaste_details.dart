// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';

import 'package:e_waste/cards/card4.dart';
import 'package:e_waste/constants/app_constants.dart';
import 'package:e_waste/constants/text_style.dart';
import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/screens/buy/buy_screen.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/bookmark_icon.dart';
import 'package:e_waste/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EWasteDetailsScreen extends StatefulWidget {
  const EWasteDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  State<EWasteDetailsScreen> createState() => _EWasteDetailsScreenState();
}

class _EWasteDetailsScreenState extends State<EWasteDetailsScreen> {
  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String getFormattedDate(DateTime dateTime) {
    String day = DateFormat('d').format(dateTime);
    String formattedDay = _getOrdinalSuffix(int.parse(day));
    String formattedMonth = DateFormat('MMM').format(dateTime);
    String formattedYear = DateFormat('y').format(dateTime);

    return '$formattedDay $formattedMonth $formattedYear';
  }

  @override
  Widget build(BuildContext context) {
    final Box bookmarkedList = Hive.box(AppConstants.favouriteTag);
    DateTime? dateTime = widget.product.timeStamp != null
        ? widget.product.timeStamp!.toDate()
        : null;
    var ewp = context.read<EWasteProvider>();

    List<Product> similarProductList = ewp.productList
        .where(
          (ewaste) =>
              ewaste.category == widget.product.category &&
              ewaste.id != widget.product.id,
        )
        .toList();

    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        child: Hero(
          tag: '${widget.product.id}button',
          child: CustomElevatedButton(
            verticlaPadding: 12,
            title: 'Buy',
            onPressed: () {
              nextScreen(context, BuyProductScreen(product: widget.product));
            },
          ),
        ),
      ),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text(
          'Details',
          style: robotoStyle400Regular.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // child: Image(
                  //   fit: BoxFit.cover,
                  //   image: NetworkImage(product.image!),
                  // )
                  child: Hero(
                    tag: widget.product.id!,
                    child: CachedNetworkImage(
                      imageUrl: widget.product.image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.product.productName,
                    style: headline2.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  BookmarkIcon(
                    bookmarkedList: bookmarkedList,
                    product: widget.product,
                    iconSize: 24,
                  )
                ],
              ),
              Text(
                '\u{09F3} ${widget.product.price}',
                style: headline2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.product.description,
                style: latoStyle300Light.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Seller: ',
                      style: latoStyle300Light.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${widget.product.sellerName} ${dateTime != null ? 'at ${getFormattedDate(dateTime)}' : ''}',
                      style: latoStyle300Light.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 5),
                child: Text(
                  'Similar Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: similarProductList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      nextScreeniOS(
                        context,
                        EWasteDetailsScreen(
                          product: similarProductList[index],
                        ),
                      );
                    },
                    child: Card4(
                      product: similarProductList[index],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
