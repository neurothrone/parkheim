import '../enums/vehicle_type.dart';
import '../models/parking.dart';
import '../models/parking_space.dart';
import '../models/person.dart';
import '../models/vehicle.dart';

class JsonHelper {
  JsonHelper._internal();

  static Person? personFromJson(Map<String, dynamic> json) {
    if (json
        case {
          "id": String _,
          "name": String _,
          "socialSecurityNumber": String _,
        }) {
      return Person.fromJson(json);
    }
    return null;
  }

  static Vehicle? vehicleFromJson(Map<String, dynamic> json) {
    if (json
        case {
          "id": String _,
          "registrationNumber": String _,
          "vehicleType": VehicleType _,
          "owner": {
            "id": String _,
            "name": String _,
            "socialSecurityNumber": String _,
          }
        }) {
      return Vehicle.fromJson(json);
    }
    return null;
  }

  static ParkingSpace? parkingSpaceFromJson(Map<String, dynamic> json) {
    if (json
        case {
          "id": String _,
          "address": String _,
          "pricePerHour": double _,
        }) {
      return ParkingSpace.fromJson(json);
    }
    return null;
  }

  static Parking? parkingFromJson(Map<String, dynamic> json) {
    if (json
        case {
          "id": String _,
          "vehicle": {
            "id": String _,
            "registrationNumber": String _,
            "vehicleType": VehicleType _,
          },
          "parkingSpace": {
            "id": String _,
            "address": String _,
            "pricePerHour": double _,
          },
          "startTime": DateTime? _,
          "endTime": DateTime? _,
        }) {
      return Parking.fromJson(json);
    }
    return null;
  }
}
