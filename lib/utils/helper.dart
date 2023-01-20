import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitty/models/entry_model/entry.dart';

Color fromHex(String str) {
  return Color(int.parse('FF$str', radix: 16));
}

String checkDate(DateTime date) {
  final int day = date.day - DateTime.now().day;
  switch (day) {
    case 0:
      return 'TODAY';
    case -1:
      return 'YESTERDAY';
    default:
      return DateFormat('dd-MMM-yyyy').format(date);
  }
}

Map<String, List<Entry>> groupEntries({required List<Entry> list}) {
  return list.groupListsBy((element) => checkDate(element.dateTime));
}

String getSum(List<Entry> list) {
  final sum =
      list.fold(0, (previousValue, element) => previousValue + element.amount);
  return '$sum';
}

DateTime parseDate(String date) {
  return DateFormat('yyyy-mm-dd').parse(date);
}

String dateToString(DateTime date) {
  return DateFormat('dd-MMM-yyyy').format(date);
}

int findElement(Set<int> months, int current, int onFound) {
  if (months.length > 1) {
    final list = months.toList();
    for (int i = 0; i < list.length; i++) {
      if (list[i] == current) {
        return list[i + onFound];
      }
    }
  }
  return 0;
}

