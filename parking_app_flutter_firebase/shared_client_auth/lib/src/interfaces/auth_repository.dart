import 'package:shared/shared.dart';

import '../entities/user_entity.dart';
import '../utils/utils.dart';

abstract interface class AuthRepository {
  Future<Result<UserEntity, AppFailure>> currentUser();

  Future<Result<UserEntity, AppFailure>> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Result<UserEntity, AppFailure>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Result<void, AppFailure>> signOut();
}
