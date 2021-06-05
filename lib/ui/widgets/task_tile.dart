import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/utils/colors.dart';
import 'package:todo_list/utils/utils.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({Key key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Dismissible(
        key: Key(task.name),
        onDismissed: (direction) {
          Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
        },
        background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            task.name,
            style: TextStyle(
              decoration: (task.isDone) ? TextDecoration.lineThrough : null,
              color: (task.isDone) ? kBlueColor : Colors.black,
            ),
          ),
          subtitle: Text(
            // '20:15 - April 29',
            getDateTime(task.deadline),
            style: TextStyle(
              color: (task.deadline.isBefore(DateTime.now()) && !task.isDone)
                  ? Colors.red
                  : Colors.black54,
            ),
          ),
          trailing: Container(
            width: 70,
            height: 70,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Checkbox(
                value: task.isDone,
                onChanged: (value) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .toggleTaskStatus(task);
                },
                splashRadius: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
