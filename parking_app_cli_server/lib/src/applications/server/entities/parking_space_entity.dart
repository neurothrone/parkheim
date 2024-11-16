import 'package:objectbox/objectbox.dart';

import '../../../libraries/core/interfaces/serializable.dart';

@Entity()
class ParkingSpaceEntity implements Serializable {
  ParkingSpaceEntity({
    this.id = 0,
    required this.address,
    required this.pricePerHour,
  });

  factory ParkingSpaceEntity.fromJson(Map<String, dynamic> map) {
    return ParkingSpaceEntity(
      id: map.containsKey("id") ? map["id"] as int : 0,
      address: map.containsKey("address") ? map["address"] as String : "",
      pricePerHour:
          map.containsKey("pricePerHour") ? map["pricePerHour"] as double : 0.0,
    );
  }

  @Id()
  int id;
  final String address;
  final double pricePerHour;

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "pricePerHour": pricePerHour,
    };
  }
}
