import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:kitty/domain/models/user_model/user.dart';
import 'package:kitty/domain/repository/secure_storage_repository.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/utils/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SecureStorageRepository secureStorageRepository =
      SecureStorageRepository();

  Future<void> createNewUser(Emitter emit, String name, String email,
      String pin, bool biometrics, String avatarLocalPath) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final user = User(
        name: name,
        email: email,
        pin: pin,
        biometrics: biometrics,
        avatarLocalPath: avatarLocalPath);
    final String id = await secureStorageRepository.createUser(user: user);
    emit(state.copyWith(status: AuthStatus.done, userId: id, user: user));
  }

  Future<void> validateUser(
    Emitter emit,
    String name,
      String email,
  ) async {
    final validation = validateUserInfo(email, name);
    if (validation != null) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: validation));
      return;
    }
    if (await secureStorageRepository.checkAvailability(email)) {
      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: LocaleKeys.registration_errors_user_exists.tr()));
      return;
    }
    emit(state.copyWith(status: AuthStatus.valid));
  }

  Future<void> signIn(Emitter emit, String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final User? user = await secureStorageRepository.getUser(email);
    if (user == null) {
      emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: LocaleKeys.registration_errors_no_user.tr()));
    } else {
      emit(state.copyWith(user: user));
    }
  }

  UserBloc() : super(const UserState()) {
    on<InitialUserEvent>((event, emit) {
      emit(state.copyWith(avatarLocalPath: '', status: AuthStatus.initial));
    });
    on<ChooseAvatarEvent>((event, emit) {
      emit(state.copyWith(avatarLocalPath: event.path));
    });
    on<CallLatestUserEvent>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final last = await secureStorageRepository.getLastUser();
      emit(state.copyWith(status: AuthStatus.done, user: last));
    });
    on<ValidateUserEvent>((event, emit)async {
     await validateUser(emit, event.name, event.email);
    });
    on<CreateUserEvent>((event, emit) async {
      await createNewUser(emit, event.name, event.email, event.pin,
          event.biometrics, state.avatarLocalPath);
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
          user: const User(
              name: '',
              email: '',
              pin: '',
              biometrics: false,
              avatarLocalPath: ''),
          userId: '',
          status: AuthStatus.signedOut));
    });
  }
}
