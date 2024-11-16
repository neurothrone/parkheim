import 'base_model.dart';
import 'parking_space.dart';
import 'vehicle.dart';

class Parking extends BaseModel {
  Parking({
    super.id,
    required this.vehicle,
    required this.parkingSpace,
    required this.startTime,
    required this.endTime,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    Vehicle? vehicle;
    if (json.containsKey("vehicle")) {
      Map<String, dynamic> vehicleMap = json["vehicle"] as Map<String, dynamic>;
      vehicle = Vehicle.fromJson(vehicleMap);
    }
    ParkingSpace? parkingSpace;
    if (json.containsKey("parkingSpace")) {
      Map<String, dynamic> parkingSpaceMap =
          json["parkingSpace"] as Map<String, dynamic>;
      parkingSpace = ParkingSpace.fromJson(parkingSpaceMap);
    }

    return Parking(
      id: json["id"] as String,
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: json["startTime"] as DateTime,
      endTime: json["endTime"] as DateTime?,
    );
  }

  final Vehicle? vehicle;
  final ParkingSpace? parkingSpace;
  final DateTime startTime;
  final DateTime? endTime;

  Parking copyWith({
    String? id,
    Vehicle? vehicle,
    ParkingSpace? parkingSpace,
    DateTime? startTime,
    DateTime? endTime,
    bool setVehicleToNull = false,
    bool setParkingSpaceToNull = false,
  }) {
    return Parking(
      id: id ?? this.id,
      vehicle: setVehicleToNull ? null : vehicle ?? this.vehicle,
      parkingSpace:
          setParkingSpaceToNull ? null : parkingSpace ?? this.parkingSpace,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  String toString() {
    return """Parking(
      vehicle: $vehicle,
      parkingSpace: $parkingSpace,
      startTime: $startTime,
      endTime: $endTime,\n  )""";
  }

  @override
  bool isValid() {
    if (endTime != null) {
      return endTime!.isAfter(startTime);
    }

    return true;
  }

  double parkingCosts() {
    // TODO: modify price based on time of day?
    if (parkingSpace == null) {
      return 0;
    }

    DateTime end = endTime != null ? endTime! : DateTime.now();
    if (startTime.isAfter(end)) {
      return 0;
    }

    int elapsedHours = end.difference(startTime).inHours;
    double totalCost = parkingSpace!.pricePerHour * elapsedHours;

    return totalCost > 0 ? totalCost : 0;
  }

  // region Serializable

  @override
  BaseModel fromJson(Map<String, dynamic> json) {
    Vehicle? vehicle;
    if (json.containsKey("vehicle")) {
      Map<String, dynamic> vehicleMap = json["vehicle"] as Map<String, dynamic>;
      vehicle = Vehicle.fromJson(vehicleMap);
    }
    ParkingSpace? parkingSpace;
    if (json.containsKey("parkingSpace")) {
      Map<String, dynamic> parkingSpaceMap =
          json["parkingSpace"] as Map<String, dynamic>;
      parkingSpace = ParkingSpace.fromJson(parkingSpaceMap);
    }

    return Parking(
      id: json["id"] as String,
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: json["startTime"] as DateTime,
      endTime: json["endTime"] as DateTime?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicle": vehicle,
      "parkingSpace": parkingSpace,
      "startTime": startTime,
      "endTime": endTime,
    };
  }

// endregion
}
