import 'package:flutter/foundation.dart';

enum AuthStatus {
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;

  AuthStatus get status => _status;

  Future<void> signIn() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void signOut() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
