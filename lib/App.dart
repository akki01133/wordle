import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/data/firebase/firebase_auth.dart';
import 'package:wordle/state/wordle_controller.dart';
import 'module/pages/wordle_screen.dart';


class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider<WordleController>(create: (_)=> WordleController()),
            ChangeNotifierProvider<AuthProvider>(create: (_)=> AuthProvider()),
          ],
          child: WordleScreen()),
    );
  }
}
