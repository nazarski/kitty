
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/ui/screens/home_screen/home_screen.dart';
part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigationOnPop>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStateStatus.pop,
          currentIndex: event.index,
        ),
      );
    });
    on<NavigateTab>((event, emit) {
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
