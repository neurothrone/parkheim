import 'package:flutter/foundation.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingSearchProvider with ChangeNotifier {
  final RemoteParkingRepository repository = RemoteParkingRepository.instance;

  List<Parking>? _parkings;
  String _errorMessage = "";
  bool _isLoading = false;

  List<Parking>? get parkings => _parkings;

  String get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  Future<void> search(String searchText) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _parkings = await repository.searchParkings(searchText);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
