part of 'date_bloc.dart';

class DateEvent {}

class InitialDateEvent extends DateEvent {}

class SetDateEvent extends DateEvent {
  final int month;
  final int year;

  SetDateEvent({required this.month, required this.year});
}

class CallYearDateEvent extends DateEvent {
  final String operation;

  CallYearDateEvent(this.operation);
}
class CallMonthDateEvent extends DateEvent{
  final String operation;

  CallMonthDateEvent(this.operation);
}

class ToSelectedDateEvent extends DateEvent{}