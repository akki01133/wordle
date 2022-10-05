import 'package:flutter/material.dart';
import 'package:wordle/services/service_locator.dart';
import 'App.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencySetup();
  runApp(const App());
}
