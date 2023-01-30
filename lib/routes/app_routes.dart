import 'package:flutter/material.dart';
import 'package:kitty/ui/screens/add_category_screen/add_category_screen.dart';
import 'package:kitty/ui/screens/add_entry_screen/add_entry_screen.dart';
import 'package:kitty/ui/screens/edit_category_screen/edit_category_screen.dart';
import 'package:kitty/ui/screens/faq_screen/faq_screen.dart';
import 'package:kitty/ui/screens/home_screen/home_screen.dart';
import 'package:kitty/ui/screens/login_screen/login_screen.dart';
import 'package:kitty/ui/screens/main_screen.dart';
import 'package:kitty/ui/screens/manage_categories_screen/manage_categories_screen.dart';
import 'package:kitty/ui/screens/registration_screen/registration_screen.dart';
import 'package:kitty/ui/screens/search_screen/search_screen.dart';
import 'package:kitty/ui/screens/settings_screen/settings_screen.dart';
import 'package:kitty/ui/screens/statistics_screen/statistics_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  const AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    WidgetBuilder builder;
    switch (settings.name) {
      case LoginScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const LoginScreen(),
            type: PageTransitionType.fade);
      case RegistrationScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const RegistrationScreen(),
            type: PageTransitionType.fade);
      // case CheckScreen.routeName:
      //   return PageTransition(
      //       settings: RouteSettings(name: settings.name),
      //       child: const CheckScreen(),
      //       type: PageTransitionType.fade);
      case MainScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const MainScreen(),
            type: PageTransitionType.fade);
      case HomeScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const HomeScreen(),
            type: PageTransitionType.fade);
      case SettingsScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const SettingsScreen(),
            type: PageTransitionType.fade);
      case StatisticsScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const StatisticsScreen(),
            type: PageTransitionType.fade);
      case AddEntryScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const AddEntryScreen(),
            type: PageTransitionType.fade);
      case AddCategoryScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const AddCategoryScreen(),
            type: PageTransitionType.fade);
      case SearchScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const SearchScreen(),
            type: PageTransitionType.fade);
      case ManageCategoriesScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const ManageCategoriesScreen(),
            type: PageTransitionType.fade);
      case EditCategoryScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const EditCategoryScreen(),
            type: PageTransitionType.fade);
      case FAQScreen.routeName:
        return PageTransition(
            settings: RouteSettings(name: settings.name),
            child: const FAQScreen(),
            type: PageTransitionType.fade);

      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }
}
