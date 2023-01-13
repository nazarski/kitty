import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/database/database_repository.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/expense_category_model/expense_category.dart';
import 'package:kitty/models/expense_model/expense.dart';
import 'package:kitty/models/income_category_model/income_category.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'database_event.dart';

part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository databaseRepository;

  //fetch categories
  Future<void> _getIncomeCategories(Emitter emit) async {
    print('income cat');
    List<IncomeCategory> categories = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.query(databaseRepository.inCatTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
          final iconData = json.decode(e['icon']);
          return IncomeCategory(
              totalAmount: double.parse(e['totalAmount']),
              entries: e['entries'],
              title: e['title'],
              categoryId: e['categoryId'],
            icon: CategoryIcon.fromJson(iconData),
          );
        }).toList();
      });
    });
    emit(state.copyWith(inCategories: categories));
  }

  Future<void> _getExpenseCategories(Emitter emit) async {
    print('expense cat');
    List<ExpenseCategory> categories = [];
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.query(databaseRepository.exCatTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        categories = converted.map((e) {
          final iconData = json.decode(e['icon']);
          return ExpenseCategory(
              totalAmount: double.parse(e['totalAmount']),
              entries: e['entries'],
              title: e['title'],
              categoryId: e['categoryId'],
              icon: CategoryIcon.fromJson(iconData),);
        }).toList();
      });
    });
    emit(state.copyWith(expCategories: categories));
  }

  Future<void> _createExpenseCategory(String title, CategoryIcon icon, int categoryId) async {
    final category = ExpenseCategory(title: title, icon: icon, categoryId: categoryId);
    final db = await databaseRepository.database;
    await db.transaction((txn) async {
      await txn.insert(databaseRepository.exCatTable, {
        'title': category.title,
        'totalAmount': (category.totalAmount).toString(),
        'entries': category.entries,
        'icon': json.encode(category.icon)
      });
    });
  }

  DatabaseBloc(this.databaseRepository) : super(DatabaseState()) {
    IncomeCategory selectedIncomeCategory;
    ExpenseCategory selectedExpenseCategory;
    on<InitialDatabaseEvent>((event, emit) {
      emit(state.copyWith(categoryToAdd: '', icons: []));
    });
    on<CallAllDataEvent>((_, __) {
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
      // final icon = CategoryIcon(
      //     pathToIcon: event.icon['icon']!, color: event.icon['color']!);
      // emit(state.copyWith(icons: [icon]));
    });
    on<CreateExpenseCategoryEvent>((event, emit) async {
      await _createExpenseCategory(event.categoryName, state.icons.first, 0);
      add(InitialDatabaseEvent());
      add(CallExpenseCategoriesEvent());
    });
  }
}
