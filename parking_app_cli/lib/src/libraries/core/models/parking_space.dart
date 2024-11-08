import '../interfaces/serializable.dart';
import 'base_model.dart';

class ParkingSpace extends BaseModel {
  ParkingSpace({
    super.id,
    required this.address,
    required this.pricePerHour,
  });

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json.containsKey("id") ? json["id"] as String : "",
      address: json.containsKey("address") ? json["address"] as String : "",
      pricePerHour: json.containsKey("pricePerHour")
          ? json["pricePerHour"] as double
          : 0.0,
    );
  }

  final String address;
  final double pricePerHour;

  ParkingSpace copyWith({
    String? id,
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

  // region Serializable

  @override
  Serializable fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json.containsKey("id") ? json["id"] as String : "",
      address: json.containsKey("address") ? json["address"] as String : "",
      pricePerHour: json.containsKey("pricePerHour")
          ? json["pricePerHour"] as double
          : 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "pricePerHour": pricePerHour,
    };
  }

// endregion
}
