import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:kitty/models/user_model/user.dart';
import 'package:kitty/repository/secure_storage_repository.dart';
import 'package:kitty/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SecureStorageRepository secureStorageRepository =
      SecureStorageRepository();

  Future<void> createNewUser(Emitter emit, String name, String email,
      String pin, bool biometrics) async {
    final validation = validateUserInfo(email, name);
    if (validation != null) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: validation));
    } else {
      if (await secureStorageRepository.checkAvailability(email)) {
        emit(state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'This user already exists'));
      } else {
        emit(state.copyWith(status: AuthStatus.loading));
        final user =
            User(name: name, email: email, pin: pin, biometrics: biometrics);
        final String id = await secureStorageRepository.createUser(user: user);
        emit(state.copyWith(status: AuthStatus.done, userId: id, user: user));
      }
    }
  }

  Future<void> signIn(Emitter emit, String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final User? user = await secureStorageRepository.getUser(email);
    if (user == null) {
      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: "There's no such email. "
              "Would you like to sign up?"));
    } else {
      emit(state.copyWith(user: user));
    }
  }

  UserBloc() : super(const UserState()) {
    on<InitialUserEvent>((event, emit) {
      emit(state.copyWith(status: AuthStatus.initial));
    });
    on<CallLatestUserEvent>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final last = await secureStorageRepository.getLastUser();
        emit(state.copyWith(status: AuthStatus.done, user: last));

    });
    on<CreateUserEvent>((event, emit) async {
      await createNewUser(
          emit, event.name, event.email, event.pin, event.biometrics);
    });
    on<SignInEvent>((event, emit) async {
      await signIn(emit, event.email);
    });
    on<SuccessfullySignedIn>((event, emit) async {
      emit(state.copyWith(userId: state.user.email));
      await secureStorageRepository.addLastUser(state.user.email);
    });
    on<SignOutEvent>((event, emit) async {
      await secureStorageRepository.removeLastUser();
      emit(state.copyWith(
          user: const User(name: '', email: '', pin: '', biometrics: false),
          userId: '',
          status: AuthStatus.signedOut));
    });
  }
}
