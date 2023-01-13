import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/database/database_repository.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/expense_category_model/expense_category.dart';
import 'package:kitty/models/expense_model/expense.dart';
import 'package:kitty/models/income_category_model/income_category.dart';

part 'database_event.dart';

part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository databaseRepository;

  //fetch categories
  Future<void> _getIncomeCategories(Emitter emit) async {
    List<IncomeCategory> categories = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.query(databaseRepository.inCatTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
          return IncomeCategory(
            categoryId: e['categoryId'],
            title: e['title'],
            totalAmount: double.parse(e['totalAmount']),
            entries: e['entries'],
            icon: state.icons.firstWhere((icon) => icon.iconId == e['iconId']),
          );
        }).toList();
      });
    });
    emit(state.copyWith(inCategories: categories));
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

  Future<void> _getExpenseCategories(Emitter emit) async {
    List<ExpenseCategory> categories = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.query(databaseRepository.exCatTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
          return ExpenseCategory(
            categoryId: e['categoryId'],
            title: e['title'],
            totalAmount: double.parse(e['totalAmount']),
            entries: e['entries'],
            icon: state.icons.firstWhere((icon) => icon.iconId == e['iconId']),
          );
        }).toList();
      });
    });
    emit(state.copyWith(expCategories: categories));
  }

  Future<void> _createExpenseCategory({
    required String title,
    required int iconId,
  }) async {
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.insert(databaseRepository.exCatTable, {
        'title': title,
        'totalAmount': (0.0).toString(),
        'entries': 0,
        'iconId': iconId,
      });
    });
  }

  DatabaseBloc(this.databaseRepository) : super(const DatabaseState()) {
    IncomeCategory selectedIncomeCategory;
    ExpenseCategory selectedExpenseCategory;
    on<InitialDatabaseEvent>((event, emit) {
      emit(state.copyWith(categoryToAdd: '', selectedIcon: null));
    });
    on<CallAllDataEvent>((_, emit) async {
      await _getAllIcons(emit);
      add(CallIncomeCategoriesEvent());
      add(CallExpenseCategoriesEvent());
    });
    on<CallIncomeCategoriesEvent>((_, emit) async {
      await _getIncomeCategories(emit);
    });
    on<CallExpenseCategoriesEvent>((_, emit) async {
      await _getExpenseCategories(emit);
    });
    on<GetIncomeCategoryEvent>((event, emit) {
      selectedIncomeCategory = event.category;
      emit(state.copyWith(categoryToAdd: selectedIncomeCategory.title));
    });
    on<GetExpenseCategoryEvent>((event, emit) {
      selectedExpenseCategory = event.category;
      emit(state.copyWith(categoryToAdd: selectedExpenseCategory.title));
    });
    on<GetIconEvent>((event, emit) {
      emit(state.copyWith(selectedIcon: event.icon));
    });
    on<CreateExpenseCategoryEvent>((event, emit) async {
      await _createExpenseCategory(
          title: event.categoryName, iconId: state.selectedIcon!.iconId);
      add(InitialDatabaseEvent());
      add(CallExpenseCategoriesEvent());
    });
  }
}
