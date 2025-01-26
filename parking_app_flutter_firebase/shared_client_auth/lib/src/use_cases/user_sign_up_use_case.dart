import 'package:shared/shared.dart';

import '../entities/user_entity.dart';
import '../interfaces/auth_repository.dart';
import '../utils/utils.dart';

class UserSignUpUseCase implements UseCase<UserEntity, UserSignUpParams> {
  const UserSignUpUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<UserEntity, AppFailure>> call(UserSignUpParams params) {
    return _authRepository.signUpWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  const UserSignUpParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
