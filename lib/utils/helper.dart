import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitty/models/entry_model/entry.dart';

Color fromHex(String str) {
  return Color(int.parse('FF$str', radix: 16));
}

String transformDate(String date) {
  final int day = parseDate(date).difference(DateTime.now()).inDays;
  switch (day) {
    case 0:
      return 'TODAY';
    case -1:
      return 'YESTERDAY';
    default:
      return date;
  }
}

Map<String, List<Entry>> groupEntries({required List<Entry> list}) {
  return list.groupListsBy((element) => dateToString(element.dateTime));
}

String getSum(List<Entry> list) {
  final sum =
      list.fold(0, (previousValue, element) => previousValue + element.amount);
  return '-$sum';
}

DateTime parseDate(String date) {
  return DateFormat('dd-MMM-yyyy').parse(date);
}

String dateToString(DateTime date) {
  return DateFormat('dd-MMM-yyyy').format(date);
}

int findElement(Set<int> months, int current, int onFound) {
  final list = months.toList();
  for (int i = 0; i < list.length; i++) {
    if (list[i] == current) {
      return list[i + onFound];
    }
  }
  return 0;
}
// final DateTime startingDate = DateTime(2020, 5);
// final DateTime endDate = DateTime(2022, 10);
// for (int i = startingDate.year; i <= endDate.year; i++) {
//   for (int j = (startingDate.year == i) ? startingDate.month : 1;
//       (endDate.year == i) ? j <= endDate.month : j <= 12;
//       j++) {
//     if (years.containsKey('$i')) {
//       years['$i']!.add(j);
//     } else {
//       years.addAll({
//         '$i': [j]
//       });
//     }
//   }
// }
