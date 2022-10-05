import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:wordle/firebase_options.dart';
import 'package:wordle/state/wordle_controller.dart';
import 'package:wordle/services/data/database/shared_preferences.dart';

Future dependencySetup() async{
  await AppSharedPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Get.put(WordleController());
}
