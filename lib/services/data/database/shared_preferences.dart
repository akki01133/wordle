import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/statisticsModel.dart';

class AppSharedPrefs{
  static late final SharedPreferences _prefs;
  static Future init() async => _prefs = await SharedPreferences.getInstance();
  static const _keyWordIndex = 'scrypto.word.index';


  static Future clearPreferenceValues() async {
     _prefs.clear();
  }

  static Future<bool> saveStatistics(StatisticsModel stats) async {
    return await _prefs.setString(
        UserPreferenceKey.statistics.toString(), json.encode(stats.toJson()));
  }

  static StatisticsModel? getStatistics()  {
    final String? jsonString = _prefs
        .getString(UserPreferenceKey.statistics.toString());
    if (jsonString == null) return null;
    return StatisticsModel.fromJson(json.decode(jsonString));
  }

  static Future<bool> savePanelState(List<List<String>> state) async {
    return await _prefs.setString(
        UserPreferenceKey.panelState.toString(), json.encode(state));
  }

  static List<List<String>>? getPanelState()  {
    final String? jsonString = _prefs
        .getString(UserPreferenceKey.panelState.toString());
    if (jsonString == null) return null;
    return json.decode(jsonString).map<List<String>>((l) => List<String>.from(l)).toList();
  }

  static Future clearPanelState() async {
    _prefs.remove(UserPreferenceKey.panelState.toString());
  }

}

enum UserPreferenceKey { statistics, panelState }
