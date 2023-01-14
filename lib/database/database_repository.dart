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
  final String entryCatTable = 'entryCategoryTable';
  final String entryTable = 'entryTable';
  final String icTable = 'iconsTable';

// set tables and fill with initial values once when db created
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      // entry categories table
      await txn.execute('''
      CREATE TABLE $entryCatTable (
      categoryId INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      totalAmount TEXT,
      entries INTEGER,
      type TEXT,
      iconId INTEGER NOT NULL,
      FOREIGN KEY (iconId) REFERENCES $icTable (iconId)
      )
      ''');

      // entries table
      await txn.execute('''
      CREATE TABLE $entryTable (
      expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime TEXT,
      categoryId INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES $entryCatTable (categoryId)
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
      // expense categories
      for (int i = 0; i < InitialValues.incomeCategories.length; i++) {
        await txn.insert(entryCatTable, {
          'title': InitialValues.incomeCategories[i],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'type': 'income',
          'iconId': i,
        });
      }
      // expense categories
        for (int i = 6; i < 9; i++) {
          await txn.insert(entryCatTable, {
            'title': InitialValues.expenseCategories[i-6],
            'totalAmount': (0.0).toString(),
            'entries': 0,
            'type': 'expense',
            'iconId': i
          });
        }
    });
  }
}

