import 'base_model.dart';
import 'parking_space.dart';
import 'vehicle.dart';

class Parking extends BaseModel {
  Parking({
    required super.id,
    required this.vehicle,
    required this.parkingSpace,
    required this.startTime,
    required this.endTime,
  });

  factory Parking.fromJson(Map<String, dynamic> map) {
    Vehicle? vehicle;
    if (map.containsKey("vehicle") && map["vehicle"] != null) {
      Map<String, dynamic> vehicleMap = map["vehicle"] as Map<String, dynamic>;
      vehicle = Vehicle.fromJson(vehicleMap);
    }
    ParkingSpace? parkingSpace;
    if (map.containsKey("parkingSpace") && map["parkingSpace"] != null) {
      Map<String, dynamic> parkingSpaceMap =
          map["parkingSpace"] as Map<String, dynamic>;
      parkingSpace = ParkingSpace.fromJson(parkingSpaceMap);
    }

    return Parking(
      id: map.containsKey("id") ? map["id"] as String : null,
      vehicle: vehicle,
      parkingSpace: parkingSpace,
      startTime: map.containsKey("startTime")
          ? DateTime.tryParse(map["startTime"] as String) ?? DateTime.now()
          : DateTime.now(),
      endTime: map.containsKey("endTime")
          ? DateTime.tryParse(map["endTime"] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  final Vehicle? vehicle;
  final ParkingSpace? parkingSpace;
  final DateTime startTime;
  final DateTime endTime;

  bool get isActive => DateTime.now().isBefore(endTime);

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
  List<Object?> get props => [id, vehicle, parkingSpace, startTime, endTime];

  @override
  String toString() {
    return """Parking(
      vehicle: $vehicle,
      parkingSpace: $parkingSpace,
      startTime: $startTime,
      endTime: $endTime,)""";
  }

  @override
  bool isValid() {
    return endTime.isAfter(startTime);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicle": vehicle?.toJson(),
      "parkingSpace": parkingSpace?.toJson(),
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
    };
  }

  double parkingCosts() {
    if (parkingSpace == null) {
      return 0;
    }

    if (startTime.isAfter(endTime)) {
      return 0;
    }

    int elapsedHours = endTime.difference(startTime).inHours;
    if (elapsedHours == 0) {
      return parkingSpace!.pricePerHour;
    }
    double totalCost = parkingSpace!.pricePerHour * elapsedHours;

    return totalCost > 0 ? totalCost : 0;
  }
}
