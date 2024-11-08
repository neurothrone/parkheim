import 'package:objectbox/objectbox.dart';

import '../../../libraries/core/interfaces/serializable.dart';
import 'parking_space_entity.dart';
import 'vehicle_entity.dart';

@Entity()
class ParkingEntity implements Serializable {
  ParkingEntity({
    this.id = 0,
    VehicleEntity? vehicle,
    ParkingSpaceEntity? parkingSpace,
    required this.startTime,
    required this.endTime,
  })  : vehicle = ToOne<VehicleEntity>(),
        parkingSpace = ToOne<ParkingSpaceEntity>() {
    this.vehicle.target = vehicle;
    this.parkingSpace.target = parkingSpace;
  }

  factory ParkingEntity.fromJson(Map<String, dynamic> map) {
    final parking = ParkingEntity(
      id: map.containsKey("id") ? map["id"] as int : 0,
      startTime: map.containsKey("startTime")
          ? DateTime.tryParse(map["startTime"] as String) ?? DateTime.now()
          : DateTime.now(),
      endTime: map.containsKey("endTime") && map["endTime"] != null
          ? DateTime.tryParse(map["endTime"] as String)
          : null,
    );

    if (map.containsKey("vehicle") && map["vehicle"] != null) {
      Map<String, dynamic> vehicleMap = map["vehicle"] as Map<String, dynamic>;
      parking.vehicle.target = VehicleEntity.fromJson(vehicleMap);
    }

    if (map.containsKey("parkingSpace") && map["parkingSpace"] != null) {
      Map<String, dynamic> parkingSpaceMap =
          map["parkingSpace"] as Map<String, dynamic>;
      parking.parkingSpace.target =
          ParkingSpaceEntity.fromJson(parkingSpaceMap);
    }

    return parking;
  }

  @Id()
  int id;
  final ToOne<VehicleEntity> vehicle;
  final ToOne<ParkingSpaceEntity> parkingSpace;
  @Property(type: PropertyType.date)
  final DateTime startTime;
  @Property(type: PropertyType.date)
  final DateTime? endTime;

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "vehicle": vehicle.target?.toJson(),
      "parkingSpace": parkingSpace.target?.toJson(),
      "startTime": startTime.toIso8601String(),
      "endTime": endTime?.toIso8601String(),
    };
  }
}
