import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/entries_list.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';
import 'package:kitty/widgets/icon_view.dart';

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
      body: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.subTitle,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.basicGrey),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.subTitle,
                            size: 16,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'January, 2023',
                            style: AppStyles.buttonBlack,
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: AppColors.subTitle),
                    ),
                  ],
                ),
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
                  height: 16,
                ),
                state.entries.isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.borderGrey, width: 1)),
                        child: const Center(
                          child: Text('No expenses found, tap "Add new"'),
                        ),
                      )
                    : const Expanded(
                        child: EntriesListBuilder(),
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}


