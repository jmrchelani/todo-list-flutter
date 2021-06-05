import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/ui/widgets/add_task_button.dart';
import 'package:todo_list/utils/colors.dart';
import 'package:todo_list/utils/utils.dart';

class TasksScreen extends StatelessWidget {
  final int catID;

  const TasksScreen({Key key, this.catID = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (catID != -1) ? AddTaskButton(catID: catID) : null,
      backgroundColor: kBlueColor,
      body: FutureBuilder(
        initialData: Provider.of<CategoryProvider>(context).categories,
        future: Provider.of<TaskProvider>(context).getAllTasks(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // print(snapshot.data);
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text('Loading...'),
              ),
            );
          } else
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 15),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (catID != -1)
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, right: 10),
                        child: PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuItem<int>>[
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: Text('Delete Category'),
                                  ),
                                ],
                            onSelected: (int value) {
                              if (value == 1) {
                                Navigator.of(context).pop();
                                Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .deleteTaskOfCategory(
                                        Provider.of<CategoryProvider>(context,
                                                listen: false)
                                            .categories[catID]);
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .deleteCategory(catID);
                              }
                            }),
                      ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kGreyishWhiteColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: (catID < 0)
                                ? CATEGORY_ALL.icon
                                : Provider.of<CategoryProvider>(context)
                                    .categories[catID]
                                    .icon,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          (catID == -1)
                              ? CATEGORY_ALL.name
                              : Provider.of<CategoryProvider>(context)
                                  .categories[catID]
                                  .name,
                          style: TextStyle(
                            color: kGreyishWhiteColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          getTotalTaskCount(context, catID).toString() +
                              ' Tasks',
                          style: TextStyle(
                            color: kGreyishWhiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: loadTasks(context, catID),
                      ),
                    ),
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
