import 'dart:collection';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/models/cellModel.dart';
import 'package:wordle/models/statisticsModel.dart';
import 'package:wordle/state/appState.dart';
import '../helpers/wordle_dictionary.dart';
import '../services/free_dictionary.dart';
import '../services/data/database/shared_preferences.dart';
import '../utils/values/enums.dart';



class WordleController extends AppState{

  late String wordle;
  late WordMeaning wordMeaning = WordMeaning(word: 'hello',meanings: []);
  int index = 0;
  int row = 0;
  int wordLength = 0;
  List<String> pattern = [];
  GameStatus gameStatus = GameStatus.playing;
  List<CellModel> cells = List.generate(30, (index) => CellModel());
  final keyboardUsedLetters = HashMap<String, CellState>();
  final client = DioClient();

  WordleController(){initWordle();}

  late StatisticsModel statistics;

  initWordle(){
    StatisticsModel? model = AppSharedPrefs.getStatistics();
    if(model == null){
      model = StatisticsModel(played: 0, win: 0, today: 0, maxInADay: 0, guessDistribution: [0,0,0,0,0,0]);
      AppSharedPrefs.saveStatistics(model);
    }
    statistics = model;

    List<List<String>>? panelState = AppSharedPrefs.getPanelState();

    wordle = wordleList[model.played+1].toUpperCase(); print(wordle);
    Future.delayed(Duration(seconds: 2,),()async {await getWordleMeaning(); print('fetched the meaning');});

    if(panelState == null){ return; }
    print(panelState.length);
    for(int i = 0; i< panelState.length; i++){
      for(int j = 0;j<5;j++){
        cells[i*5+j].word = panelState[i][j];
      }
      index+=5;
    }

  }

  resetWordle(){
    wordle = wordleList[statistics.played+1].toUpperCase();
    print(wordle);
    keyboardUsedLetters.clear();
    pattern.clear();
    resetCells();
    gameStatus = GameStatus.playing;
    index = 0; row=0; wordLength= 0;
    notifyListeners();
  }

  addWord(String word){
    if(gameStatus != GameStatus.playing){ print(gameStatus); return; }
    if(word.length != 1){ return; }
    if(wordLength == 5) {return;}
    cells[index].fill(word);
    index++;wordLength++;
  }

  removeWord(){
    if(gameStatus != GameStatus.playing){ return; }
    if(wordLength == 0){return;}
    index--;wordLength--;
    cells[index].clear();
  }

  checkWordle({required bool async})async{
    if(gameStatus != GameStatus.playing){ return; }
    if(wordLength != 5){ showUpperToast('not enough letters', 3); shakeRowOnError(row); return;}
    print('checkWordleCalled0');

    List<String> guess = [];
    for(int i = 0; i<5; i++){
      guess.add(cells[row*5+ i].word);
    }
    print('checkWordleCalled1');

    if(!wordExists(guess.join())){ showUpperToast('Word not in dictionary', 3);  shakeRowOnError(row); return;}
    print('checkWordleCalled2');

    gameStatus = GameStatus.submitting;
    final pattern = getMatchPattern(guess);
    async ? await assignCellState(pattern, guess, async: true) : assignCellState(pattern, guess, async: false);
    if(async) updatePanelState();
    row++;wordLength = 0;
    print('checkWordleCalled3');

  }

  updatePanelState(){
    List<List<String>> panelState= List.generate(row+1, (rowI) => List.generate(5, (colI)=> cells[rowI*5+colI].toString()));
    AppSharedPrefs.savePanelState(panelState);
  }


  bool wordExists(String guess)=>guessList.contains(guess.toLowerCase());

  List<String> getMatchPattern(List<String> guess) {
    pattern.clear();
    for(int i = 0;i< 5; i++) {
      if(!wordle.contains(guess[i])){
        pattern.add('b');
      }else if(guess[i] == wordle[i] ){
        pattern.add('g');
      }else{ pattern.add('y'); }
    }
    return pattern;
  }

  Future<void> assignCellState(List<String> pattern, List<String> guess, {required bool async}) async{
    CellState state = CellState.empty;
    for(int i = 0; i< 5 ;i++) {
        switch(pattern[i]){
          case 'b' : state = CellState.notInWord; break;
          case 'y': state = CellState.inWord; break;
          case 'g' : state = CellState.correct ; break;
        }
        cells[row*5+i].assignState(state);
        async ?
        await Future.delayed(
          const Duration(milliseconds: 250),
            (){ cells[row*5+i].flip(); }) : cells[row*5+i].flip();
        if(keyboardUsedLetters[guess[i]]==null) {
          keyboardUsedLetters[guess[i]] = state;
        }else if (keyboardUsedLetters[guess[i]] == CellState.inWord && state == CellState.correct){
          keyboardUsedLetters[guess[i]] = state;
        }
    }
  }

  //called after row has increased
  void checkWinOrLoss(String pattern) {
    if(pattern.length != 5){return;}
    bool gameEnded = false;
    if(pattern == 'ggggg'){
      gameStatus = GameStatus.won;
      statistics.played++;
      statistics.win++;
      statistics.today++;
      statistics.maxInADay =max(statistics.maxInADay, statistics.today);
      statistics.guessDistribution[row-1]++;
      gameEnded= true;
    } else if(row == 6){
      gameStatus = GameStatus.lost;
      statistics.played++;
      statistics.today =0;
      statistics.maxInADay =max(statistics.maxInADay, statistics.today);
      gameEnded = true;
    } else { gameStatus = GameStatus.playing;}

    if(gameEnded){
      if(gameStatus == GameStatus.won){
        showWinComplement(); //toast showing complement
        setWinAnimation(true);//lottie congratulation animation playing
      }
      else{ showUpperToast(wordle, 5); }
      AppSharedPrefs.saveStatistics(statistics);
      AppSharedPrefs.clearPanelState();

    }
  }

  getWordleMeaning()async{
    try {
      final wordMeaning = await DictionaryApi(client).getMeaning(wordle);
      this.wordMeaning = wordMeaning;
    }catch(e){
      showUpperToast(e.toString(), 3);
    }
  }


  //ui handles
  showWinComplement(){
    print(isWinAnimationVisible);
    final complements = ['Genius','Magnificent','Awesome','Marvelous','Nice', 'Phew'];
    showUpperToast(complements[row-1], 3);
  }


  resetCells(){
    for(int i = 0;i< 5*row;i++){
      cells[i].state = CellState.empty;
      cells[i].word = '';
      cells[i].flip();
    }
  }

  shakeRowOnError(int row){
    for(int i = 0;i< 5; i++){
      cells[row*5 + i].shake();
    }
  }

  updateValues(){
    checkWinOrLoss(pattern.join());
    notifyListeners();
  }

  //wordle toast
  bool isToastVisible = false;
  String toastMessage = '';

  showUpperToast(String message, int duration){
    toastMessage = message;
    isToastVisible = true;
    notifyListeners();
    Future.delayed(Duration(seconds: duration),(){isToastVisible = false; toastMessage = '';  notifyListeners();});
  }

  bool isWinAnimationVisible = false;
  setWinAnimation(bool value){
    isWinAnimationVisible = value;
  }
}
