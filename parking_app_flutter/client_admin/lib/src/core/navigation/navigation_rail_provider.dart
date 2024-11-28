import 'package:flutter/foundation.dart';

import 'navigation_rail_tab.dart';

class NavigationRailProvider extends ChangeNotifier {
  NavigationRailTab _selectedTab = NavigationRailTab.people;

  NavigationRailTab get selectedTab => _selectedTab;

  void changeTab(NavigationRailTab newTab) {
    _selectedTab = newTab;
    notifyListeners();
  }
}
