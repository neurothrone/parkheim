import 'package:parking_app_cli_server/src/libraries/core/models/person.dart';
import 'package:parking_app_cli_server/src/libraries/core/utils/json_helper.dart';
import 'package:test/test.dart';

void main() {
  group("Person json tests", () {
    // Arrange
    const id = "1";
    const name = "John Doe";
    const socialSecurityNumber = "19820217";

    Map<String, dynamic> json = {
      "id": id,
      "name": name,
      "socialSecurityNumber": socialSecurityNumber,
    };

    test(
      "JsonHelper.personFromJson() successfully parses json.",
      () {
        // Act
        Person? person = JsonHelper.personFromJson(json);

        // Arrange
        expect(person, isNotNull);
        expect(person?.id, id);
        expect(person?.name, name);
        expect(person?.socialSecurityNumber, socialSecurityNumber);
      },
    );

    test(
      "Person.fromJson() successfully parses json",
      () {
        // Act
        final person = Person.fromJson(json);

        // Assert
        expect(person.id, id);
        expect(person.name, name);
        expect(person.socialSecurityNumber, socialSecurityNumber);
      },
    );

    test(
      "Person.fromJson() throws TypeError when parsing a non-string id",
      () {
        // Arrange
        Map<String, dynamic> invalidJson = {
          ...json,
          "id": 1,
        };

        // Act, Assert
        expect(
          () => Person.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
