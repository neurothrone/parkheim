import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/parking_tab.dart';

class ParkingTabCubit extends Cubit<ParkingTab> {
  ParkingTabCubit() : super(ParkingTab.defaultTab);

  void changeTab(ParkingTab newTab) {
    emit(newTab);
  }
}
