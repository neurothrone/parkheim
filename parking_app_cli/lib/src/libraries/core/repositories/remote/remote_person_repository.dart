import '../../../../cli/enums/model_type.dart';
import '../../models/person.dart';
import 'base_remote_repository.dart';

class RemotePersonRepository extends BaseRemoteRepository<Person> {
  RemotePersonRepository._internal() : super(fromJson: Person.fromJson);

  static final _instance = RemotePersonRepository._internal();

  static RemotePersonRepository get instance => _instance;

  @override
  ModelType get modelType => ModelType.person;
}
