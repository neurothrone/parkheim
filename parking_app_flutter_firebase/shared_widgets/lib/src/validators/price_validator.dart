mixin PriceValidator {
  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return "Price is required";
    }

    final double? price = double.tryParse(value);

    if (price == null) {
      return "That doesn't look like a price";
    }

    if (price < 0) {
      return "Price can't be negative";
    }

    return null;
  }
}
