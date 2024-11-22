import '../../../core/entities/user_entity.dart';
import '../../../core/utils/utils.dart';
import '../../interfaces/auth_repository.dart';

class UserSignInUseCase implements UseCase<UserEntity, UserSignInParams> {
  const UserSignInUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<UserEntity, AppFailure>> call(UserSignInParams params) {
    return _authRepository.signInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignInParams {
  const UserSignInParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
