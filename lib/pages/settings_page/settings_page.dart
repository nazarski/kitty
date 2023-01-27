import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/pages/check_screen/check_screen.dart';
import 'package:kitty/pages/login_page/login_page.dart';
import 'package:kitty/pages/manage_categories_page/manage_categories_page.dart';
import 'package:kitty/pages/statistics_page/statistics_page.dart';
import 'package:kitty/widgets/settings_page/settings_option.dart';
import 'package:kitty/widgets/settings_page/user_info.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static const routeName = '/settings_page';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if(state.status == AuthStatus.signedOut){
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const UserInfo(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SettingOption(
                        icon: Icons.category_outlined,
                        title: 'Manage categories',
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 6,
                              route: ManageCategoriesPage.routeName));
                        }),
                    SettingOption(
                        icon: Icons.picture_as_pdf_outlined,
                        title: 'Export to PDF',
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 0, route: StatisticsPage.routeName));
                        }),
                    SettingOption(
                        icon: Icons.translate_outlined,
                        title: 'Choose language',
                        action: () {}),
                    SettingOption(
                        icon: Icons.help_center_outlined,
                        title: 'Frequently asked questions',
                        action: () {}),
                    SettingOption(
                      icon: Icons.logout_outlined,
                      title: 'Logout',
                      action: () {
                        context.read<UserBloc>().add(SignOutEvent());
                      },
                      arrow: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
