import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/entities/user_entity.dart';
import '../../../domain/use_cases/auth.dart';
import '../../../core/cubits/app_user/app_user_cubit.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CurrentUserUseCase currentUserUseCase,
    required UserSignOutUseCase userSignOutUseCase,
    required UserSignUpUseCase userSignUpUseCase,
    required UserSignInUseCase userSignInUseCase,
    required AppUserCubit appUserCubit,
  })  : _currentUserUseCase = currentUserUseCase,
        _userSignOutUseCase = userSignOutUseCase,
        _userSignUpUseCase = userSignUpUseCase,
        _userSignInUseCase = userSignInUseCase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthIsUserSignedIn>(_isUserSignedIn);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
  }

  final CurrentUserUseCase _currentUserUseCase;
  final UserSignOutUseCase _userSignOutUseCase;
  final UserSignUpUseCase _userSignUpUseCase;
  final UserSignInUseCase _userSignInUseCase;
  final AppUserCubit _appUserCubit;

  Future<void> _isUserSignedIn(
    AuthIsUserSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _currentUserUseCase({});
    result.when(
      success: (user) => _emitAuthSuccess(user, emit),
      failure: (failure) => emit(AuthInitial()),
    );
  }

  Future<void> _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _userSignUpUseCase(
      UserSignUpParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.when(
      success: (user) => _emitAuthSuccess(user, emit),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  Future<void> _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _userSignInUseCase(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.when(
      success: (user) => _emitAuthSuccess(user, emit),
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  Future<void> _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _userSignOutUseCase({});
    result.when(
      success: (user) => {
        _appUserCubit.updateUser(null),
        emit(AuthInitial()),
      },
      failure: (failure) => emit(AuthFailure(message: failure.message)),
    );
  }

  void _emitAuthSuccess(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
