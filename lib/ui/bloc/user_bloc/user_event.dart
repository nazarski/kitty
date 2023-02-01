part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class InitialUserEvent extends UserEvent {}

class CallLatestUserEvent extends UserEvent {}

class CreateUserEvent extends UserEvent {
  final String name;
  final String pin;
  final String email;
  final bool biometrics;

  const CreateUserEvent(
      {required this.name,
      required this.pin,
      required this.email,
      required this.biometrics});
}

class SignInEvent extends UserEvent {
  final String email;

  const SignInEvent(this.email);
}

class SuccessfullySignedIn extends UserEvent {}

class SignOutEvent extends UserEvent {}
class ChooseAvatarEvent extends UserEvent{
  final String path;

  const ChooseAvatarEvent(this.path);
}
class ValidateUserEvent extends UserEvent{
  final String name;
  final String email;

 const ValidateUserEvent({required this.name, required this.email});

}