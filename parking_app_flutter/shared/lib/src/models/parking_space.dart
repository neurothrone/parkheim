import 'base_model.dart';

class ParkingSpace extends BaseModel {
  ParkingSpace({
    required super.id,
    required this.address,
    required this.pricePerHour,
  });

  factory ParkingSpace.fromJson(Map<String, dynamic> map) {
    return ParkingSpace(
      id: map.containsKey("id") ? map["id"] as int : -1,
      address: map.containsKey("address") ? map["address"] as String : "",
      pricePerHour: map.containsKey("pricePerHour")
          ? map["pricePerHour"] as double
          : 0.0,
    );
  }

  final String address;
  final double pricePerHour;

  ParkingSpace copyWith({
    int? id,
    String? address,
    double? pricePerHour,
  }) {
    return ParkingSpace(
      id: id ?? this.id,
      address: address ?? this.address,
      pricePerHour: pricePerHour ?? this.pricePerHour,
    );
  }

  @override
  String toString() {
    return "ParkingSpace(address: $address, pricePerHour: $pricePerHour)";
  }

  @override
  bool isValid() {
    return address.isNotEmpty && pricePerHour >= 0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "pricePerHour": pricePerHour,
    };
  }
}
