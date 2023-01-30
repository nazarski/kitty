import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/ui/screens/add_entry_screen/add_entry_screen.dart';
import 'package:kitty/ui/widgets/entries_list.dart';
import 'package:kitty/ui/widgets/main_app_bar.dart';
import 'package:kitty/ui/widgets/month_picker/month_picker.dart';


import 'widgets/balance.dart';
import 'widgets/home_leading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = 'home_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(leading: HomeLeading(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: SvgPicture.asset(
          AppIcons.addPlus,
          color: Colors.white,
        ),
        label: Text(LocaleKeys.add_new.tr()),
        onPressed: () {
          context
              .read<NavigationBloc>()
              .add(NavigateTab(tabIndex: 3, route: AddEntryScreen.routeName));
        },
      ),
      body: BlocConsumer<EntriesControlBloc, EntriesControlState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0,),
            child: Column(
              children: const [
                  MonthPicker(
                    selectType: 'range',
                  ),
                SizedBox(
                  height: 20,
                ),
                BalanceWidget(),
                SizedBox(
                  height: 8,
                ),
                EntriesListBuilder()
              ],
            ),
          );
        },
      ),
    );
  }
}




