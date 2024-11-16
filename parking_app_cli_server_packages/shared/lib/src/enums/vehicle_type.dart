enum VehicleType {
  car,
  motorcycle,
  unknown;

  static VehicleType fromString(String s) => switch (s) {
        "1" => VehicleType.car,
        "2" => VehicleType.motorcycle,
        _ => VehicleType.unknown,
      };

  static VehicleType fromIndex(int index) => switch (index) {
        0 => VehicleType.car,
        1 => VehicleType.motorcycle,
        _ => VehicleType.unknown,
      };
}
