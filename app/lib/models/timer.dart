import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  int seconds;

  void countdown() {
    seconds--;
    notifyListeners();
  }

  void clear() {
    seconds = 0;
    notifyListeners();
  }
}
