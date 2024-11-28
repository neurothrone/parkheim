import 'package:shared/shared.dart';

import '../../../core/utils/utils.dart';
import '../../interfaces/auth_repository.dart';

class UserSignOutUseCase implements UseCase<void, void> {
  const UserSignOutUseCase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  Future<Result<void, AppFailure>> call(void params) {
    return _authRepository.signOut();
  }
}
