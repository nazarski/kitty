part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class CallLatestUserEvent extends UserEvent {}

class CreateUserEvent extends UserEvent {
  final String name;
  final String pin;
  final String email;
  final bool biometrics;

  CreateUserEvent(
      {required this.name,
      required this.pin,
      required this.email,
      required this.biometrics});
}
