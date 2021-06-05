import 'package:flutter/material.dart';

class AddCategoryProvider extends ChangeNotifier {
  String name = '';
  Icon icon;

  void setIcon(Icon ok) {
    icon = ok;
    notifyListeners();
  }

  void setName(String ez) {
    name = ez;
    notifyListeners();
  }
}
