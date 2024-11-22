import '../../../core/entities/user_entity.dart';
import '../../../core/utils/utils.dart';
import '../../interfaces/auth_repository.dart';

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
