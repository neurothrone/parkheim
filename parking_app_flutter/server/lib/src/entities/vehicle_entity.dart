import 'package:objectbox/objectbox.dart';

import 'package:shared/shared.dart';
import 'person_entity.dart';

@Entity()
class VehicleEntity implements Serializable {
  VehicleEntity({
    this.id = 0,
    required this.registrationNumber,
    required this.vehicleTypeIndex,
    PersonEntity? owner,
  }) : owner = ToOne<PersonEntity>() {
    this.owner.target = owner;
  }

  factory VehicleEntity.fromJson(Map<String, dynamic> map) {
    final vehicle = VehicleEntity(
      id: map.containsKey("id") ? map["id"] as int : 0,
      registrationNumber: map.containsKey("registrationNumber")
          ? map["registrationNumber"] as String
          : "",
      vehicleTypeIndex: map.containsKey("vehicleTypeIndex")
          ? map["vehicleTypeIndex"] as int
          : 0,
    );

    if (map.containsKey("owner")) {
      final personMap = map["owner"] as Map<String, dynamic>;
      vehicle.owner.target = PersonEntity.fromJson(personMap);
    }

    return vehicle;
  }

  @Id()
  int id;
  final String registrationNumber;
  int vehicleTypeIndex;
  final ToOne<PersonEntity> owner;

  @Transient()
  VehicleType get vehicleType => VehicleType.values[vehicleTypeIndex];
  @Transient()
  set vehicleType(VehicleType type) => vehicleTypeIndex = type.index;

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "registrationNumber": registrationNumber,
      "vehicleTypeIndex": vehicleType.index,
      "owner": owner.target?.toJson(),
    };
  }
}
