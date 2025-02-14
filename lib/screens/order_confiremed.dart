// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:e_waste/tabs/home_tab.dart';
import 'package:e_waste/utils/nextscreen.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Your order placed Successfully. Thank You for shopping with us.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 85, 76, 76),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                nextScreenCloseOthers(context, HomeTab());
              },
              child: Text('Continue Shopping'),
            ),
          ),
        ],
      ),
    );
  }
}
