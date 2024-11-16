import 'base_in_memory_repository.dart';
import '../../models/person.dart';

class PersonRepository extends BaseInMemoryRepository<Person> {
  PersonRepository._internal();

  static final _instance = PersonRepository._internal();

  static PersonRepository get instance => _instance;
}
