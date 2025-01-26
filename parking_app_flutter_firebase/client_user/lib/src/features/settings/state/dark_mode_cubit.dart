import 'package:flutter_bloc/flutter_bloc.dart';

class DarkModeCubit extends Cubit<bool> {
  DarkModeCubit() : super(false);

  bool get isDarkMode => state;

  void toggleDarkMode() {
    emit(!state);
  }
}
