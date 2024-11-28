import 'package:shared/shared.dart';

mixin SocialSecurityNumberValidator {
  String? validateSocialSecurityNumber(String? socialSecurityNumber) {
    if (socialSecurityNumber == null || socialSecurityNumber.isEmpty) {
      return "Social security number is required";
    }

    if (!ValidationHelper.isValidSwedishSocialSecurityNumber(
        socialSecurityNumber)) {
      return "Invalid social security number";
    }

    return null;
  }
}
