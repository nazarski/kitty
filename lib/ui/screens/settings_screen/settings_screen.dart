import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/ui/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/ui/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/ui/screens/faq_screen/faq_screen.dart';
import 'package:kitty/ui/screens/login_screen/login_screen.dart';
import 'package:kitty/ui/screens/manage_categories_screen/manage_categories_screen.dart';
import 'package:kitty/ui/screens/statistics_screen/statistics_screen.dart';

import 'widgets/change_language.dart';
import 'widgets/settings_option.dart';
import 'widgets/user_info.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = 'settings_page';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.status == AuthStatus.signedOut) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
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
                        title: LocaleKeys.manage_cat.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 6,
                              route: ManageCategoriesScreen.routeName));
                        }),
                    SettingOption(
                        icon: Icons.picture_as_pdf_outlined,
                        title: LocaleKeys.export.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: 0, route: StatisticsScreen.routeName));
                        }),
                     ChangeLanguage(onChanged: (value) => context.setLocale
                       (Locale(value))),
                    SettingOption(
                        icon: Icons.help_center_outlined,
                        title: LocaleKeys.faq.tr(),
                        action: () {
                          context.read<NavigationBloc>().add(NavigateTab
                            (tabIndex: 8, route: FAQScreen.routeName));
                        }),
                    SettingOption(
                      icon: Icons.logout_outlined,
                      title: LocaleKeys.logout.tr(),
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


