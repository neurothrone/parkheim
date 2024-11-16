import 'package:parking_app_cli/src/libraries/core/enums/vehicle_type.dart';
import 'package:parking_app_cli/src/libraries/core/models/vehicle.dart';
import 'package:parking_app_cli/src/libraries/core/utils/json_helper.dart';
import 'package:test/test.dart';

void main() {
  group("Vehicle json tests", () {
    // Arrange
    const vehicleId = "1";
    const registrationNumber = "ABC123";
    const vehicleType = VehicleType.car;

    const personId = "9";
    const name = "John Doe";
    const socialSecurityNumber = "19820217";

    Map<String, dynamic> json = {
      "id": vehicleId,
      "registrationNumber": registrationNumber,
      "vehicleType": vehicleType,
      "owner": {
        "id": personId,
        "name": name,
        "socialSecurityNumber": socialSecurityNumber,
      }
    };

    test(
      "JsonHelper.vehicleFromJson() successfully parses json.",
      () {
        // Act
        Vehicle? vehicle = JsonHelper.vehicleFromJson(json);

        // Assert
        expect(vehicle, isNotNull);
        expect(vehicle?.id, vehicleId);
        expect(vehicle?.registrationNumber, registrationNumber);
        expect(vehicle?.vehicleType, vehicleType);

        expect(vehicle?.owner?.id, personId);
        expect(vehicle?.owner?.name, name);
        expect(vehicle?.owner?.socialSecurityNumber, socialSecurityNumber);
      },
    );

    test(
      "Vehicle.fromJson() successfully parses json",
      () {
        // Act
        final vehicle = Vehicle.fromJson(json);

        // Assert
        expect(vehicle.id, vehicleId);
        expect(vehicle.registrationNumber, registrationNumber);
        expect(vehicle.vehicleType, vehicleType);

        expect(vehicle.owner?.id, personId);
        expect(vehicle.owner?.name, name);
        expect(vehicle.owner?.socialSecurityNumber, socialSecurityNumber);
      },
    );

    test(
      "Vehicle.fromJson() throws TypeError when parsing a non-string id",
      () {
        // Arrange
        Map<String, dynamic> invalidJson = {
          ...json,
          "id": 1,
        };

        // Act, Assert
        expect(
          () => Vehicle.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
