enum VehicleType {
  car,
  motorcycle,
  unknown;

  static VehicleType fromString(String s) => switch (s) {
        "1" => VehicleType.car,
        "2" => VehicleType.motorcycle,
        _ => VehicleType.unknown,
      };
}
