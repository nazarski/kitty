import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/resources/initial_values.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
class DatabaseRepository {
  Database? _database;

  Future<Database> get database async {
    final Future<String> dbPath = getDatabasesPath();
    const dbName = 'expense_tc.db';
    final String path = '$dbPath/$dbName';
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }
// name all tables
  final String exCatTable = 'expensesCategoriesTable';
  final String inCatTable = 'incomeCategoriesTable';
  final String exTable = 'expensesTable';
  final String inTable = 'incomeTable';
// set tables and fill with initial values once when db created
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      // expenses categories table
      await txn.execute('''
      CREATE TABLE $exCatTable (
      title TEXT,
      totalAmount TEXT,
      entries INTEGER,
      icon TEXT)
      ''');
      // income categories table
      await txn.execute('''
      CREATE TABLE $inCatTable (
      title TEXT,
      totalAmount TEXT,
      entries INTEGER,
      icon TEXT)
      ''');
      // expenses table
      await txn.execute('''
      CREATE TABLE $exTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime TEXT,
      category TEXT)
      ''');
      // income table
      await txn.execute('''
      CREATE TABLE $inTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime TEXT,
      category TEXT)
      ''');

      // initial values

      // income categories
      final List<Map<String, String>> incomeIcons =
          InitialValues.incomeIcons.values.toList();
      for (int i = 0; i < InitialValues.incomeCategories.length; i++) {
        await txn.insert(inCatTable, {
          'title': InitialValues.incomeCategories[i],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'icon': json.encode(CategoryIcon(
                  pathToIcon: incomeIcons[i]['icon']!,
                  color: incomeIcons[i]['color']!))
        });
      }
      // expense categories
      final List<Map<String, String>> expenseIcons =
      InitialValues.expenseIcons.values.toList();
      for (int i = 0; i < 3; i++) {
        await txn.insert(exCatTable, {
          'title': InitialValues.expenseCategories[i],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'icon': json.encode(CategoryIcon(
              pathToIcon: expenseIcons[i]['icon']!,
              color: expenseIcons[i]['color']!))
        });
      }
    });
  }
  //fetch income categories
}
