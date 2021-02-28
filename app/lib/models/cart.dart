import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class CartModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;

  void update(String itemId) {
    if (_items.contains(itemId)) {
      _items.remove(itemId);
    } else {
      _items.add(itemId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
