part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthIsUserSignedIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}

final class AuthSignUp extends AuthEvent {
  const AuthSignUp({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

final class AuthSignIn extends AuthEvent {
  const AuthSignIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
