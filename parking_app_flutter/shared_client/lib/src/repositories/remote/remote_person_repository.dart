import 'package:shared/shared.dart';
import 'base_remote_repository.dart';

class RemotePersonRepository extends BaseRemoteRepository<Person, String> {
  RemotePersonRepository._internal()
      : super(
          resource: ModelType.person.resource,
          fromJson: Person.fromJson,
        );

  static final _instance = RemotePersonRepository._internal();

  static RemotePersonRepository get instance => _instance;

  Future<bool> isNameAvailable(String name) async {
    final result = await getAll();
    return result.when(
      success: (List<Person> people) {
        return people.every((person) => person.name != name);
      },
      failure: (error) {
        return false;
      },
    );
  }
}
