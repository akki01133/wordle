import 'package:flutter/material.dart';


class SlideRoute<T> extends MaterialPageRoute<T> {
  final Offset? beginOffset;
  SlideRoute({required WidgetBuilder builder, this.beginOffset, RouteSettings? settings})
      : super(builder: builder, settings: settings);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset ?? Offset(0, 1),
        end: Offset.zero,
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}
