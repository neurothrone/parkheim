import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_tab.dart';

class BottomNavigationCubit extends Cubit<BottomTab> {
  BottomNavigationCubit() : super(BottomTab.people);

  void changeTab(BottomTab tab) {
    emit(tab);
  }
}
