import 'package:flutter/material.dart';
import 'package:kitty/pages/add_category/add_category.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/pages/home_page/home_page.dart';
import 'package:kitty/pages/main_page.dart';
import 'package:kitty/pages/search_page/search_page.dart';
import 'package:kitty/pages/settings_page/settings_page.dart';
import 'package:kitty/pages/check_screen/check_screen.dart';
import 'package:kitty/pages/statistics_page/statistics_page.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    WidgetBuilder builder;
    print(settings.name);

    switch (settings.name) {
      case CheckScreen.routeName:
        return PageTransition(
            child: const CheckScreen(), type: PageTransitionType.fade);
      case MainPage.routeName:
        return PageTransition(
            child: const MainPage(), type: PageTransitionType.fade);
      case HomePage.routeName:
        return PageTransition(
            child: const HomePage(), type: PageTransitionType.fade);
      case SettingsPage.routeName:
        return PageTransition(
            child: const SettingsPage(), type: PageTransitionType.fade);
      case StatisticsPage.routeName:
        return PageTransition(
            child: const StatisticsPage(), type: PageTransitionType.fade);
      case AddEntry.routeName:
        return PageTransition(
            child: const AddEntry(), type: PageTransitionType.fade);
      case AddCategory.routeName:
        return PageTransition(
            child: const AddCategory(), type: PageTransitionType.fade);
      case SearchPage.routeName:
        return PageTransition(
            child: const SearchPage(), type: PageTransitionType.fade);

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
