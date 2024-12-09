import 'package:flutter/foundation.dart';

class ParkingSearchTextProvider extends ChangeNotifier {
  String _searchText = "";

  String get searchText => _searchText;

  void search(String text) {
    _searchText = text;
    notifyListeners();
  }
}
