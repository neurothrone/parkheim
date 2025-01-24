import 'package:flutter_test/flutter_test.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:client_admin/src/features/auth/state/auth_cubit.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group("AuthCubit", () {
    late AuthCubit authCubit;
    late Storage storage;

    // !: Source: https://pub.dev/packages/hydrated_bloc#testing
    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
      authCubit = AuthCubit();
    });

    group("AuthCubit tests", () {
      blocTest<AuthCubit, AuthStatus>(
        "emits [AuthStatus.authenticating, AuthStatus.authenticated] when signIn is called",
        build: () => authCubit,
        act: (cubit) => cubit.signIn(),
        expect: () => [
          AuthStatus.authenticating,
          AuthStatus.authenticated,
        ],
      );

      blocTest<AuthCubit, AuthStatus>(
        "emits [AuthStatus.unauthenticated] when signOut is called",
        build: () => authCubit,
        act: (cubit) => cubit.signOut(),
        expect: () => [
          AuthStatus.unauthenticated,
        ],
      );
    });
  });
}
