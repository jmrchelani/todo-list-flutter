import 'package:flutter/material.dart';
import 'package:todo_list/ui/screens/add_task.dart';
import 'package:todo_list/utils/colors.dart';

class AddTaskButton extends StatelessWidget {
  final catID;

  const AddTaskButton({Key key, this.catID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 70.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskScreen(catID: catID)),
            );
          },
          backgroundColor: kBlueColor,
          child: Icon(
            Icons.add,
            size: 20,
          ),
          // elevation: 0.1,
        ),
      ),
    );
  }
}
