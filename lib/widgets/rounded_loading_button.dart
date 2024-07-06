import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomRoundedLoadingButton extends StatelessWidget {
  CustomRoundedLoadingButton({
    super.key,
    required this.doSomething,
    required this.btnController,
    required this.title,
    this.borderRadius,
    this.textStyle,
    this.height,
    this.elevation,
  });
  final Function() doSomething;
  final RoundedLoadingButtonController btnController;
  final String title;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? height;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      height: height ?? 48,
      elevation: elevation ?? 0,
      width: MediaQuery.of(context).size.width - 40,
      color: Colors.blue[700],
      successColor: Colors.blue[700],
      borderRadius: borderRadius ?? 30,
      controller: btnController,
      onPressed: doSomething,
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class CustomRoundedLoadingButton2 extends StatelessWidget {
  CustomRoundedLoadingButton2(
      {super.key,
      required this.doSomething,
      required this.title,
      this.borderRadius,
      this.textStyle,
      this.height,
      this.elevation});
  final Future Function() doSomething;
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  final String title;
  final double? borderRadius;
  final TextStyle? textStyle;
  final double? height;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      height: height ?? 48,
      elevation: elevation ?? 0,
      width: MediaQuery.of(context).size.width - 40,
      color: Colors.blue[800],
      successColor: Colors.blue[800],
      borderRadius: borderRadius ?? 30,
      controller: _buttonController,
      onPressed: () async {
        await doSomething().then(
          (value) async {
            _buttonController.success();
            await Future.delayed(Duration(milliseconds: 500));
            _buttonController.reset();
          },
        );
      },
      // onPressed: () async {
      //   await doSomething();
      //   _btnController.success();
      //   await Future.delayed(Duration(milliseconds: 500));
      //   _btnController.reset();
      // },
      child: Text(
        title,
        style: textStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
