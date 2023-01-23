import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/utils/helper.dart';
import 'package:kitty/widgets/month_picker/month_picker.dart';
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
    return BlocConsumer<EntriesControlBloc, EntriesControl>(
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
              await createOpenPdf(
                  statistics: state.statistics, reportDate: state.reportDate!);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MonthPicker(
                  selectType: 'exact',
                ),
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
}
