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
        return people.every(
          (person) => person.name.toLowerCase() != name.toLowerCase(),
        );
      },
      failure: (error) {
        return false;
      },
    );
  }

  Future<Result<Person, String>> findPersonByName(String name) async {
    final result = await getAll();
    return result.when(
      success: (List<Person> people) {
        final person = people
            .where(
              (person) =>
                  person.name.toLowerCase().contains(name.toLowerCase()),
            )
            .toList()
            .firstOrNull;
        if (person == null) {
          return Result.failure(error: "Person not found.");
        }
        return Result.success(value: person);
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  }
}
