import 'package:flutter/material.dart';

import '../../../utils/theme/colors.dart';

class CircularMaterialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPress;
  final double size;
  final Color color ;
  const CircularMaterialButton({Key? key,required this.onPress, required this.icon,this.color = AppColors.black, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: IconButton(
          splashRadius: 20,
          onPressed: onPress,
          icon: Icon(
            icon,
            size: size,
            color: color,
          )),
    );
  }
}
