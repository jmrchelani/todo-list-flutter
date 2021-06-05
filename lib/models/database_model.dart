import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/task_model.dart';

import 'category_model.dart';

class SQLDatabase {
  static final SQLDatabase instance = SQLDatabase._init();

  static Database _database;

  SQLDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('mydb.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE categories(name TEXT, icon INTEGER, color INTEGER)',
    );
    await db.execute(
      'CREATE TABLE tasks(name TEXT, deadline TEXT, category INTEGER, isDone INTEGER)',
    );
  }

  Future<Category> createCategory(Category cat) async {
    final db = await instance.database;

    await db.insert('categories', cat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return cat;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await instance.database;

    List<Category> categories = [];

    final cats = await db.query('categories');

    for (Map<String, dynamic> cat in cats) {
      categories.add(Category.fromMap(cat));
    }

    return categories;
  }

  Future<int> updateCategory(Category cat) async {
    final db = await instance.database;

    return db.update(
      'categories',
      cat.toMap(),
      where: 'name = ?',
      whereArgs: [cat.name],
    );
  }

  Future<int> deleteCategory(Category cat) async {
    final db = await instance.database;

    return await db.delete(
      'categories',
      where: 'name = ?',
      whereArgs: [cat.name],
    );
  }

  Future<Task> createTask(Task task) async {
    final db = await instance.database;

    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return task;
  }

  Future<List<Task>> getAllTasks(BuildContext context) async {
    final db = await instance.database;

    List<Task> tasks = [];

    final tasksResult = await db.query('tasks');

    if (tasksResult.isNotEmpty) {
      for (Map<String, dynamic> tk in tasksResult) {
        tasks.add(Task.fromMap(context, tk));
      }
    }

    return tasks;
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return db.update(
      'tasks',
      task.toMap(),
      where: 'name = ?',
      whereArgs: [task.name],
    );
  }

  Future<int> deleteTask(Task task) async {
    final db = await instance.database;

    return await db.delete(
      'tasks',
      where: 'name = ?',
      whereArgs: [task.name],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
