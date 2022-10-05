import 'package:flutter/material.dart';
import 'dart:math';

extension SizeHelper on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).viewPadding.top;
  double getDimension(context, double unit) {
    if (width <= 360.0) {
      return unit / 1.3;
    } else {
      return unit;
    }
  }
}

extension CustomSnackBar on BuildContext{
  showSnackBar(String message, {double height = 30, Color backgroundColor = Colors.black}){
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
