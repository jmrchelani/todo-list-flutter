import 'package:flutter/material.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/utils/utils.dart';

class AddTaskProvider extends ChangeNotifier {
  DateTime deadline = DateTime.now();
  Category category = CATEGORY_ALL;

  bool deadlineClicked = false, catSet = false;

  void setDeadline(DateTime op) {
    deadline = op;
    deadlineClicked = true;
    notifyListeners();
  }

  void setCategory(Category op) {
    category = op;
    catSet = true;
    notifyListeners();
  }
}
