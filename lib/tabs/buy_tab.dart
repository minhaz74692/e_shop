import 'package:e_waste/screens/home/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class BuyTab extends StatelessWidget {
  const BuyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ImageUploadScreen(),
      ),
    );
  }
}
