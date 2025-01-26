import 'package:shared/shared.dart';

mixin RegistrationNumberValidator {
  String? validateRegistrationNumber(String? registrationNumber) {
    if (registrationNumber == null || registrationNumber.isEmpty) {
      return "Registration number is required";
    }

    if (!ValidationHelper.isValidRegistrationNumber(registrationNumber)) {
      return "Invalid registration number";
    }

    return null;
  }
}


