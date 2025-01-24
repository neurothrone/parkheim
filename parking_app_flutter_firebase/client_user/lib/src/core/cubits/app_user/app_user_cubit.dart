import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/user_entity.dart';
import 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    emit(user == null ? AppUserInitial() : AppUserSignedIn(user: user));
  }
}
