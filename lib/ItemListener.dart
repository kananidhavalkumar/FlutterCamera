import 'package:firstFlutter/Item.dart';
import 'package:flutter/foundation.dart';

class ItemListener extends ChangeNotifier {
  List<Item> items = [];

  void addItem(String name, int value) {
    Item newItem = new Item(name: name, number: value);

    items.add(newItem);
    notifyListeners();
  }
}
