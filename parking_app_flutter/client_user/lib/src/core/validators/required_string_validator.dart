mixin RequiredStringValidator {
  String? validateString(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }
}
