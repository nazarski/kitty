
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/resources/initial_values.dart';
import 'package:sqflite/sqflite.dart';

class ExpensesDatabaseProvider {
  final String userId;
  static Database? _database;

  ExpensesDatabaseProvider(this.userId);

  Future<Database> get database async {
    final userDb = userId.substring(0, userId.indexOf('@'));
    final Future<String> dbPath = getDatabasesPath();
    final dbName = '${userDb}_expense.db';
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
  final String searches = 'searchValues';

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
      orderNum INTEGER,
      FOREIGN KEY (iconId) REFERENCES $icTable (iconId)
      )
      ''');

      // entries table
      await txn.execute('''
      CREATE TABLE $entryTable (
      expenseId INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT,
      amount INTEGER,
      dateTime INTEGER NOT NULL,
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

      //recent search values table
      await txn.execute('''
      CREATE TABLE $searches (
      value TEXT,
      timeStamp INTEGER)
      ''');

      await txn.execute('''
      CREATE TRIGGER auto_increment_trigger AFTER INSERT ON $entryCatTable 
      WHEN new.orderNum IS NULL BEGIN UPDATE $entryCatTable SET orderNum = 
      (SELECT IFNULL(MAX(orderNum), 0) + 1 FROM $entryCatTable) WHERE 
      categoryId = new.categoryId; END;
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
                    iconId: i+1,
                    localPath: allIcons[i]['icon']!,
                    color: allIcons[i]['color']!)
                .toJson());
      }

      // income categories
      for (int i = 0; i < InitialValues.incomeCategories.length; i++) {
        await txn.insert(entryCatTable, {
          'title': InitialValues.incomeCategories[i],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'type': 'income',
          'iconId': i+1,
        });
      }

      // expense categories
      for (int i = 6; i < 9; i++) {
        await txn.insert(entryCatTable, {
          'title': InitialValues.expenseCategories[i - 6],
          'totalAmount': (0.0).toString(),
          'entries': 0,
          'type': 'expense',
          'iconId': i+1
        });
      }
    });
  }
}
