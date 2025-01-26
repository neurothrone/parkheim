import '../enums/vehicle_type.dart';
import '../utils/validation_helper.dart';
import 'base_model.dart';
import 'person.dart';

class Vehicle extends BaseModel {
  Vehicle({
    required super.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> map) {
    Person? owner;
    if (map.containsKey("owner") && map["owner"] != null) {
      Map<String, dynamic> personMap = map["owner"] as Map<String, dynamic>;
      owner = Person.fromJson(personMap);
    }

    return Vehicle(
      id: map.containsKey("id") ? map["id"] as String : null,
      registrationNumber: map.containsKey("registrationNumber")
          ? map["registrationNumber"] as String
          : "",
      vehicleType: map.containsKey("vehicleTypeIndex")
          ? VehicleType.fromIndex(map["vehicleTypeIndex"] as int)
          : VehicleType.unknown,
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
  List<Object?> get props => [id, registrationNumber, vehicleType, owner];

  @override
  String toString() {
    return """Vehicle(
      registrationNumber: $registrationNumber,
      vehicleType: ${vehicleType.name},
      owner: ${owner ?? 'None'},)""";
  }

  @override
  bool isValid() {
    return ValidationHelper.isValidRegistrationNumber(registrationNumber);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "registrationNumber": registrationNumber,
      "vehicleTypeIndex": vehicleType.index,
      "owner": owner?.toJson(),
    };
  }
}
