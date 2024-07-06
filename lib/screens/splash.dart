// ignore_for_file: prefer_const_constructors

import 'package:e_waste/constants/asset_image.dart';
import 'package:e_waste/providers/e_waste_provider.dart';
import 'package:e_waste/providers/user_provider.dart';
import 'package:e_waste/screens/home/view/home_page.dart';
import 'package:e_waste/screens/login.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _afterSplash() async {
    final UserProvider ub = context.read<UserProvider>();
    // SharedPreferences sp = await SharedPreferences.getInstance();
    final eWasteProvider = context.read<EWasteProvider>();
    // bool? isSignedIn = sp.getBool('signed_in');
    // final configs = context.read<ConfigBloc>().configs!;
    Future.delayed(const Duration(milliseconds: 1500)).then((value) async {
      eWasteProvider.getLocation();
      ub.getUserData().then((value) async {
        if (ub.isSignedIn == true || ub.guestUser == true) {
          await eWasteProvider.getCategories();
          await eWasteProvider.getAllProducts();
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, HomePage());
          // if (isSignedIn == true) {
        } else {
          nextScreenReplace(context, LogIn());
        }
      });
    });
  }
  // Future _afterSplash() async {
  //   Future.delayed(const Duration(milliseconds: 1500))
  //       .then((value) => nextScreenReplace(context, const LogIn()));
  // }

  @override
  void initState() {
    _afterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            height: 250,
            width: 250,
            image: AssetImage(AssetImages.instance.splash),
          ),
          // Text(
          //   'EShop',
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          // ),
        ],
      )),
    );
  }
}
