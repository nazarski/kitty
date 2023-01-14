import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


Color fromHex(String str){
  return Color(int.parse('FF$str', radix: 16));
}

String _transformDate(String date) {
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
