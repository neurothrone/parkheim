import '../enums/vehicle_type.dart';
import '../interfaces/serializable.dart';
import '../utils/validation_helper.dart';
import 'base_model.dart';
import 'person.dart';

class Vehicle extends BaseModel {
  Vehicle({
    super.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    Person? owner;
    if (json.containsKey("owner")) {
      Map<String, dynamic> personMap = json["owner"] as Map<String, dynamic>;
      owner = Person.fromJson(personMap);
    }

    return Vehicle(
      id: json.containsKey("id") ? json["id"] as String : "",
      registrationNumber: json.containsKey("registrationNumber")
          ? json["registrationNumber"] as String
          : "",
      vehicleType: json["vehicleType"] as VehicleType,
      owner: owner,
    );
  }

  final String registrationNumber;
  final VehicleType vehicleType;
  final Person? owner;

  Vehicle copyWith({
    String? id,
    String? registrationNumber,
    VehicleType? vehicleType,
    Person? owner,
    bool setOwnerToNull = false,
  }) {
    return Vehicle(
      id: id ?? this.id,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      owner: setOwnerToNull ? null : owner ?? this.owner,
    );
  }

  @override
  String toString() {
    return """Vehicle(
      registrationNumber: $registrationNumber,
      vehicleType: ${vehicleType.name},
      owner: ${owner ?? 'None'},\n  )""";
  }

  @override
  bool isValid() {
    return ValidationHelper.isValidRegistrationNumber(registrationNumber);
  }

  // region Serializable

  @override
  Serializable fromJson(Map<String, dynamic> json) {
    Person? owner;
    if (json.containsKey("owner")) {
      Map<String, dynamic> personMap = json["owner"] as Map<String, dynamic>;
      owner = Person.fromJson(personMap);
    }

    return Vehicle(
      id: json.containsKey("id") ? json["id"] as String : "",
      registrationNumber: json.containsKey("registrationNumber")
          ? json["registrationNumber"] as String
          : "",
      vehicleType: json["vehicleType"] as VehicleType,
      owner: owner,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "registrationNumber": registrationNumber,
      "vehicleType": vehicleType,
      "owner": owner,
    };
  }

// endregion
}
