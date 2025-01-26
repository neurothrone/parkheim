import 'package:flutter/foundation.dart';

import '../entities/user_entity.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

final class AppUserInitial extends AppUserState {}

final class AppUserSignedIn extends AppUserState {
  const AppUserSignedIn({
    required this.user,
  });

  final UserEntity user;
}
