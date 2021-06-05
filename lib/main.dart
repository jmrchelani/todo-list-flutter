import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/add_category_provider.dart';
import 'package:todo_list/provider/add_task_provider.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/provider/task_provider.dart';
import 'package:todo_list/ui/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider()),
        ChangeNotifierProvider<AddCategoryProvider>(
            create: (_) => AddCategoryProvider()),
        ChangeNotifierProvider<TaskProvider>(create: (_) => TaskProvider()),
        ChangeNotifierProvider<AddTaskProvider>(
            create: (_) => AddTaskProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'typold',
        ),
        home: HomeScreen(),
      ),
    );
  }
}
