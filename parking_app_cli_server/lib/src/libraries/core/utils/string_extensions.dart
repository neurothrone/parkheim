extension Capitalize on String {
  String get capitalized =>
      isEmpty ? "" : replaceRange(0, 1, this[0].toUpperCase());
}
