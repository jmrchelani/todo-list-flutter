import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/category_model.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/ui/screens/tasks.dart';
import 'package:todo_list/ui/widgets/add_category.dart';
import 'package:todo_list/ui/widgets/category_tile.dart';
import 'package:todo_list/utils/colors.dart';
import 'package:todo_list/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoryProvider>(context, listen: false)
        .getAllCategories(context);
    Provider.of<TaskProvider>(context, listen: false).getAllTasks(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreyishWhiteColor,
        shadowColor: Colors.transparent,
      ),
      floatingActionButton: AddCategoryButton(),
      body: FutureBuilder(
          future:
              Provider.of<CategoryProvider>(context).getAllCategories(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null)
              return Container(child: Center(child: Text('Loading...')));
            return SingleChildScrollView(
              child: Container(
                color: kGreyishWhiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          Text(
                            '  Lists',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                        ] +
                        dynamicLists(context),
                  ),
                ),
              ),
            );
          }),
    );
    // );
  }

  List<Widget> dynamicLists(BuildContext context) {
    List<Category> categories =
        Provider.of<CategoryProvider>(context).categories;
    List<Widget> rows = [];
    if (categories.length == 0) {
      rows.add(
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CategoryTile(
                category: CATEGORY_ALL,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksScreen(
                        catID: -1,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                },
              ),
            ],
          ),
        ),
      );
    } else {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryTile(
                category: CATEGORY_ALL,
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksScreen(
                        catID: -1,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                }),
            CategoryTile(
                category: categories[0],
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TasksScreen(
                        catID: 0,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                }),
          ],
        ),
      );
      rows.add(SizedBox(
        height: 20,
      ));
    }
    for (int i = 1; i < categories.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: (i + 1 < categories.length)
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: (i + 1 < categories.length)
                  ? EdgeInsets.all(0)
                  : EdgeInsets.all(10),
              child: CategoryTile(
                  category: categories[i],
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksScreen(
                          catID: i,
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  }),
            ),
            if (i + 1 < categories.length)
              CategoryTile(
                  category: categories[i + 1],
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TasksScreen(
                          catID: i + 1,
                        ),
                      ),
                    ).then((value) => setState(() {}));
                  }),
          ],
        ),
      );
      rows.add(SizedBox(
        height: 20,
      ));
    }
    return rows;
  }
}
