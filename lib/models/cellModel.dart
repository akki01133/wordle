import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle/utils/values/enums.dart';

import '../module/widgets/shakeOnErrorWidget.dart';

class CellModel extends ChangeNotifier{
  GlobalKey<ShakeWidgetState> shakeKey = GlobalKey();
  GlobalKey<FlipCardState> flipKey = GlobalKey();
  String word ="";
  CellState state = CellState.empty;


  @override
  String toString() {
    return word;
  }

  fill(String word){
    this.word = word;
    state = CellState.filled;
    notifyListeners();
  }

  clear(){
    word = '';
    state = CellState.empty;
    notifyListeners();
  }

  assignState(CellState state){
    this.state = state;
    notifyListeners();
  }



  void flip()=> flipKey.currentState?.toggleCard();

  void shake()=> shakeKey.currentState?.shake();

}
