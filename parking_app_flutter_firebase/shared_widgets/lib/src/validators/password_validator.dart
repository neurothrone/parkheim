mixin PasswordValidator {
  String? validatePassword(String? password, {int minLength = 8}) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < minLength) {
      return "Password must be at least $minLength characters";
    }
    return null;
  }
}
