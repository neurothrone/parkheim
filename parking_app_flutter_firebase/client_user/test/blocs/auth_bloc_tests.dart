import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:client_user/src/core/entities/user_entity.dart';
import 'package:client_user/src/core/utils/app_failure.dart';
import 'package:client_user/src/domain/use_cases/auth.dart';
import 'package:client_user/src/features/auth/bloc/auth_bloc.dart';
import 'package:shared/shared.dart';

class MockAppUserCubit extends Mock implements AppUserCubit {}

class MockCurrentUserUseCase extends Mock implements CurrentUserUseCase {}

class MockUserSignOutUseCase extends Mock implements UserSignOutUseCase {}

class MockUserSignUpUseCase extends Mock implements UserSignUpUseCase {}

class MockUserSignInUseCase extends Mock implements UserSignInUseCase {}

class MockUserSignUpParams extends Mock implements UserSignUpParams {}

class MockUserSignInParams extends Mock implements UserSignInParams {}

void main() {
  group("AuthBloc Tests", () {
    late MockCurrentUserUseCase mockCurrentUserUseCase;
    late MockUserSignOutUseCase mockUserSignOutUseCase;
    late MockUserSignUpUseCase mockUserSignUpUseCase;
    late MockUserSignInUseCase mockUserSignInUseCase;
    late MockAppUserCubit mockAppUserCubit;
    late AuthBloc authBloc;

    final UserEntity user = UserEntity(
      id: "1",
      email: "zane@example.com",
      displayName: "Captain Zane",
    );

    setUp(() {
      mockCurrentUserUseCase = MockCurrentUserUseCase();
      mockUserSignOutUseCase = MockUserSignOutUseCase();
      mockUserSignUpUseCase = MockUserSignUpUseCase();
      mockUserSignInUseCase = MockUserSignInUseCase();
      mockAppUserCubit = MockAppUserCubit();

      authBloc = AuthBloc(
        currentUserUseCase: mockCurrentUserUseCase,
        userSignOutUseCase: mockUserSignOutUseCase,
        userSignUpUseCase: mockUserSignUpUseCase,
        userSignInUseCase: mockUserSignInUseCase,
        appUserCubit: mockAppUserCubit,
      );
    });

    setUpAll(() {
      registerFallbackValue(MockUserSignUpParams());
      registerFallbackValue(MockUserSignInParams());
    });

    tearDown(() {
      authBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthError] when sign up fails",
      setUp: () {
        when(() => mockUserSignUpUseCase(any())).thenAnswer(
          (_) async => Result.failure(error: AppFailure("Error")),
        );
      },
      build: () => authBloc,
      seed: () => AuthInitial(),
      act: (bloc) => bloc.add(
        AuthSignUp(
          email: "zane@example.com",
          password: "12345678",
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthFailure(message: "Error"),
      ],
      verify: (_) {
        verify(() => mockUserSignUpUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthError] when login fails",
      setUp: () {
        when(() => mockUserSignInUseCase(any())).thenAnswer(
          (_) async => Result.failure(error: AppFailure("Error")),
        );
      },
      build: () => authBloc,
      seed: () => AuthInitial(),
      act: (bloc) => bloc.add(
        AuthSignIn(
          email: "zane@example.com",
          password: "12345678",
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthFailure(message: "Error"),
      ],
      verify: (_) {
        verify(() => mockUserSignInUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthSuccess] when sign up is successful",
      setUp: () {
        when(() => mockUserSignUpUseCase(any()))
            .thenAnswer((_) async => Result.success(value: user));
      },
      build: () => authBloc,
      seed: () => AuthInitial(),
      act: (bloc) => bloc.add(
        AuthSignUp(
          email: "zane@example.com",
          password: "12345678",
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthSuccess(user: user),
      ],
      verify: (_) {
        verify(() => mockUserSignUpUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthSuccess] when login is successful",
      setUp: () {
        when(() => mockUserSignInUseCase(any()))
            .thenAnswer((_) async => Result.success(value: user));
      },
      build: () => authBloc,
      seed: () => AuthInitial(),
      act: (bloc) => bloc.add(
        AuthSignIn(
          email: "zane@example.com",
          password: "12345678",
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthSuccess(user: user),
      ],
      verify: (_) {
        verify(() => mockUserSignInUseCase(any())).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthInitial] when logout is successful",
      setUp: () {
        when(() => mockUserSignOutUseCase({}))
            .thenAnswer((_) async => Result.success(value: null));
      },
      build: () => authBloc,
      seed: () => AuthSuccess(user: user),
      act: (bloc) => bloc.add(AuthSignOut()),
      expect: () => [
        AuthLoading(),
        AuthInitial(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits [AuthLoading, AuthSuccess] when fetching current user is successful",
      setUp: () {
        when(() => mockCurrentUserUseCase({})).thenAnswer(
          (_) async => Result.success(value: user),
        );
      },
      build: () => authBloc,
      seed: () => AuthInitial(),
      act: (bloc) => bloc.add(AuthIsUserSignedIn()),
      expect: () => [
        AuthLoading(),
        AuthSuccess(user: user),
      ],
      verify: (_) {
        verify(() => mockCurrentUserUseCase({})).called(1);
      },
    );
  });
}
