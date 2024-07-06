import 'package:e_waste/constants/text_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      this.widget,
      required this.title,
      this.color,
      required this.onPressed,
      this.style,
      this.borderRadius,
      this.elevation,
      this.horizontalPadding,
      this.verticlaPadding});
  final String title;
  final Color? color;
  final Function onPressed;
  final TextStyle? style;
  final double? borderRadius;
  final double? elevation;
  final double? horizontalPadding;
  final double? verticlaPadding;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0,
        backgroundColor: color ?? const Color(0xFF008951),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30)),
      ),
      onPressed: () => onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0,
          vertical: verticlaPadding ?? 0,
        ),
        child: widget ??
            Text(
              title,
              style: style ??
                  interStyle16_600.copyWith(
                    color: Colors.white,
                  ),
            ),
      ),
    );
  }
}
