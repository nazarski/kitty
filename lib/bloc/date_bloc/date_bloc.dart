import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/models/entry_date_model/entry_date.dart';
import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/utils/helper.dart';

part 'date_event.dart';

part 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  final DatabaseRepository databaseRepository;
  Map<String, Set<int>> years = {};
  List<int>? allYears;

  void monthChange(String operation, Emitter emit) {
    switch (operation) {
      case 'back':
        if (state.activeMonths.last == state.selectedMonth) {
          _changeYear(emit, operation);
          emit(state.copyWith(
              selectedYear: state.year,
              selectedMonth: state.activeMonths.first));
        } else {
          emit(state.copyWith(
              selectedYear: state.year,
              selectedMonth:
                  findElement(state.activeMonths, state.selectedMonth, 1)));
        }
        break;
      case 'forward':
        if (state.activeMonths.first == state.selectedMonth) {
          _changeYear(emit, operation);
          emit(state.copyWith(
              selectedYear: state.year,
              selectedMonth: state.activeMonths.last));
        } else {
          emit(state.copyWith(
              selectedYear: state.year,
              selectedMonth:
                  findElement(state.activeMonths, state.selectedMonth, -1)));
        }
        break;
    }
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

  void getRange(List<EntryDate> entries, Emitter emit) {
    for (EntryDate element in entries) {
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

  DateBloc(this.databaseRepository) : super(DateState(DateTime.now().year)) {
    on<InitialDateEvent>((_, emit) async {
      final entriesDates = await databaseRepository.getAllEntriesDates();
      if(entriesDates.isNotEmpty) {
        getRange(entriesDates, emit);
        add(
          SetDateEvent(
            month: years['${allYears!.first}']!.first,
            year: allYears!.first,
          ),
        );
      }
    });
    on<ToSelectedDateEvent>((event, emit) {
      emit(state.copyWith(
          year: state.selectedYear,
          activeMonths: years['${state.selectedYear}']));
    });
    on<SetDateEvent>((event, emit) {
      emit(
          state.copyWith(selectedMonth: event.month, selectedYear: event.year));
    });
    on<CallYearDateEvent>((event, emit) => _changeYear(emit, event.operation));
    on<CallMonthDateEvent>((event, emit) => monthChange(event.operation, emit));
  }
}
