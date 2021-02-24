import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<String> _itemFileUrls = [];

  List<String> get items => _itemFileUrls;

  void update(String fileUrl) {
    if (_itemFileUrls.contains(fileUrl)) {
      _itemFileUrls.remove(fileUrl);
    } else {
      _itemFileUrls.add(fileUrl);
    }
    notifyListeners();
  }

  void clear() {
    _itemFileUrls.clear();
    notifyListeners();
  }
}
