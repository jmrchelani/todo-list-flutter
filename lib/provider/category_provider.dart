import 'package:flutter/material.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/database_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];

  Future<List<Category>> getAllCategories(BuildContext context) async {
    this.categories = await SQLDatabase.instance.getAllCategories();
    return categories;
  }

  void addCategory(String name, Icon icon, Color color) async {
    Category tmpCat = Category(name, icon, color);
    categories.add(tmpCat);
    await SQLDatabase.instance.createCategory(tmpCat);
    notifyListeners();
  }

  void deleteCategory(int index) async {
    await SQLDatabase.instance.deleteCategory(categories[index]);
    categories.removeAt(index);
    notifyListeners();
  }
}
