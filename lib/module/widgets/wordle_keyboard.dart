import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/state/wordle_controller.dart';
import 'package:wordle/utils/values/enums.dart';
import '../../../helpers/extensions.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/styles.dart';
const keyboard = [
  [ 'Q','W','E','R','T','Y','U','I','O','P',],
  [ 'A','S','D','F','G','H','J','K','L'],
  [ 'Z','X','C','V','B','N','M',],
];


class WordleKeyboard extends StatefulWidget {

  const WordleKeyboard({Key? key}) : super(key: key);

  @override
  State<WordleKeyboard> createState() => _WordleKeyboardState();

}

class _WordleKeyboardState extends State<WordleKeyboard> {
  late final Function onKeyTap ;
  late final VoidCallback onDeleteTap ;
  late final Function({required bool async}) onEnterTap;
  final margin = 6.0;
  double get cellWidth  => min((context.width - 6.0*11)/10, 42) * 1.0;
  final aspectRatio = 1.36;

  @override
  void initState() {
    onKeyTap=  Provider.of<WordleController>(context,listen: false).addWord;
    onDeleteTap=  Provider.of<WordleController>(context,listen: false).removeWord;
    onEnterTap = Provider.of<WordleController>(context,listen: false).checkWordle;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<WordleController>(
      builder:(_,controller, child)=> Container(
        margin: EdgeInsets.only(bottom: 6),
        width: context.width,
        color: Colors.white60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...keyboard[0].map((value) => buildKey(value, controller.keyboardUsedLetters[value] ))
              ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...keyboard[1].map((value) => buildKey(value, controller.keyboardUsedLetters[value] ))
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildKeyboardActionKey(
                      child: Text("ENTER", style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w500, fontSize: 13),),
                      color: AppColors.correct, onPress: ()async{await onEnterTap(async: true);} ),
                  ...keyboard[2].map((value) => buildKey(value,controller.keyboardUsedLetters[value] )),
                  buildKeyboardActionKey(
                      child: Icon(Icons.backspace_outlined, color: AppColors.black,size: 22,),
                      color: AppColors.lightGrey, onPress: onDeleteTap),
                ]),
          ],
        ),
      ),
    );
  }

  buildKey(String value, CellState? keyState){

    return InkWell(
      onTap:()=> onKeyTap(value),
      child: Container(
      height: cellWidth*aspectRatio,
      width: cellWidth,
      margin: EdgeInsets.symmetric(horizontal: margin/2, vertical: margin/2),
      decoration: BoxDecoration(
        color: keyColors[keyState] ?? AppColors.lightGrey,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child:  Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),)),
      ),
    );
  }

  buildKeyboardActionKey({required Widget child, required Color color, required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: margin/2, vertical: margin/2),
        height: cellWidth* aspectRatio,
        width: cellWidth * 1.55,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: child,
          ),
        ),
    );
  }

  Color? getKeyColor(String letter)=> keyColors[Provider.of<WordleController>(context).keyboardUsedLetters[letter]];
}
