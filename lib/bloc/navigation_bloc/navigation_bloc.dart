import 'dart:async';

import 'package:kitty/pages/home_page/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    List<NavigationState> pages = [];
    on<NavigationPop>((_, emit) {
      print(pages);
      if(pages.isNotEmpty) {
        pages.removeLast();
      }
      if (pages.isEmpty) {
        emit(
          state.copyWith(status: NavigationStateStatus.tab, currentIndex: 1),
        );
      } else {
        emit(state.copyWith(
            status: NavigationStateStatus.tab,
            currentIndex: pages.last.currentIndex,
            route: pages.last.route));
      }
    });
    on<NavigateTab>((event, emit) {
      pages.add(
          NavigationState(currentIndex: event.tabIndex, route: event.route));
      emit(
        state.copyWith(
          status: NavigationStateStatus.tab,
          currentIndex: event.tabIndex,
          route: event.route,
        ),
      );
    });
  }
}
