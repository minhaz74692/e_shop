import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

 void nextScreeniOS(context, page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

 void openBottomSheet(context, page) {
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.50,
            maxHeight: MediaQuery.of(context).size.height * 0.95),
        context: context,
        builder: (context) => page);
  }
