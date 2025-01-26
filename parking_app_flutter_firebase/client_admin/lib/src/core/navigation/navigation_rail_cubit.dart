import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_rail_tab.dart';

class NavigationRailCubit extends Cubit<NavigationRailTab> {
  NavigationRailCubit() : super(NavigationRailTab.defaultTab);

  void changeTab(NavigationRailTab newTab) {
    emit(newTab);
  }
}
