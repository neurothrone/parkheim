import 'package:parking_app_cli/src/libraries/core/enums/vehicle_type.dart';
import 'package:parking_app_cli/src/libraries/core/models/parking.dart';
import 'package:parking_app_cli/src/libraries/core/utils/json_helper.dart';
import 'package:test/test.dart';

void main() {
  group("Parking json tests", () {
    // Arrange
    const parkingId = "1";
    DateTime startTime = DateTime.now();
    DateTime? endTime;

    const vehicleId = "11";
    const registrationNumber = "ABC123";
    const vehicleType = VehicleType.car;

    const parkingSpaceId = "17";
    const address = "Random street 47";
    const pricePerHour = 5.5;

    Map<String, dynamic> json = {
      "id": parkingId,
      "startTime": startTime,
      "endTime": endTime,
      "vehicle": {
        "id": vehicleId,
        "registrationNumber": registrationNumber,
        "vehicleType": VehicleType.car,
      },
      "parkingSpace": {
        "id": parkingSpaceId,
        "address": address,
        "pricePerHour": pricePerHour,
      }
    };

    test(
      "JsonHelper.parkingFromJson() successfully parses json.",
      () {
        // Act
        Parking? parking = JsonHelper.parkingFromJson(json);

        // Assert
        expect(parking, isNotNull);
        expect(parking?.id, parkingId);
        expect(parking?.startTime, startTime);
        expect(parking?.endTime, endTime);

        expect(parking?.vehicle?.id, vehicleId);
        expect(parking?.vehicle?.registrationNumber, registrationNumber);
        expect(parking?.vehicle?.vehicleType, vehicleType);

        expect(parking?.parkingSpace?.id, parkingSpaceId);
        expect(parking?.parkingSpace?.address, address);
        expect(parking?.parkingSpace?.pricePerHour, pricePerHour);
      },
    );

    test(
      "Parking.fromJson() successfully parses json",
      () {
        // Act
        final parking = Parking.fromJson(json);

        // Assert
        expect(parking.id, parkingId);
        expect(parking.startTime, startTime);
        expect(parking.endTime, endTime);

        expect(parking.vehicle?.id, vehicleId);
        expect(parking.vehicle?.registrationNumber, registrationNumber);
        expect(parking.vehicle?.vehicleType, vehicleType);

        expect(parking.parkingSpace?.id, parkingSpaceId);
        expect(parking.parkingSpace?.address, address);
        expect(parking.parkingSpace?.pricePerHour, pricePerHour);
      },
    );

    test(
      "Parking.fromJson() throws TypeError when parsing a non-string id",
      () {
        // Arrange
        Map<String, dynamic> invalidJson = {
          ...json,
          "id": 1,
        };

        // Act, Assert
        expect(
          () => Parking.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });
}
