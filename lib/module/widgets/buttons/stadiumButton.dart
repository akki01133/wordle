import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  final String title;
  final double height;
  final Color background;
  final TextStyle textStyle;
  final bool isLoading;
  final VoidCallback? onPressed;
  const StadiumButton({Key? key,
    required this.title,
    required this.textStyle,
    required this.background,
    required this.isLoading,
    required this.height,
    this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          fixedSize: Size.fromHeight(height),
          primary: background,
        ),
        child: isLoading ? SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: textStyle.color,strokeWidth: 3,)) : Text(title, style: textStyle));
  }
}
