part of 'user_bloc.dart';

enum AuthStatus { initial, loading, done }

class UserState extends Equatable {
  final User? user;
  final String userId;
  final String errorMessage;
  final AuthStatus status;

  const UserState({
    this.user,
    this.userId = '',
    this.errorMessage = '',
    this.status = AuthStatus.initial,
  });

  UserState copyWith({
    User? user,
    String? userId,
    String? errorMessage,
    AuthStatus? status,
  }) {
    return UserState(
      user: user ?? this.user,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, userId, errorMessage, status];
}
