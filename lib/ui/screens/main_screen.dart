import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/data/expenses_database.dart';
import 'package:kitty/domain/repository/database_repository.dart';
import 'package:kitty/routes/app_routes.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/ui/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/ui/widgets/navigation/main_bottom_navigation_app_bar.dart';

import 'add_category_screen/add_category_screen.dart';
import 'add_entry_screen/add_entry_screen.dart';
import 'edit_category_screen/edit_category_screen.dart';
import 'faq_screen/faq_screen.dart';
import 'home_screen/home_screen.dart';
import 'manage_categories_screen/manage_categories_screen.dart';
import 'search_screen/search_screen.dart';
import 'settings_screen/settings_screen.dart';
import 'statistics_screen/statistics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const routeName = 'main_page';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const List<String> _pages = [
    StatisticsScreen.routeName,
    HomeScreen.routeName,
    SettingsScreen.routeName,
    AddEntryScreen.routeName,
    AddCategoryScreen.routeName,
    SearchScreen.routeName,
    ManageCategoriesScreen.routeName,
    EditCategoryScreen.routeName,
    FAQScreen.routeName,
  ];
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  void _onSelectTab(int index) {
    if (_navigatorKey.currentState != null) {
      _navigatorKey.currentState!.pushNamed(
        _pages[index],
      );
    }
  }

  Future<bool> _maybePop() async {
    return await _navigatorKey.currentState!.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseRepository(
          ExpensesDatabaseProvider(context.read<UserBloc>().state.userId)),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<EntriesControlBloc>(
              create: (context) => EntriesControlBloc(
                  RepositoryProvider.of<DatabaseRepository>(context))
                ..add(CallAllDataEvent())),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child:
            BlocConsumer<NavigationBloc, NavigationState>(listener: (_, state) {
          if (state.status == NavigationStateStatus.tab) {
            _onSelectTab(state.currentIndex);
          }
        }, builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              return !await _maybePop();
            },
            child: Scaffold(
              key: scaffoldKey,
              body: Navigator(
                key: _navigatorKey,
                initialRoute: HomeScreen.routeName,
                onGenerateRoute: AppRoutes.generateRoute,
                observers: [
                  MyNavigatorObserver((value) {
                    context
                        .read<NavigationBloc>()
                        .add(NavigationOnPop(_pages.indexOf(value)));
                  })
                ],
              ),
              bottomNavigationBar: [0, 1, 2].contains(state.currentIndex)
                  ? MainBottomNavigationAppBar(
                      navigateTo: (value) {
                        if (value != null) {
                          context.read<NavigationBloc>().add(NavigateTab(
                              tabIndex: value, route: _pages[value]));
                        }
                      },
                      currentIndex: state.currentIndex,
                    )
                  : null,
            ),
          );
        }),
      ),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  final ValueChanged action;

  MyNavigatorObserver(this.action);

  @override
  void didPop(Route route, Route? previousRoute) =>
      action(previousRoute!.settings.name);
}
