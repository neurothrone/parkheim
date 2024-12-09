import 'package:flutter/foundation.dart';

import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class SpacesListProvider extends ChangeNotifier {
  List<ParkingSpace> _spaces = [];
  bool _isLoading = false;
  String? _error;

  List<ParkingSpace> get spaces => _spaces;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> fetchAllSpaces() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await RemoteParkingSpaceRepository.instance.getAll();
      result.when(
        success: (spaces) {
          _spaces = spaces;
          _error = null;
        },
        failure: (error) {
          _spaces = [];
          _error = error;
        },
      );
    } catch (e) {
      _spaces = [];
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
