import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:provider/provider.dart';
import 'package:wordle/models/statisticsModel.dart';
import 'package:wordle/module/widgets/buttons/iconButton.dart';
import 'package:wordle/module/widgets/buttons/stadiumButton.dart';
import 'package:wordle/module/widgets/responsive.dart';
import 'package:wordle/state/wordle_controller.dart';
import 'package:wordle/utils/theme/colors.dart';
import 'package:wordle/utils/values/enums.dart';
import '../../services/free_dictionary.dart';


class StatsBottomSheet extends StatelessWidget {
  final BuildContext context;
  final String word;
  final List<Meanings> meanings;
  final VoidCallback playAgain;
  final VoidCallback shareCallback;
  final int solvedInSteps;
  const StatsBottomSheet({Key? key,
    required this.context,
    required this.word,
    required this.statistics,
    required this.playAgain,
    required this.shareCallback,
    required this.solvedInSteps, required this.meanings}) : super(key: key);
  final StatisticsModel statistics ;
  FontWeight get weight =>  Responsive.isDesktop(context) ? FontWeight.bold : FontWeight.w500;

  double get height => min(context.height,560);
  double get width => Responsive.isMobile(context) ? context.width : 500;
  @override
  Widget build(BuildContext context) {
    return Container(
            width:  500,
            height: height,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              boxShadow:const [
                BoxShadow(
                  offset: Offset(0, 0),
                  spreadRadius: 4,
                  blurRadius: 10,
                  color: Color.fromRGBO(0, 0, 0, 0.21),
                ),
              ]
            ),
            child: Scaffold(
                backgroundColor:Colors.transparent,
                body:Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(padding: EdgeInsets.all(4), child: CircularMaterialButton(onPress:()=> Navigator.of(context).pop(), icon: Icons.close_outlined,))
                      ],),
                      SizedBox(height: 10,),
                      if(Responsive.isMobile(context))
                        Selector<WordleController, GameStatus>(
                            builder: (_, status, child)=>status == GameStatus.won || status == GameStatus.lost ?buildWordleMeaning() : SizedBox.shrink(),
                            selector: (_, controller)=> controller.gameStatus),
                      buildStatistics(),
                      separator(),
                    ],
                  ),
                ),
                bottomNavigationBar: buildBottomAction(),
      ),
    );
  }

  buildWordleMeaning() {
    return Container(
        height:  64,
        width: width/1.2,
        padding: EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
            color: Responsive.isMobile(context)? AppColors.grey.withOpacity(0.6):null,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Word : $word", style: TextStyle(color: AppColors.black, fontSize: 14, fontWeight: weight ),),
            Text('Meaning : (${meanings[0].partOfSpeech}) - ${meanings[0].definitions[0].definition}', style: TextStyle(color: AppColors.black.withOpacity(0.8), fontSize: 15, fontWeight: weight ), ),
          ],
        ),
    );}

  buildStatistics() {
    return Container(
      padding: Responsive.isMobile(context) ? EdgeInsets.symmetric(vertical: 12) : null,
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color:Responsive.isMobile(context)? AppColors.grey.withOpacity(0.6): null,
        borderRadius: BorderRadius.circular(8),
      ),
      width: 500/1.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text('STATISTICS', style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight:weight),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                buildStatsCell(statistics.played, 'played',13),
                buildStatsCell(statistics.win, 'won', 14),
                buildStatsCell(statistics.today, 'Today', 13),
                buildStatsCell(statistics.maxInADay, 'Max In\nA Day', 13),
            ],
          ),

          Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:  Text('GUESS DISTRIBUTION', style: TextStyle(fontSize: 16, color: AppColors.black, fontWeight: weight),)),
          buildBarChart(),
        ],
      ),
    );
  }

  buildStatsCell(int count, String title, double titleSize){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(count.toString(),style: TextStyle(fontWeight: weight, fontSize: 24, color: AppColors.black, ),),
          Text(title,style: TextStyle(fontSize: titleSize, color: AppColors.black.withOpacity(0.9), ),),
        ],
      ),
    );
  }

  separator(){
    return Container(height: 0.1, width : 500, color: AppColors.lightGrey,);
  }


  //based on laptop and mobile different //currently for mobile
  getBottomSheetHeight() {
    return height/1.3;
  }

  Color barColor(index)=> solvedInSteps == index ? AppColors.correct: AppColors.notInWord;

  buildBarChart() {
    final dist = statistics.guessDistribution;
    int maxCount = dist.reduce((curr, next) => curr > next? curr: next);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: width/1.38,
      child: Column(
        children: [
          buildBar(1, dist[0], maxCount, barColor(1)),
          buildBar(2, dist[1], maxCount, barColor(2)),
          buildBar(3, dist[2], maxCount, barColor(3)),
          buildBar(4, dist[3], maxCount, barColor(4)),
          buildBar(5, dist[4], maxCount, barColor(5)),
          buildBar(6, dist[5], maxCount, barColor(6)),
        ],
      ),
    );
  }


  buildBar(int number, int count, int maxCount, Color color){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Center(child: Text(number.toString(), style: TextStyle(fontWeight:weight, fontSize: 16, ),)),
          ),
          Expanded(
              flex: count,
              child: Container(
                padding: EdgeInsets.only(right: 4, left: 4),
                  color: color,
                  child: Text(count.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 15, fontWeight: weight, color: AppColors.white.withOpacity(0.8)),))
          ),
          Expanded(
              flex: maxCount-count,
              child: Container(),
          ),
        ],
      ),
    );
  }


  //login and share
  buildBottomAction() {
    return Container(
      width: width/1.2,
      padding: EdgeInsets.only(bottom: 16, top: 16, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child:Padding(
              padding: EdgeInsets.only(right: 4),
              child: StadiumButton(
                title: 'Play Again',
                textStyle: TextStyle(fontSize: 16, color: AppColors.black),
                background: AppColors.inWord,
                isLoading: false,
                height: 44,
                onPressed: (){playAgain(); Navigator.of(context).pop();},
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 4),
              child: StadiumButton(
                title: 'Log In',
                textStyle: TextStyle(fontSize: 16, color: AppColors.white),
                background: AppColors.correct,
                isLoading: false,
                height: 44,
                onPressed: ()=> Provider.of<WordleController>(context).showUpperToast('coming soon', 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
