import '../enums/model_type.dart';
import 'base_manager.dart';

final class PersonManager extends BaseManager {
  @override
  ModelType get modelType => ModelType.person;
}
