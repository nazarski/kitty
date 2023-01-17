import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/database/database_repository.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/utils/helper.dart';

part 'database_event.dart';

part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository databaseRepository;

  //fetch categories
  Future<void> _getEntryCategories(Emitter emit) async {
    List<EntryCategory> categories = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.query(databaseRepository.entryCatTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
          return EntryCategory(
            categoryId: e['categoryId'],
            title: e['title'],
            totalAmount: double.parse(e['totalAmount']),
            entries: e['entries'],
            type: e['type'],
            icon: state.icons.firstWhere((icon) => icon.iconId == e['iconId']),
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
        'dateTime': DateFormat('dd-MMM-yyyy').format(DateTime.now()),
        'categoryId': categoryId,
      });
    });
  }

  Future<void> _getAllEntries(Emitter emit) async {
    emit(state.copyWith(status: DatabaseStatus.loading));
    List<Entry> entries = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      entries = await txn.query(databaseRepository.entryTable,
          orderBy: 'expenseId DESC',
          where: 'dateTime NOT LIKE ?',
          whereArgs: ['___Feb-2023']).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        return converted.map((e) {
          return Entry(
              expenseId: e['expenseId'],
              description: e['description'],
              amount: e['amount'],
              dateTime: e['dateTime'],
              categoryId: e['categoryId']);
        }).toList();
      });
    });
    emit(state.copyWith(
        status: DatabaseStatus.loaded, entries: groupEntries(list: entries)));
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
      print(event.description);
      await _createEntry(
          categoryId: state.categoryToAdd!.categoryId,
          amount: event.amount,
          description: event.description);
      await _getAllEntries(emit);
    });

  }
}
