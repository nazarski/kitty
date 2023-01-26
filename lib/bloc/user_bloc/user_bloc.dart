import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/models/user_model/user.dart';
import 'package:kitty/repository/secure_storage_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SecureStorageRepository secureStorageRepository =
  SecureStorageRepository();

  UserBloc() : super(const UserState()) {
    on<CallLatestUserEvent>((event, emit) {});
    on<CreateUserEvent>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final user = User(
          name: event.name,
          email: event.email,
          pin: event.pin,
          biometrics: event.biometrics);
      final String id = await secureStorageRepository.createUser(user: user);
      emit(state.copyWith(status: AuthStatus.done, userId: id, user: user));
    });


  }
}
