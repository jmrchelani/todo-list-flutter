import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/provider/category_provider.dart';

class Task {
  int id;
  final String name;
  bool isDone = false;
  final DateTime deadline;
  final Category category;

  Task({this.name, this.deadline, this.category, this.isDone = false});

  static Task fromMap(BuildContext context, Map<String, dynamic> map) {
    return Task(
      category: Provider.of<CategoryProvider>(context, listen: false)
          .categories
          .firstWhere((element) => element.name == map['category']),
      name: map['name'],
      deadline: DateTime.tryParse(map['deadline']),
      isDone: map['isDone'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.name,
      'deadline': deadline.toIso8601String(),
      'isDone': (isDone) ? 1 : 0,
    };
  }

  String toString() {
    return '{ name: ' +
        name +
        ', deadline: ' +
        deadline.toIso8601String() +
        ', category: ' +
        category.toString() +
        ', isDone: ' +
        isDone.toString() +
        ' }';
  }
}
