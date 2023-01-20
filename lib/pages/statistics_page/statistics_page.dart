import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mt;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';
import 'package:kitty/widgets/month_picker/month_picker.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';
import 'package:kitty/widgets/statistics_page/block_chart.dart';
import 'package:kitty/widgets/statistics_page/statistics_element_builder.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);
  static const routeName = '/statistics_page';

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabaseBloc, DatabaseState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: const HomePageAppBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(
              Icons.file_download_outlined,
              color: Colors.white,
            ),
            label: const Text('Download report'),
            onPressed: () async {
              final data = await buildPdf(
                selectedMonth: state.entriesDates.first.dateTime,
                stats: state.statistics,
              );
              await savePdfFile(
                  fileName:
                      'Expense_report_by_${DateFormat(DateFormat.MONTH).format(state.entriesDates.first.dateTime)}_${state.entriesDates.first.dateTime.year}',
                  byteList: data);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.entriesDates.isNotEmpty) ...[
                  MonthPicker(
                    entries: state.entriesDates,
                    selectType: 'exact',
                  )
                ] else ...[
                  const SizedBox.shrink()
                ],
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'OVERVIEW',
                  style: AppStyles.overline,
                ),
                const SizedBox(
                  height: 8,
                ),
                BlockChart(
                  stats: state.statistics,
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'DETAILS',
                      style: AppStyles.overline,
                    ),
                  ),
                ),
                const StatisticsElementBuilder(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> savePdfFile(
      {required String fileName, required Uint8List byteList}) async {
    final output = await getTemporaryDirectory();
    final path =
        '${output.path}/${fileName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(path);
    await file.writeAsBytes(byteList);
    print('here');
    await OpenDocument.openDocument(filePath: path);
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
    // final image = pw.MemoryImage(
    //   (await rootBundle.load('assets/images/splash_logo.jpg')).buffer
    //       .asUint8List(),
    // );
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
}
