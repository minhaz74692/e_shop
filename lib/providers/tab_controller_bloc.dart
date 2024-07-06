import 'package:flutter/material.dart';

class TabControllerProvider extends ChangeNotifier {
  final PageController pageController = PageController(initialPage: 0);
  int _currectIndex = 0;
  int get currentIndex => _currectIndex;

  controlTab(int newIndex) {
    _currectIndex = newIndex;
    // pageController.animateToPage(newIndex,
    //     duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    pageController.jumpToPage(newIndex);
    notifyListeners();
  }
}
