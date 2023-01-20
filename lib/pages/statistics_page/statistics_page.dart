import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';
import 'package:kitty/widgets/month_picker/month_picker.dart';
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
    return Scaffold(
      appBar: const HomePageAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: SvgPicture.asset(
          AppIcons.addPlus,
          color: Colors.white,
        ),
        label: const Text('Add new'),
        onPressed: () {
          context
              .read<NavigationBloc>()
              .add(NavigateTab(tabIndex: 3, route: AddEntry.routeName));
        },
      ),
      body: BlocConsumer<DatabaseBloc, DatabaseState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.entriesDates.isNotEmpty) ...[
                  MonthPicker(
                    entries: state.entriesDates,
                    selectType: 'exact',
                  )
                ] else
                  ...[
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
          );
        },
      ),
    );
  }
}

