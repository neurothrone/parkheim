import 'package:parking_app_cli/src/libraries/core/models/parking_space.dart';
import 'package:parking_app_cli/src/libraries/core/utils/json_helper.dart';
import 'package:test/test.dart';

void main() {
  group("ParkingSpace json tests", () {
    // Arrange
    const id = "1";
    const address = "Random street 47";
    const pricePerHour = 5.5;

    Map<String, dynamic> json = {
      "id": id,
      "address": address,
      "pricePerHour": pricePerHour,
    };

    test(
      "JsonHelper.parkingSpaceFromJson() successfully parses json.",
      () {
        // Act
        ParkingSpace? person = JsonHelper.parkingSpaceFromJson(json);

        // Arrange
        expect(person, isNotNull);
        expect(person?.id, id);
        expect(person?.address, address);
        expect(person?.pricePerHour, pricePerHour);
      },
    );

    test(
      "ParkingSpace.fromJson() successfully parses json",
      () {
        // Act
        final parkingSpace = ParkingSpace.fromJson(json);

        // Assert
        expect(parkingSpace.id, id);
        expect(parkingSpace.address, address);
        expect(parkingSpace.pricePerHour, pricePerHour);
      },
    );

    test(
      "ParkingSpace.fromJson() throws TypeError when parsing a non-string id",
      () {
        // Arrange
        Map<String, dynamic> invalidJson = {
          ...json,
          "id": 1,
        };

        // Act, Assert
        expect(
          () => ParkingSpace.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
