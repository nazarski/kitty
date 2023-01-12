part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}


class NavigateTab extends NavigationEvent {
  NavigateTab({
    required this.tabIndex,
    required this.route,
  });

  final int tabIndex;
  final String route;
}
class NavigationPop extends NavigationEvent{}

// class NavigationInitial extends NavigationEvent{}
