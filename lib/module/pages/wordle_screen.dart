import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordle/helpers/utility.dart';
import 'package:wordle/models/cellModel.dart';
import 'package:wordle/module/widgets/scaffold/appBar.dart';
import 'package:wordle/module/widgets/responsive.dart';
import 'package:wordle/module/widgets/statsBottomSheet.dart';
import 'package:wordle/services/free_dictionary.dart';
import 'package:wordle/state/wordle_controller.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/styles.dart';
import '../../utils/values/enums.dart';
import '../widgets/buttons/iconButton.dart';
import '../widgets/scaffold/profileDrawer.dart';
import '../widgets/shakeOnErrorWidget.dart';
import '../widgets/wordle_keyboard.dart';

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key}) : super(key: key);

  @override
  State<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Provider.of<WordleController>(context,listen: false).setWinAnimation(false);
        controller.reset();
        Utility.openCreateBottomSheet(context: context, child: statsBottomSheet);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final controller = Provider.of<WordleController>(context,listen: false) ;
        if(controller.index!= 0){
          Future.delayed(Duration(seconds: 1), (){
            for(int i =0; i< controller.index~/5;i++){
              controller.wordLength = 5;
              controller.gameStatus = GameStatus.playing;
              print('calling check wordle');
              controller.checkWordle(async: false);
            }
          });
        }
    });
  }

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKey: (event){
        Utility.handleKeyPressed(event: event,context: context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: WordleAppBar(openStatistics : ()=> Utility.openCreateBottomSheet(context: context, child: statsBottomSheet)),
        body: Stack(
          children: [
            Selector<WordleController, List<Object>>(
              selector: (_, controller)=> [controller.isToastVisible, controller.toastMessage],
                builder: (_, data, child) => _buildWordleToast(
                    data[0] as bool, data[1] as String)),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: AppColors.lightGrey, width: 1))),
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: [wordlePanelBuilder()],)),
                  WordleKeyboard(),
                ],
              ),
            ),
          ],
        ),
        drawer: ProfileDrawer(),
      ),
    );
  }

  buildWinAnimationWidget() {
    print('creating win animation');
    return Lottie.asset('assets/json/congratulations.json',
        controller: controller,
        onLoaded: (composition){print('loaded win animation');});
  }


  Widget get statsBottomSheet{
    final controller = Provider.of<WordleController>(context, listen: false);
    return StatsBottomSheet(
      context: context,
      word: controller.wordle,
      statistics: controller.statistics,
      playAgain: controller.resetWordle,
      solvedInSteps: controller.row,
      shareCallback: (){},
      meanings: controller.wordMeaning.meanings,
  );
  }

  _buildWordleToast(bool isVisible, String message) {
    return Positioned(
        left: 0,
        right: 0,
        child: Visibility(
          visible: isVisible,
          maintainSize: false,
          child: Center(
            child: Container(
                margin: EdgeInsets.only(top: 4),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  message,
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                )),
          ),
        ));
  }

  wordlePanelBuilder() {
    const size = 330.0;
    return Center(
      child: Consumer<WordleController>(
        builder: (_, wordleState, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: size,
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<CellModel>.value(
                        value: wordleState.cells[index],
                        key: ValueKey(wordleState.cells[index]),
                        child: Consumer<CellModel>(
                          builder: (__, cell, child) => flipAndShakeContainer(cell, index,()=> Provider.of<WordleController>(context,listen: false).updateValues()),
                        ),
                      );})),
              Selector<WordleController, bool>(
                  selector: (_, controller) => controller.isWinAnimationVisible,
                  builder:(_, isVisible, child) {
                    if(isVisible) controller.forward();
                    return Center(
                      child: Visibility(
                        visible: isVisible,
                        maintainState: true,
                        child: buildWinAnimationWidget(),
                      ),
                    );
                  }
              ),
            ]
          );
          },
      ),
    );
  }

  flipAndShakeContainer(CellModel cell, int index, VoidCallback updateKeyboardCallback, ) {
    return ShakeWidget(
        key: cell.shakeKey,
        shakeCount: 3,
        shakeOffset: 4,
        duration: Duration(milliseconds: 350),
        child: FlipCard(
          key: cell.flipKey,
          direction: FlipDirection.VERTICAL,
          flipOnTouch: false,
          onFlipDone:
              index % 5 == 4 ? (value) => updateKeyboardCallback() : null,
          front: wordCell(word:cell.word, state: cell.state == CellState.empty ? CellState.empty : CellState.filled),
          back: wordCell(word: cell.word, state: cell.state),
        ));
  }

  Widget wordCell({required word, required state}) {
    return Container(
      decoration: BoxDecoration(
        color: getCellColor(state),
        border: getBorder(state),
      ),
      child: Center(
        child: Text(
          word,
          style: TextStyle(
            fontSize: 24,
            color: (state == CellState.filled)
                ? AppColors.black
                : AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
