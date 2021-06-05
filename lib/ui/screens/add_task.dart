import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/add_task_provider.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/utils/colors.dart';
import 'package:todo_list/utils/utils.dart';

class AddTaskScreen extends StatefulWidget {
  int catID;
  AddTaskScreen({Key key, this.catID});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController nameController = TextEditingController();

  final textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kGreyishWhiteColor,
        shadowColor: kGreyishWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              resetData(context);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'New Task',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: kGreyishWhiteColor,
      body: FooterLayout(
        footer: KeyboardAttachable(
          child: GestureDetector(
            onTap: () {
              if (!textKey.currentState.validate()) return null;
              Provider.of<TaskProvider>(context, listen: false).addTask(
                  nameController.text,
                  Provider.of<AddTaskProvider>(context, listen: false).deadline,
                  (Provider.of<AddTaskProvider>(context, listen: false)
                              .category !=
                          CATEGORY_ALL)
                      ? Provider.of<AddTaskProvider>(context, listen: false)
                          .category
                      : Provider.of<CategoryProvider>(context, listen: false)
                          .categories[widget.catID]);
              resetData(context);
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              height: 60,
              color: kBlueColor,
              child: Center(
                child: Text(
                  'Create',
                  style: TextStyle(
                      inherit: false, color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'What are you planning?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: textKey,
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name of task';
                        }
                        if (Provider.of<TaskProvider>(context, listen: false)
                            .tasks
                            .any((element) => element.name == value))
                          return "Task already exists";
                        return null;
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text(getDateTime(
                      Provider.of<AddTaskProvider>(context, listen: false)
                              .deadline ??
                          DateTime.now())),
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime.now().subtract(Duration(days: 3650)),
                      maxTime: DateTime.now().add(Duration(days: 3650)),
                      onConfirm: (date) {
                        Provider.of<AddTaskProvider>(context, listen: false)
                            .setDeadline(date);
                        setState(() {});
                      },
                      currentTime:
                          Provider.of<AddTaskProvider>(context, listen: false)
                              .deadline,
                      locale: LocaleType.en,
                      theme: DatePickerTheme(
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.label_outline_rounded),
                  title: Text(Provider.of<CategoryProvider>(context)
                      .categories[widget.catID]
                      .name),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Choose category'),
                          children: getCategoriesList(context),
                        );
                      },
                    ).then((value) => setState(() {
                          print(widget.catID);
                        }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getCategoriesList(BuildContext context) {
    List<Widget> cats = [];
    if (Provider.of<CategoryProvider>(context).categories.length == 0) {
      cats.add(Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text('No Category Added'),
      ));
      return cats;
    }
    for (int i = 0;
        i < Provider.of<CategoryProvider>(context).categories.length;
        ++i) {
      cats.add(
        SimpleDialogOption(
          child:
              Text(Provider.of<CategoryProvider>(context).categories[i].name),
          onPressed: () {
            widget.catID = i;
            Provider.of<AddTaskProvider>(context, listen: false).setCategory(
                Provider.of<CategoryProvider>(context, listen: false)
                    .categories[i]);
            Navigator.of(context).pop();
          },
        ),
      );
    }
    return cats;
  }

  void resetData(BuildContext context) {
    Provider.of<AddTaskProvider>(context, listen: false)
        .setDeadline(DateTime.now());
    Provider.of<AddTaskProvider>(context, listen: false)
        .setCategory(CATEGORY_ALL);
  }
}
