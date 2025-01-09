import 'package:hydrated_bloc/hydrated_bloc.dart';

enum AuthStatus {
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthCubit extends HydratedCubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unauthenticated);

  Future<void> signIn() async {
    emit(AuthStatus.authenticating);

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AuthStatus.authenticated);
    } catch (e) {
      emit(AuthStatus.unauthenticated);
    }
  }

  void signOut() {
    emit(AuthStatus.unauthenticated);
  }

  @override
  AuthStatus? fromJson(Map<String, dynamic> json) =>
      json.containsKey("authenticated")
          ? switch (json["authenticated"]) {
              true => AuthStatus.authenticated,
              _ => AuthStatus.unauthenticated,
            }
          : AuthStatus.unauthenticated;

  @override
  Map<String, dynamic>? toJson(AuthStatus state) => {
        "authenticated": switch (state) {
          AuthStatus.authenticated => true,
          _ => false,
        }
      };
}
