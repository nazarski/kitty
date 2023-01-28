import 'dart:io';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/models/entry_model/entry.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Color fromHex(String str) {
  return Color(int.parse('FF$str', radix: 16));
}

String checkDate(DateTime date) {
  final int day = date.day - DateTime.now().day;
  switch (day) {
    case 0:
      return LocaleKeys.today.tr();
    case -1:
      return LocaleKeys.yesterday.tr();
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

Future<void> createOpenPdf(
    {required List<StatisticsElement> statistics,
    required DateTime reportDate}) async {
  final data = await buildPdf(
    selectedMonth: reportDate,
    stats: statistics,
  );
  final path = await savePdfFile(
      fileName:
          'Expense_report_by_${DateFormat(DateFormat.MONTH).format(reportDate)}_'
          '${reportDate.year}',
      byteList: data);
  final result = await OpenFilex.open(path);
}

Future<String> savePdfFile(
    {required String fileName, required Uint8List byteList}) async {
  final output = await getTemporaryDirectory();
  final path =
      '${output.path}/${fileName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(path);
  return await file.writeAsBytes(byteList).then((value) => value.path);
}

Future<Uint8List> buildPdf({
  required DateTime selectedMonth,
  required List<StatisticsElement> stats,
}) async {
  final regularData = await rootBundle.load("assets/fonts/Inter-Regular.ttf");
  final mediumData = await rootBundle.load("assets/fonts/Inter-Medium.ttf");
  final regular = pw.Font.ttf(regularData);
  final medium = pw.Font.ttf(mediumData);
  final pw.Document doc = pw.Document();
  final table = pw.Table.fromTextArray(
    border: null,
    headers: ['Category', 'Transactions', 'Expenses', 'Result'],
    data: List<List<dynamic>>.generate(
      stats.length,
      (index) => <dynamic>[
        stats[index].categoryTitle,
        stats[index].countOfEntries,
        stats[index].totalAmount,
        '${stats[index].monthShare.round()}%',
      ],
    ),
    headerStyle: pw.TextStyle(
      color: PdfColors.white,
      fontWeight: pw.FontWeight.bold,
    ),
    headerDecoration: const pw.BoxDecoration(
      borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
      color: PdfColor.fromInt(0xff007BEF),
    ),
    rowDecoration: const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(
          color: PdfColor.fromInt(0xff616161),
          width: 0.5,
        ),
      ),
    ),
    cellAlignment: pw.Alignment.centerRight,
    cellAlignments: {0: pw.Alignment.centerLeft},
  );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(children: [
          // pw.Image(image),
          pw.Flexible(
            child: pw.Chart(
              title: pw.Text(
                  'Expense report on ${DateFormat(DateFormat.MONTH).format(selectedMonth)}, '
                  '${selectedMonth.year}',
                  style: pw.TextStyle(
                      color: PdfColor.fromInt(0xff212121),
                      font: medium,
                      fontSize: 18)),
              grid: pw.PieGrid(),
              datasets: List.generate(
                stats.length,
                (index) {
                  return pw.PieDataSet(
                      legend: '${stats[index].categoryTitle} '
                          '${stats[index].monthShare.round()}%',
                      legendPosition: pw.PieLegendPosition.outside,
                      legendStyle: pw.TextStyle(
                          font: medium,
                          fontSize: 12,
                          color: const PdfColor.fromInt(0xff212121)),
                      value: (stats[index].monthShare).round(),
                      color: PdfColor.fromHex(stats[index].icon.color));
                },
              ),
            ),
          ),
          pw.SizedBox(
            height: 8,
          ),
          pw.Center(
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 16),
              child: pw.Text(
                'DETAILS',
                style: pw.TextStyle(
                    color: const PdfColor.fromInt(
                      0xff212121,
                    ),
                    font: regular,
                    fontSize: 12),
              ),
            ),
          ),
          table
        ]);
      },
    ),
  );
  return doc.save();
}

String? validateUserInfo(String email, String name) {
  if (!validateEmail(email)) {
    return 'Sorry, your email is invalid';
  }
  if (!validateName(name)) {
    return 'Something is wrong with the name you typed';
  }
  return null;
}

bool validateName(String name) {
  return RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
      .hasMatch(name);
}

bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
