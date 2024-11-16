import 'package:personnummer/personnummer.dart';

class ValidationHelper {
  ValidationHelper._internal();

  static bool isValidRegistrationNumber(String registrationNumber) {
    if (registrationNumber.isEmpty) {
      return false;
    }

    if (!RegExp(r'^[A-Z]{3}\d{3}$').hasMatch(registrationNumber)) {
      return false;
    }

    return true;
  }

  static bool isValidSwedishSocialSecurityNumber(String ssn) {
    if (ssn.isEmpty) {
      return false;
    }

    return Personnummer.valid(ssn);
  }
}
