import 'package:flutter/foundation.dart';

import '../domain/parking_tab.dart';

class ParkingTabProvider extends ChangeNotifier {
  ParkingTab _selectedTab = ParkingTab.defaultTab;

  ParkingTab get selectedTab => _selectedTab;

  void changeTab(ParkingTab newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }
}
