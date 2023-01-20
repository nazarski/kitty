import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/database/database_repository.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/models/entry_date_model/entry_date.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';
import 'package:kitty/utils/helper.dart';

part 'database_event.dart';

part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository databaseRepository;

  //fetch categories
  Future<void> _getEntryCategories(Emitter emit) async {
    List<EntryCategory> categories = [];
    final catName = databaseRepository.entryCatTable;
    final iconName = databaseRepository.icTable;
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.rawQuery('''
      SELECT  $catName.categoryId, $catName.title, 
      $catName.totalAmount,$catName.entries, $catName.type, $iconName.iconId, 
      $iconName.localPath,$iconName.color
      FROM $catName
      INNER JOIN $iconName
      ON $catName.iconId = $iconName.iconId
      ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
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
    emit(state.copyWith(
        expCategories: categories
            .where(
              (element) => element.type == 'expense',
            )
            .toList(),
        inCategories: categories
            .where(
              (element) => element.type == 'income',
            )
            .toList()));
  }

  Future<void> _getAllIcons(Emitter emit) async {
    List<CategoryIcon> icons = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      icons = await txn.query(databaseRepository.icTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) => CategoryIcon.fromJson(e)).toList();
      });
    });
    emit(state.copyWith(icons: icons));
  }

  Future<void> _createExpenseCategory({
    required String title,
    required int iconId,
  }) async {
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.insert(databaseRepository.entryCatTable, {
        'title': title,
        'totalAmount': (0.0).toString(),
        'entries': 0,
        'type': 'expense',
        'iconId': iconId,
      });
    });
  }

  Future<void> _createEntry({
    required int categoryId,
    required String amount,
    required String description,
  }) async {
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.insert(databaseRepository.entryTable, {
        'description': description,
        'amount': int.parse(amount),
        'dateTime': DateTime.now().millisecondsSinceEpoch,
        'categoryId': categoryId,
      });
    });
  }

  Future<void> _getAllEntries(Emitter emit) async {
    emit(state.copyWith(status: DatabaseStatus.loading));
    List<EntryDate> entries = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      entries = await txn
          .query(
        databaseRepository.entryTable,
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
    emit(state.copyWith(
      entriesDates: entries,
      status: DatabaseStatus.loaded,
      // entries: groupEntries(list: entries)
    ));
  }

  Future<void> _getAllData(Emitter emit) async {
    await _getAllIcons(emit);
    await _getEntryCategories(emit);
    await _getAllEntries(emit);
  }

  DatabaseBloc(this.databaseRepository) : super(const DatabaseState()) {
    on<InitialDatabaseEvent>((event, emit) {
      emit(state.copyWith(
          categoryToAdd: null,
          selectedIcon: null,
          status: DatabaseStatus.initial));
    });
    on<CallAllDataEvent>((_, emit) async => await _getAllData(emit));
    on<CallEntryCategoriesEvent>(
        (_, emit) async => await _getEntryCategories(emit));
    on<GetCategoryEvent>((event, emit) {
      emit(state.copyWith(categoryToAdd: event.category));
    });
    on<GetIconEvent>((event, emit) {
      emit(state.copyWith(selectedIcon: event.icon));
    });
    on<CreateExpenseCategoryEvent>((event, _) async {
      await _createExpenseCategory(
          title: event.categoryName, iconId: state.selectedIcon!.iconId);
      add(InitialDatabaseEvent());
      add(CallEntryCategoriesEvent());
    });
    on<CreateEntryEvent>((event, emit) async {
      await _createEntry(
          categoryId: state.categoryToAdd!.categoryId,
          amount: event.amount,
          description: event.description);
      await _getAllEntries(emit);
    });
    on<SetDateToEntriesEvent>((event, emit) async {
      await selectType(event.type, event.year, event.month, emit);
    });
  }

  Future<void> getEntriesRange(Emitter emit, int year, int month) async {
    final int endRange = DateTime(year, month + 1).millisecondsSinceEpoch;
    List<Entry> entries = [];
    int income = 0;
    int expense = 0;
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      entries = await txn
          .rawQuery('SELECT * FROM ${databaseRepository.entryTable} WHERE '
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
      await txn.rawQuery('''
          SELECT SUM(amount) AS income FROM ${databaseRepository.entryTable} 
          WHERE dateTime < $endRange AND amount > 0
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        income = converted.first['income'] ?? 0;
      });
      await txn.rawQuery('''
          SELECT SUM(amount) AS expense FROM ${databaseRepository.entryTable} 
          WHERE dateTime < $endRange AND amount < 0
          ''').then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        expense = converted.first['expense'] ?? 0;
      });
    });
    emit(
      state.copyWith(
        balance: Balance(
            income: income, expenses: expense, balance: income + expense),
        status: DatabaseStatus.loaded,
        entries: groupEntries(list: entries),
      ),
    );
  }

  Future<void> getExactEntries(Emitter emit, int year, int month) async {
    emit(state.copyWith(status: DatabaseStatus.loading));
    final int start = DateTime(year, month).subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    final int finish = DateTime(year, month + 1).millisecondsSinceEpoch;
    int monthlyAmount = 0;
    final icons = databaseRepository.icTable;
    final categories = databaseRepository.entryCatTable;
    final entryTable = databaseRepository.entryTable;
    List<StatisticsElement> statistics = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      monthlyAmount = await txn.rawQuery('''
      SELECT SUM(amount) AS sum FROM $entryTable 
      WHERE amount < 0 
      AND datetime BETWEEN $start AND $finish
      ''').then((data) {
        return data.first['sum'] as int;
      });
      statistics = await txn.rawQuery('''
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
    emit(state.copyWith(statistics: statistics));
  }

  Future<void> selectType(
    String type,
    int year,
    int month,
    Emitter emit,
  ) async {
    switch (type) {
      case 'range':
        await getEntriesRange(emit, year, month);
        break;
      case 'exact':
        await getExactEntries(emit, year, month);
        break;
    }
  }
}
