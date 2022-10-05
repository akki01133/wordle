


import 'package:flutter/material.dart';
import 'package:wordle/utils/values/enums.dart';

import 'colors.dart';

const _cellColors = {
  CellState.empty: Colors.transparent,
  CellState.filled: Colors.transparent,
  CellState.notInWord: AppColors.notInWord,
  CellState.inWord: AppColors.inWord,
  CellState.correct: AppColors.correct
};
getCellColor(CellState cellState)=> _cellColors[cellState];

get activeBorder => Border.all(color: AppColors.semiGrey, width: 1.2,);
get normalBorder => Border.all(color: AppColors.lightGrey, width: 1.2,);
getBorder(CellState state){
  switch(state){
    case CellState.empty: return normalBorder;
    case CellState.filled: return activeBorder;
    default: return null;
  }
}



const keyColors = <CellState, Color>{
  CellState.notInWord: AppColors.notInWord,
  CellState.inWord: AppColors.inWord,
  CellState.correct: AppColors.correct
};
