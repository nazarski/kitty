import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/entries_list.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';
import 'package:kitty/widgets/month_picker/month_picker.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = 'home_page';

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
              children: [
                if (state.entriesDates.isNotEmpty) ...[
                  MonthPicker(
                    entries: state.entriesDates,
                    selectType: 'range',
                  )
                ] else ...[
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
                          Text(
                            '${state.balance.expenses}',
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
                          state.balance.balance < 0
                              ? Text(
                                  '${state.balance.balance}',
                                  style: AppStyles.appRed,
                                )
                              : Text(
                                  '${state.balance.balance}',
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
                          Text(
                            '${state.balance.income}',
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
                const EntriesListBuilder()
              ],
            ),
          );
        },
      ),
    );
  }
}
