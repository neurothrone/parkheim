import 'package:shared/shared.dart';

import '../../shared_client_firebase.dart';

class FirebasePersonRepository extends BaseFirebaseRepository<Person, String> {
  FirebasePersonRepository()
      : super(
          collection: ModelType.person.resource,
          fromJson: Person.fromJson,
        );

  Future<bool> isNameAvailable(String name) async {
    final result = await getAll();
    return result.when(
      success: (List<Person> people) {
        return people.every(
          (person) => person.name.toLowerCase() != name.toLowerCase(),
        );
      },
      failure: (error) => false,
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
      failure: (error) => Result.failure(error: error),
    );
  }
}
