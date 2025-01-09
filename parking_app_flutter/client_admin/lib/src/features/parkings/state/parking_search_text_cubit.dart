import 'package:flutter_bloc/flutter_bloc.dart';

class ParkingSearchTextCubit extends Cubit<String> {
  ParkingSearchTextCubit() : super("");

  void search(String text) {
    emit(text);
  }
}
