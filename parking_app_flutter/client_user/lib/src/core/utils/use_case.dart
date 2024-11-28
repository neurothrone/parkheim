import 'package:shared/shared.dart';

import 'utils.dart';

abstract interface class UseCase<Type, Params> {
  Future<Result<Type, AppFailure>> call(Params params);
}
