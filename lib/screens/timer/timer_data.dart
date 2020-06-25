class TimerData {
  void addItem(String time, String name) {
    mainData.add({time: name});
  }

  List<Map<String, String>> mainData = [
    {'37 : 54 : 00': ''},
    {'37 : 53 : 00': 'Fsgcx'},
    {'00 : 05': 'Vdfvvcvbvdvsddcvsv'},
    {'01 : 00': 'Aa'},
  ];
}

TimerData timerData = TimerData();
