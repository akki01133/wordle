import 'package:flutter/material.dart';
import '../../helpers/extensions.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({Key? key, required this.mobile,required this.tablet, required this.desktop}): super(key: key);

  static bool isMobile(BuildContext context)=>context.width<650;
  static bool isTablet(BuildContext context)=>context.width>=650 && context.width<1100;
  static bool isDesktop(BuildContext context)=>context.width>=1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraint){
      if(constraint.maxWidth>=1100){
        return desktop;
      }else if (constraint.maxWidth>=650){
        return tablet;
      } else {
        return mobile;
      }
    });
  }
}
