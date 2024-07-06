// ignore_for_file: prefer_if_null_operators, prefer_const_constructors

import 'package:e_waste/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_waste/services/bookmark_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkIcon extends StatelessWidget {
  const BookmarkIcon(
      {Key? key,
      required this.bookmarkedList,
      required this.product,
      required this.iconSize,
      this.iconColor,
      this.normalIconColor})
      : super(key: key);

  final Box bookmarkedList;
  final Product? product;
  final double iconSize;
  final Color? iconColor;
  final Color? normalIconColor;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> countNotifier = ValueNotifier(0);
    return ValueListenableBuilder(
      valueListenable: countNotifier,
      builder: (context, dynamic value, Widget? child) {
        return IconButton(
            iconSize: iconSize,
            padding: EdgeInsets.all(0),
            constraints: BoxConstraints(),
            alignment: Alignment.centerRight,
            icon: bookmarkedList.keys.contains(product!.id)
                ? Icon(CupertinoIcons.heart_fill,
                    color: iconColor == null ? Colors.pinkAccent : iconColor)
                : Icon(CupertinoIcons.heart,
                    color: normalIconColor == null
                        ? Colors.grey
                        : normalIconColor),
            onPressed: () {
              BookmarkService().handleBookmarkIconPressed(product!, context);
              countNotifier.value += 1;
            });
      },
    );
  }
}
