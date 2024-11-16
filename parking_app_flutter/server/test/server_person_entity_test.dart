import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:server/src/entities/person_entity.dart';
import 'package:server/src/repositories/server_item_repository.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test(
    "serverPersonRepository_create_shouldReturnMatchingPersonEntityWithGeneratedId",
    () async {
      // Arrange
      final repository = ServerItemRepository<PersonEntity>();
      final person = PersonEntity(
        name: "John Doe",
        socialSecurityNumber: "19541028",
      );

      // Act
      final result = await repository.create(person);

      // Assert
      result.when(
        success: (PersonEntity createdPerson) {
          expect(
            person.id,
            0,
            reason: "A newly instantiated Person has an ID of 0.",
          );
          expect(
            createdPerson.id,
            isNonZero,
            reason: "Created Person should have a non-zero ID.",
          );
          expect(
            person.name,
            createdPerson.name,
            reason: "Names should match.",
          );
          expect(
            person.socialSecurityNumber,
            createdPerson.socialSecurityNumber,
            reason: "Social security numbers should match.",
          );
        },
        failure: (error) => fail(
          "Repository should succeed in creating PersonEntity, error: $error",
        ),
      );
    },
  );

  test(
    "serverPersonHandler_post_shouldReturnMatchingPersonEntityWithGeneratedId",
    () async {
      // Arrange
      final uri = Uri.parse("$host/persons");
      final person = PersonEntity(
        name: "John Doe",
        socialSecurityNumber: "19541028",
      );

      // Act
      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      // Assert
      expect(response.statusCode, HttpStatus.ok);

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      final createdPerson = PersonEntity.fromJson(map);

      expect(
        person.id,
        0,
        reason: "A newly instantiated Person has an ID of 0.",
      );
      expect(
        createdPerson.id,
        isNonZero,
        reason: "Created Person should have a non-zero ID.",
      );
      expect(
        person.name,
        createdPerson.name,
        reason: "Names should match.",
      );
      expect(
        person.socialSecurityNumber,
        createdPerson.socialSecurityNumber,
        reason: "Social security numbers should match.",
      );
    },
  );
}
