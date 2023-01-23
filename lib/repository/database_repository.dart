import 'package:kitty/database/expenses_database.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/models/entry_date_model/entry_date.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';

class DatabaseRepository {
  final ExpensesDatabaseProvider databaseProvider;

  DatabaseRepository(this.databaseProvider);

  Future<List<EntryCategory>> getEntryCategories() async {
    final catName = databaseProvider.entryCatTable;
    final iconName = databaseProvider.icTable;
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
      SELECT  $catName.categoryId, $catName.title, 
      $catName.totalAmount,$catName.entries, $catName.type, $iconName.iconId, 
      $iconName.localPath,$iconName.color
      FROM $catName
      INNER JOIN $iconName
      ON $catName.iconId = $iconName.iconId
      ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return EntryCategory(
            categoryId: e['categoryId'],
            title: e['title'],
            totalAmount: double.parse(e['totalAmount']),
            entries: e['entries'],
            type: e['type'],
            icon: CategoryIcon(
                iconId: e['iconId'],
                localPath: e['localPath'],
                color: e['color']),
          );
        }).toList();
      });
    });
  }

  Future<List<CategoryIcon>> getAllIcons() async {
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      return await txn.query(databaseProvider.icTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) => CategoryIcon.fromJson(e)).toList();
      });
    });
  }

  Future<List<EntryDate>> getAllEntriesDates() async {
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      return await txn
          .query(
        databaseProvider.entryTable,
        columns: ['expenseId', 'dateTime'],
        orderBy: 'expenseId DESC',
      )
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return EntryDate(
              expenseId: e['expenseId'],
              dateTime: DateTime.fromMillisecondsSinceEpoch(e['dateTime']));
        }).toList();
      });
    });
  }

  Future<void> createExpenseCategory({
    required String title,
    required int iconId,
  }) async {
    final db = await databaseProvider.database;
    await db.transaction((txn) async {
      await txn.insert(databaseProvider.entryCatTable, {
        'title': title,
        'totalAmount': (0.0).toString(),
        'entries': 0,
        'type': 'expense',
        'iconId': iconId,
      });
    });
  }

  Future<void> createEntry({
    required int categoryId,
    required String amount,
    required String description,
  }) async {
    final db = await databaseProvider.database;
    await db.transaction((txn) async {
      await txn.insert(databaseProvider.entryTable, {
        'description': description,
        'amount': int.parse(amount),
        'dateTime': DateTime.now().millisecondsSinceEpoch,
        'categoryId': categoryId,
      });
    });
  }

  Future<List<EntryCategory>> getUsedCategories() async {
    final db = await databaseProvider.database;
    final icons = databaseProvider.icTable;
    final categoriesTable = databaseProvider.entryCatTable;
    final entryTable = databaseProvider.entryTable;
    return await db.transaction((txn) async {
      return await txn.rawQuery('''
         SELECT  COUNT(*) totalCount, $entryTable.categoryId, 
         $categoriesTable.title, $categoriesTable.type, $icons.iconId, 
         $icons.localPath, $icons.color
         FROM $entryTable 
         INNER JOIN $categoriesTable 
         ON $categoriesTable.categoryId = $entryTable.categoryId 
         JOIN iconsTable 
         ON $categoriesTable.iconId = $icons.iconId 
         GROUP BY entryCategoryTable.categoryId, entryCategoryTable.title
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return EntryCategory(
              categoryId: e['categoryId'],
              title: e['title'],
              type: e['type'],
              icon: CategoryIcon(
                  iconId: e['iconId'],
                  localPath: e['localPath'],
                  color: e['color']));
        }).toList();
      });
    });
  }

  Future<Balance> getBalanceInRange(int year, int month) async {
    final int endRange = DateTime(year, month + 1).millisecondsSinceEpoch;
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      final income = await txn.rawQuery('''
          SELECT SUM(amount) AS income FROM ${databaseProvider.entryTable} 
          WHERE dateTime < $endRange AND amount > 0
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.first['income'] ?? 0;
      });
      final expense = await txn.rawQuery('''
          SELECT SUM(amount) AS expense FROM ${databaseProvider.entryTable} 
          WHERE dateTime < $endRange AND amount < 0
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.first['expense'] ?? 0;
      });
      return Balance(
          income: income, expenses: expense, balance: income + expense);
    });
  }

  Future<List<Entry>> getEntriesRange(int year, int month) async {
    final int endRange = DateTime(year, month + 1).millisecondsSinceEpoch;
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      return await txn
          .rawQuery('SELECT * FROM ${databaseProvider.entryTable} WHERE '
              'dateTime < $endRange ORDER BY expenseId DESC')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return Entry(
              expenseId: e['expenseId'],
              description: e['description'],
              amount: e['amount'],
              dateTime: DateTime.fromMillisecondsSinceEpoch(e['dateTime']),
              categoryId: e['categoryId']);
        }).toList();
      });
    });
  }

  Future<List<StatisticsElement>> getMonthlyStatistics(
      int year, int month) async {
    final int start = DateTime(year, month)
        .subtract(const Duration(days: 1))
        .millisecondsSinceEpoch;
    final int finish = DateTime(year, month + 1).millisecondsSinceEpoch;
    final icons = databaseProvider.icTable;
    final categories = databaseProvider.entryCatTable;
    final entryTable = databaseProvider.entryTable;
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      final int monthlyAmount = await txn.rawQuery('''
      SELECT SUM(amount) AS sum FROM $entryTable 
      WHERE amount < 0 
      AND datetime BETWEEN $start AND $finish
      ''').then((data) {
        return data.first['sum'] as int;
      });
      return await txn.rawQuery('''
         SELECT  COUNT(*) totalCount, $entryTable.categoryId, 
         $categories.title, SUM($entryTable.amount) As sumOfEntries, 
         $entryTable.dateTime, $icons.iconId, $icons.localPath, $icons.color 
         FROM $entryTable 
         INNER JOIN $categories 
         ON $categories.categoryId = $entryTable.categoryId 
         JOIN iconsTable 
         ON $categories.iconId = $icons.iconId 
         WHERE $categories.type = "expense" 
         AND $entryTable.dateTime BETWEEN $start AND $finish 
         GROUP BY entryCategoryTable.categoryId, entryCategoryTable.title
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return StatisticsElement(
            categoryTitle: e['title'],
            countOfEntries: e['totalCount'],
            totalAmount: e['sumOfEntries'],
            monthShare: e['sumOfEntries'] / monthlyAmount * 100,
            icon: CategoryIcon(
                iconId: e['iconId'],
                localPath: e['localPath'],
                color: e['color']),
          );
        }).toList();
      });
    });
  }

  Future<List<Entry>> getSearchedEntries(
      List<int> ids, String searchValue) async {
    final db = await databaseProvider.database;
    final categories =
        ' AND categoryId IN (${('?' * (ids.length)).split('').join(', ')})';
    return await db.transaction((txn) async {
      return await txn
          .query(databaseProvider.entryTable,
              where: 'description LIKE ?${ids.isNotEmpty ? categories : ''}',
              whereArgs: ['$searchValue%', ...ids],
              orderBy: 'expenseId DESC')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return Entry(
              expenseId: e['expenseId'],
              description: e['description'],
              amount: e['amount'],
              dateTime: DateTime.fromMillisecondsSinceEpoch(e['dateTime']),
              categoryId: e['categoryId']);
        }).toList();
      });
    });
  }

  Future<void> saveSearchValue(String value) async {
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      final int count = await txn
          .rawQuery(
              'SELECT COUNT(timeStamp) AS count FROM ${databaseProvider.searches}')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.first['count'] ?? 0;
      });
      if (count >= 5) {
        await txn.rawQuery('DELETE FROM ${databaseProvider.searches} WHERE '
            'timeStamp = (SELECT MIN(timeStamp) FROM ${databaseProvider.searches})');
      }
      await txn.insert(databaseProvider.searches,
          {'value': value, 'timeStamp': DateTime.now().millisecondsSinceEpoch});
    });
  }

  Future<List<String>> getRecentSearchValues() async {
    final db = await databaseProvider.database;
    return await db.transaction((txn) async {
      return await txn
          .rawQuery('SELECT * FROM ${databaseProvider.searches} '
              'ORDER BY timeStamp DESC')
          .then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) => e['value'] as String).toList();
      });
    });
  }

  Future<void> deleteEntry(int id) async {
    final db = await databaseProvider.database;
    await db.transaction((txn) async {
      await txn.delete(databaseProvider.entryTable,
          where: 'expenseId = ?', whereArgs: [id]);
    });
  }
}
