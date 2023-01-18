import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/date_bloc/date_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';
import 'package:kitty/widgets/month_picker/month_picker.dart';

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
        listener: (context, state) {
          if (state.entriesData.isNotEmpty) {
            BlocProvider.of<DateBloc>(context).add(
              InitialDateEvent(
                state.entriesData,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              children: [
                if (state.entriesData.isNotEmpty) ...[
                   MonthPicker(entries: state.entriesData,)
                ] else
                  ...[
                    const SizedBox.shrink()
                  ],
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                      Border.all(color: AppColors.borderGrey, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.expenses,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '-12000',
                            style: AppStyles.appRed,
                          ),
                          const Text(
                            'Expenses',
                            style: AppStyles.caption,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.wallet,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '48000',
                            style: AppStyles.appGreen,
                          ),
                          const Text(
                            'Balance',
                            style: AppStyles.caption,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.institute,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '70000',
                            style: AppStyles.buttonBlack,
                          ),
                          const Text(
                            'Income',
                            style: AppStyles.caption,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                // const EntriesListBuilder()
              ],
            ),
          );
        },
      ),
    );
  }
}

class BlockChart extends StatefulWidget {
  const BlockChart({Key? key}) : super(key: key);

  @override
  State<BlockChart> createState() => _BlockChartState();
}

class _BlockChartState extends State<BlockChart> {
  late final RenderBox _renderBox;
  late final Size _size;

  @override
  void initState() {
    _renderBox = context.findRenderObject() as RenderBox;
    _size = _renderBox.size;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),),
      child: Row(
        children: [
          AnimatedContainer(
            color: Colors.greenAccent,
            width: _size.width * 0.32,
            duration: Duration(seconds: 1),
          ),
          AnimatedContainer(
            color: Colors.deepOrangeAccent,
            width: _size.width * 0.32,
            duration: Duration(seconds: 1),
          ), AnimatedContainer(
            color: Colors.redAccent,
            width: _size.width * 0.16,
            duration: Duration(seconds: 1),
          ), AnimatedContainer(
            color: Colors.lightBlue,
            width: _size.width * 0.10,
            duration: Duration(seconds: 1),
          ), AnimatedContainer(
            color: Colors.green,
            width: _size.width * 0.10,
            duration: Duration(seconds: 1),
          ),
        ],
      ),
    );
  }
}
