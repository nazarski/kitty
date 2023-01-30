import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/database/expenses_database.dart';
import 'package:kitty/pages/add_category/add_category.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/pages/edit_category/edit_category.dart';
import 'package:kitty/pages/faq_page/faq_page.dart';
import 'package:kitty/pages/home_page/home_page.dart';
import 'package:kitty/pages/manage_categories_page/manage_categories_page.dart';
import 'package:kitty/pages/search_page/search_page.dart';
import 'package:kitty/pages/settings_page/settings_page.dart';
import 'package:kitty/pages/statistics_page/statistics_page.dart';
import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/routes/app_routes.dart';
import 'package:kitty/widgets/navigation/main_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = 'main_page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const List<String> _pages = [
    StatisticsPage.routeName,
    HomePage.routeName,
    SettingsPage.routeName,
    AddEntry.routeName,
    AddCategory.routeName,
    SearchPage.routeName,
    ManageCategoriesPage.routeName,
    EditCategory.routeName,
    FAQPage.routeName,
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
                initialRoute: HomePage.routeName,
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
                  ? MainBottomNavigationBar(
                      navigateTo: (value) {
                        if(value !=null) {
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
