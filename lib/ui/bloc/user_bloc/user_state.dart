part of 'user_bloc.dart';

enum AuthStatus { initial, loading, done, error, signedOut, valid, }

class UserState extends Equatable {
  final User user;
  final String userId;
  final String errorMessage;
  final AuthStatus status;
  final String avatarLocalPath;

  const UserState({
    this.user = const User(name: '', email: '', pin: '', biometrics: false, avatarLocalPath: ''),
    this.userId = '',
    this.errorMessage = '',
    this.status = AuthStatus.initial,
    this.avatarLocalPath = '',
  });

  UserState copyWith({
    User? user,
    String? userId,
    String? errorMessage,
    AuthStatus? status,
    String? avatarLocalPath,
  }) {
    return UserState(
      user: user ?? this.user,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      avatarLocalPath: avatarLocalPath ?? this.avatarLocalPath,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [user, userId, errorMessage, status, avatarLocalPath];
}
