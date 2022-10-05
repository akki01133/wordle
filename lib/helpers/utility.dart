import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:html';
import '../module/widgets/responsive.dart';
import '../module/widgets/wordle_keyboard.dart';
import '../state/wordle_controller.dart';
import '../utils/theme/colors.dart';


class Utility{

  static customSnackBar(GlobalKey<NavigatorState> key, String msg,
      {double height = 30, Color backgroundColor = Colors.black}) {
    if (key.currentState == null) {
      return;
    }
    ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar();
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(snackBar);
  }

  static void openCreateBottomSheet({required BuildContext context, required Widget child}){
    Responsive.isMobile(context) ?
    showModalBottomSheet(
        isScrollControlled: true,
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))
        ),
        context: context,
        builder: (context) => child)
        :
    showGeneralDialog(
        barrierColor: AppColors.white.withOpacity(0.3),
        context: context,
        barrierDismissible: true,
        barrierLabel: 'dialog barrier label',
        pageBuilder: (context, animation1, animation2) {
          return Center(
              child: child
          );
        },
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOut.transform(a1.value) - 1.0;
          return Transform(
              transform: Matrix4.translationValues(0.0, -1*curvedValue * 20, 0.0),
              child: Center(
                  child: child
              ));
        });
  }

  static void handleKeyPressed({required RawKeyEvent event , required BuildContext context}){
    if(event is RawKeyDownEvent) {
      if(event.isKeyPressed(LogicalKeyboardKey.enter)){
        Provider.of<WordleController>(context,listen: false).checkWordle(async: true);
        return;
      }else if(event.isKeyPressed(LogicalKeyboardKey.backspace)){
        Provider.of<WordleController>(context,listen: false).removeWord();
        return;
      }
      final key = event.logicalKey.keyLabel;
      if(keyboard[0].contains(key) || keyboard[1].contains(key) || keyboard[2].contains(key)){
        Provider.of<WordleController>(context,listen: false).addWord(key);
      }
    }
  }


  static Future shareWebsiteUrl()async{
    var url = window.location.href;
    print(url);
    await Share.share(window.location.href);
  }

}
