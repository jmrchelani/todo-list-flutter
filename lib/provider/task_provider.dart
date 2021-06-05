import 'package:flutter/material.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/database_model.dart';
import 'package:todo_list/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = <Task>[];

  Future<List<Task>> getAllTasks(BuildContext context) async {
    this.tasks = await SQLDatabase.instance.getAllTasks(context);

    return tasks;
  }

  void addTask(String name, DateTime deadline, Category category) async {
    Task tmpTask = Task(category: category, name: name, deadline: deadline);
    await SQLDatabase.instance.createTask(tmpTask);
    tasks.add(tmpTask);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    task.isDone = !task.isDone;
    SQLDatabase.instance.updateTask(task);
    notifyListeners();
  }

  void deleteTask(Task task) async {
    tasks.removeWhere((element) => element == task);
    await SQLDatabase.instance.deleteTask(task);
    notifyListeners();
  }

  void deleteTaskOfCategory(Category cat) {
    tasks.forEach((element) async {
      if (element.category == cat) {
        await SQLDatabase.instance.deleteTask(element);
      }
    });
    tasks.removeWhere((element) => element.category == cat);

    notifyListeners();
  }
}
