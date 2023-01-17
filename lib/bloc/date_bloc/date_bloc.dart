import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/utils/helper.dart';

part 'date_event.dart';

part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  Map<String, Set<int>> years = {};
  List<int>? allYears;

  DateBloc() : super(DateState(DateTime.now().year)) {
    getRange(List<Entry> entries, Emitter emit) {
      for (Entry element in entries) {
        if (years.containsKey('${element.dateTime.year}')) {
          years['${element.dateTime.year}']!.add(element.dateTime.month);
        } else {
          years.addAll({
            '${element.dateTime.year}': {element.dateTime.month}
          });
        }
      }
      allYears = years.keys.map((e) => int.parse(e)).toList();
      emit(
        state.copyWith(
            allYears: allYears,
            year: allYears!.first,
            activeMonths: years['${allYears!.first}']),
      );
    }

    void _changeYear(Emitter emit, String direction) {
      switch (direction) {
        case 'forward':
          emit(state.copyWith(
              year: state.year + 1, activeMonths: years['${state.year + 1}']));
          break;
        case 'back':
          emit(state.copyWith(
              year: state.year - 1, activeMonths: years['${state.year - 1}']));
          break;
      }
    }

    on<InitialDateEvent>((event, emit) {
      getRange(event.entries, emit);
      add(
        SetDateEvent(
          month: years['${allYears!.first}']!.first,
          year: allYears!.first,
        ),
      );
    });
    on<SetDateEvent>((event, emit) {
      emit(
          state.copyWith(selectedMonth: event.month, selectedYear: event.year));
    });
    on<CallYearDateEvent>((event, emit) => _changeYear(emit, event.operation));
    on<CallMonthDateEvent>((event, emit) {
      switch (event.operation) {
        case 'back':
          if (state.activeMonths.last == state.selectedMonth) {
            _changeYear(emit, event.operation);
            emit(state.copyWith(
              selectedYear: state.year,
                selectedMonth: state.activeMonths.first));
          } else {
            emit(state.copyWith(
                selectedYear: state.year,
                selectedMonth: findElement(state.activeMonths,
                state.selectedMonth, 1)));
          }
          break;
        case 'forward':
          if (state.activeMonths.first == state.selectedMonth) {
            _changeYear(emit, event.operation);
            emit(state.copyWith(
                selectedYear: state.year,
                selectedMonth: state.activeMonths.last));
          } else {
            emit(state.copyWith(
                selectedYear: state.year,
                selectedMonth: findElement(state.activeMonths,
                state.selectedMonth, -1)));

          }
          break;
      }
    });

  }
}
