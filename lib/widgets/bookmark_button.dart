import 'package:e_waste/models/product_model.dart';
import 'package:e_waste/services/bookmark_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkIcon extends StatelessWidget {
  const BookmarkIcon(
      {Key? key,
      required this.bookmarkedList,
      required this.service,
      required this.iconSize,
      this.iconColor,
      this.normalIconColor})
      : super(key: key);

  final Box bookmarkedList;
  final Product? service;
  final double iconSize;
  final Color? iconColor;
  final Color? normalIconColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bookmarkedList.listenable(),
      builder: (context, dynamic value, Widget? child) {
        return GestureDetector(
          onTap: () {
            BookmarkService().handleBookmarkIconPressed(service!, context);
          },
          child: bookmarkedList.keys.contains(service!.id)
              ? Icon(
                  CupertinoIcons.heart_fill,
                  size: iconSize,
                  color: iconColor ?? Colors.purpleAccent,
                )
              : Icon(
                  CupertinoIcons.heart,
                  size: iconSize,
                  color: normalIconColor ?? Colors.grey,
                ),
        );
        // return IconButton(
        //     iconSize: iconSize,
        //     padding: const EdgeInsets.all(0),
        //     constraints: const BoxConstraints(),
        //     alignment: Alignment.centerRight,
        // icon: bookmarkedList.keys.contains(service!.id)
        //     ? Icon(CupertinoIcons.heart_fill,
        //         color: iconColor ?? Colors.purpleAccent)
        //     : Icon(CupertinoIcons.heart,
        //         color: normalIconColor ?? Colors.grey),
        // onPressed: () {
        //   BookmarkService().handleBookmarkIconPressed(service!, context);
        // });
      },
    );
  }
}
