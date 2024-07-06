// ignore_for_file: prefer_const_constructors

import 'package:e_waste/constants/asset_image.dart';
import 'package:e_waste/screens/login.dart';
import 'package:e_waste/screens/signup.dart';
import 'package:e_waste/utils/nextscreen.dart';
import 'package:e_waste/widgets/primary_button.dart';
import 'package:e_waste/widgets/top_titles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight,
            ),
            TopTitles(
              title: 'Welcome',
              subTitle: 'Buy products from QuickShop',
            ),
            Image.asset(AssetImages.instance.welcomeImgae),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.facebook,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                CupertinoButton(
                  onPressed: () {},
                  child: Image.asset(
                    'assets/images/googlelogo.png',
                    scale: 6,
                  ),
                ),
              ],
            ),
            PrimaryButton(
                title: 'Log In',
                onPressed: () {
                  nextScreen(context, LogIn());
                }),
            SizedBox(
              height: 10,
            ),
            PrimaryButton(
                title: 'Sign Up',
                onPressed: () {
                  nextScreen(
                    context,
                    SignUp(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
