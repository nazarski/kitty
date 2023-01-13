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
  final String icTable = 'iconsTable';

// set tables and fill with initial values once when db created
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      // expenses categories table
      await txn.execute('''
      CREATE TABLE $exCatTable (
      categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      totalAmount TEXT,
      entries INTEGER,
      iconId INTEGER NOT NULL,
      FOREIGN KEY (iconId) REFERENCES $icTable (iconId)
      )
      ''');
      // income categories table
      await txn.execute('''
      CREATE TABLE $inCatTable (
      categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      totalAmount TEXT,
      entries INTEGER,
      iconId INTEGER NOT NULL,
      FOREIGN KEY (iconId) REFERENCES $icTable (iconId)
      )
      ''');
      // expenses table
      await txn.execute('''
      CREATE TABLE $exTable (
      expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime TEXT,
      categoryId INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES $exCatTable (categoryId)
      )
      ''');
      // income table
      await txn.execute('''
      CREATE TABLE $inTable (
      incomeId INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime TEXT,
      categoryId INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES $exCatTable (categoryId)
      )
      ''');
      //icons table
      await txn.execute('''
      CREATE TABLE $icTable (
      iconId INTEGER PRIMARY KEY,
      localPath TEXT,
      color Text)
      ''');

      // initial values

      // icons
      final List<Map<String, String>> allIcons = [
        ...InitialValues.incomeIcons.values.toList(),
        ...InitialValues.expenseIcons.values.toList(),
      ];
      for (int i = 0; i < allIcons.length; i++) {
        await txn.insert(
            icTable,
            CategoryIcon(
                    iconId: i,
                    localPath: allIcons[i]['icon']!,
                    color: allIcons[i]['color']!)
                .toJson());
      }
      // income categories
      for (int i = 0; i < InitialValues.incomeCategories.length; i++) {
        await txn.insert(inCatTable, {
          'title': InitialValues.incomeCategories[i],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'iconId': i,
        });
      }
      // expense categories
        for (int i = 6; i < 9; i++) {
          await txn.insert(exCatTable, {
            'title': InitialValues.expenseCategories[i-6],
            'totalAmount': (0.0).toString(),
            'entries': 0,
            'iconId': i
          });
        }
    });
  }
}

