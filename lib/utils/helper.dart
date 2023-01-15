import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kitty/models/entry_model/entry.dart';

Color fromHex(String str) {
  return Color(int.parse('FF$str', radix: 16));
}

String transformDate(String date) {
  final int day =
      DateFormat('dd-MMM-yyyy').parse(date).difference(DateTime.now()).inDays;
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
  return list.groupListsBy((element) => element.dateTime);
}

String getSum(List<Entry> list) {
  final sum =
      list.fold(0, (previousValue, element) => previousValue + element.amount);
  return '-$sum';
}
