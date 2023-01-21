import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/models/balance_model/balance.dart';
import 'package:kitty/models/category_icon_model/category_icon.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/models/entry_date_model/entry_date.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';
import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/utils/helper.dart';

part 'entries_control_event.dart';

part 'entries_control_state.dart';

class EntriesControlBloc extends Bloc<EntriesControlEvent, EntriesControl> {
  DatabaseRepository databaseRepository;

  //fetch categories

  Future<void> _getCategories(Emitter emit) async {
    final categories = await databaseRepository.getEntryCategories();
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

  Future<void> _getAllData(Emitter emit) async {
    emit(state.copyWith(icons: await databaseRepository.getAllIcons()));
    add(CallEntryCategoriesEvent());
    add(SetDateToEntriesEvent(
        type: 'range', year: DateTime
        .now()
        .year, month: DateTime
        .now()
        .month));
  }

  Future<void> getRangeData(emit, int year, int month) async {
    final entries = await databaseRepository.getEntriesRange(year, month);
    final balance = await databaseRepository.getBalanceInRange(year, month);
    emit(state.copyWith(
      entries: groupEntries(list: entries),
      balance: balance,
    ));
  }

  Future<void> getStatistics(Emitter emit, int year, int month) async {
    final statistics = await databaseRepository.getMonthlyStatistics(
        year, month);
    emit(state.copyWith(statistics: statistics));
  }

  Future<void> selectType(String type,
      int year,
      int month,
      Emitter emit,) async {
    switch (type) {
      case 'range':
        await getRangeData(emit, year, month);
        break;
      case 'exact':
        await getStatistics(emit, year, month);
        break;
    }
  }

  EntriesControlBloc(this.databaseRepository) : super(const EntriesControl()) {
    on<InitialDatabaseEvent>((event, emit) {
      emit(state.copyWith(
          categoryToAdd: null,
          selectedIcon: null,
          status: DatabaseStatus.initial));
    });
    on<CallAllDataEvent>((_, emit) async => _getAllData(emit));
    on<CallEntryCategoriesEvent>((_, emit) async => _getCategories(emit));
    on<GetCategoryEvent>((event, emit) {
      emit(state.copyWith(categoryToAdd: event.category));
    });
    on<GetIconEvent>((event, emit) {
      emit(state.copyWith(selectedIcon: event.icon));
    });
    on<CreateExpenseCategoryEvent>((event, _) async {
      await databaseRepository.createExpenseCategory(
          title: event.categoryName, iconId: state.selectedIcon!.iconId);
      add(InitialDatabaseEvent());
      add(CallEntryCategoriesEvent());
    });
    on<CreateEntryEvent>((event, emit) async {
      await databaseRepository.createEntry(
          categoryId: state.categoryToAdd!.categoryId,
          amount: event.amount,
          description: event.description);
      add(SetDateToEntriesEvent(
          type: 'range',
          year: DateTime
              .now()
              .year,
          month: DateTime
              .now()
              .month));
    });
    on<SetDateToEntriesEvent>((event, emit) async {
      await selectType(event.type, event.year, event.month, emit);
    });
  }

}
