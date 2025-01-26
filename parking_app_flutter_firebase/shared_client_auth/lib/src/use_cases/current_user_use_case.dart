import 'package:shared/shared.dart';

import '../entities/user_entity.dart';
import '../interfaces/auth_repository.dart';
import '../utils/utils.dart';

class CurrentUserUseCase implements UseCase<UserEntity, void> {
  const CurrentUserUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<UserEntity, AppFailure>> call(void params) {
    return _authRepository.currentUser();
  }
}
