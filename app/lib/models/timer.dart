import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  int seconds;

  TimerModel(this.seconds);

  void countdown() {
    seconds -= 1;
    notifyListeners();
  }

  void clear() {
    seconds = 0;
    notifyListeners();
  }
}
