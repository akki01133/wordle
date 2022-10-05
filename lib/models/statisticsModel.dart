class StatisticsModel {
  late int played;
  late int win;
  late int today;
  late int maxInADay;
  late List<int> guessDistribution;

  StatisticsModel(
      {required this.played,
        required this.win,
        required this.today,
       required this.maxInADay,
        required this.guessDistribution});

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    played = json['played'];
    win = json['win'];
    today = json['today'];
    maxInADay = json['maxInADay'];
    guessDistribution = json['guessDistribution'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['played'] = played;
    data['win'] = win;
    data['today'] = today;
    data['maxInADay'] = maxInADay;
    data['guessDistribution'] = guessDistribution;
    return data;
  }
}
