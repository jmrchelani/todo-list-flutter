import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/ui/screens/tasks.dart';
import 'package:todo_list/ui/widgets/category_tile.dart';
import 'package:todo_list/ui/widgets/task_tile.dart';

final Category CATEGORY_ALL =
    Category('All', Icon(Icons.task_alt_outlined), Colors.blue);

const months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

List<Widget> loadTasks(BuildContext context, int cat) {
  if (cat == -1) return loadAllTasks(context);
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  List<Category> categories = Provider.of<CategoryProvider>(context).categories;
  List<Task> tmpTask = <Task>[] + tasks;
  tmpTask.sort((a, b) => a.deadline.difference(b.deadline).inSeconds);
  List<Widget> list = [];
  if (getTotalTaskCount(context, cat) <= 0) {
    list.add(SizedBox(height: 25));
    list.add(Center(child: Text('No Tasks')));
    return list;
  }
  if (getTotalLateTasks(context, cat) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Late',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isBefore(DateTime.now()) &&
          !tmp.isDone &&
          tmp.category == categories[cat]) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((element) =>
        element.deadline.isBefore(DateTime.now()) &&
        !element.isDone &&
        element.category == categories[cat]);
  }
  if (getTodayTasks(context, cat) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Today',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isAfter(DateTime.now()) &&
          tmp.deadline.day == DateTime.now().day &&
          tmp.deadline.month == DateTime.now().month &&
          !tmp.isDone &&
          tmp.category == categories[cat]) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) =>
        tmp.deadline.isAfter(DateTime.now()) &&
        tmp.deadline.day == DateTime.now().day &&
        tmp.deadline.month == DateTime.now().month &&
        !tmp.isDone &&
        tmp.category == categories[cat]);
  }

  if (getLaterTasks(context, cat) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Later',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isAfter(DateTime.now()) &&
          tmp.deadline.day != DateTime.now().day &&
          !tmp.isDone &&
          tmp.category == categories[cat]) {
        print(tmp);
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) =>
        tmp.deadline.isAfter(DateTime.now()) &&
        tmp.deadline.day != DateTime.now().day &&
        !tmp.isDone &&
        tmp.category == categories[cat]);
  }

  if (getDoneTasks(context, cat) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Done',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.isDone && tmp.category == categories[cat]) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) => tmp.isDone && tmp.category == categories[cat]);
  }
  return list;
}

List<Widget> loadAllTasks(BuildContext context) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  List<Task> tmpTask = <Task>[] + tasks;
  tmpTask.sort((a, b) => a.deadline.difference(b.deadline).inSeconds);
  List<Widget> list = [];
  if (getTotalTaskCount(context, -1) <= 0) {
    list.add(SizedBox(height: 25));
    list.add(Center(child: Text('No Tasks')));
    return list;
  }
  if (getTotalLateTasks(context, -1) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Late',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isBefore(DateTime.now()) && !tmp.isDone) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((element) =>
        element.deadline.isBefore(DateTime.now()) && !element.isDone);
  }
  if (getTodayTasks(context, -1) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Today',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isAfter(DateTime.now()) &&
          tmp.deadline.day == DateTime.now().day &&
          tmp.deadline.month == DateTime.now().month &&
          !tmp.isDone) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) =>
        tmp.deadline.isAfter(DateTime.now()) &&
        tmp.deadline.day == DateTime.now().day &&
        tmp.deadline.month == DateTime.now().month &&
        !tmp.isDone);
  }
  if (getLaterTasks(context, -1) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Later',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.deadline.isAfter(DateTime.now()) &&
          !(tmp.deadline.day == DateTime.now().day) &&
          !tmp.isDone) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) =>
        tmp.deadline.isAfter(DateTime.now()) &&
        !(tmp.deadline.day == DateTime.now().day) &&
        !tmp.isDone);
  }
  if (getDoneTasks(context, -1) > 0) {
    list.add(SizedBox(height: 25));
    list.add(Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Text(
        'Done',
        style: TextStyle(color: Colors.black54),
      ),
    ));
    for (Task tmp in tmpTask) {
      if (tmp.isDone) {
        list.add(TaskTile(task: tmp));
      }
    }
    tmpTask.removeWhere((tmp) => tmp.isDone);
  }
  return list;
}

int getTotalTaskCount(BuildContext context, int cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  List<Category> categories = Provider.of<CategoryProvider>(context).categories;
  if (cat == -1) return tasks.length;
  int taskCounter = 0;
  for (Task _task in tasks) {
    if (_task.category == categories[cat]) taskCounter++;
  }
  return taskCounter;
}

int getTotalLateTasks(BuildContext context, int cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  int taskCounter = 0;
  if (cat == -1) {
    for (Task _task in tasks) {
      if (_task.deadline.isBefore(DateTime.now()) && !_task.isDone)
        taskCounter++;
    }
    return taskCounter;
  }
  for (Task _task in tasks) {
    List<Category> categories =
        Provider.of<CategoryProvider>(context).categories;
    if (_task.category == categories[cat] &&
        _task.deadline.isBefore(DateTime.now()) &&
        !_task.isDone) taskCounter++;
  }
  return taskCounter;
}

int getTodayTasks(BuildContext context, int cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  int taskCounter = 0;
  if (cat == -1) {
    for (Task _task in tasks) {
      if (_task.deadline.isAfter(DateTime.now()) &&
          _task.deadline.day == DateTime.now().day &&
          _task.deadline.month == DateTime.now().month &&
          !_task.isDone) taskCounter++;
    }
    return taskCounter;
  }
  for (Task _task in tasks) {
    List<Category> categories =
        Provider.of<CategoryProvider>(context).categories;
    if (_task.category == categories[cat] &&
        _task.deadline.isAfter(DateTime.now()) &&
        _task.deadline.day == DateTime.now().day &&
        _task.deadline.month == DateTime.now().month &&
        !_task.isDone) taskCounter++;
  }
  return taskCounter;
}

int getLaterTasks(BuildContext context, int cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  int taskCounter = 0;
  if (cat == -1) {
    for (Task _task in tasks) {
      if (_task.deadline.isAfter(DateTime.now()) &&
          _task.deadline.day != DateTime.now().day &&
          !_task.isDone) taskCounter++;
    }
    return taskCounter;
  }
  List<Category> categories = Provider.of<CategoryProvider>(context).categories;
  for (Task _task in tasks) {
    if (_task.category == categories[cat] &&
        _task.deadline.isAfter(DateTime.now()) &&
        _task.deadline.day != DateTime.now().day &&
        !_task.isDone) taskCounter++;
  }

  return taskCounter;
}

int getDoneTasks(BuildContext context, int cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context).tasks;
  int taskCounter = 0;
  if (cat == -1) {
    for (Task _task in tasks) {
      if (_task.isDone) taskCounter++;
    }
    return taskCounter;
  }
  List<Category> categories = Provider.of<CategoryProvider>(context).categories;
  for (Task _task in tasks) {
    if (_task.category == categories[cat] && _task.isDone) taskCounter++;
  }
  return taskCounter;
}

int getTotalTaskCountByCat(BuildContext context, Category cat) {
  List<Task> tasks = Provider.of<TaskProvider>(context, listen: false).tasks;
  if (cat == CATEGORY_ALL) return tasks.length;
  int taskCounter = 0;
  for (Task _task in tasks) {
    if (_task.category.name == cat.name) taskCounter++;
  }
  return taskCounter;
}

String getDateTime(DateTime dateTime) {
  return '' +
      ((dateTime.hour > 9)
          ? dateTime.hour.toString()
          : '0' + dateTime.hour.toString()) +
      ':' +
      ((dateTime.minute > 9)
          ? dateTime.minute.toString()
          : '0' + dateTime.minute.toString()) +
      ' - ' +
      months[dateTime.month] +
      ' ' +
      dateTime.day.toString();
}
