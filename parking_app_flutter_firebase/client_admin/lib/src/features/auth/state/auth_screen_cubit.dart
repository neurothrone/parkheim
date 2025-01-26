import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthScreenChoice { login, register }

class AuthScreenCubit extends Cubit<AuthScreenChoice> {
  AuthScreenCubit() : super(AuthScreenChoice.login);

  void showLogin() => emit(AuthScreenChoice.login);

  void showRegister() => emit(AuthScreenChoice.register);
}
