import '../../models/person.dart';
import '../../models/vehicle.dart';
import 'base_in_memory_repository.dart';

class VehicleRepository extends BaseInMemoryRepository<Vehicle> {
  VehicleRepository._internal();

  static final _instance = VehicleRepository._internal();

  static VehicleRepository get instance => _instance;

  Future<List<Vehicle>> findVehiclesByOwner(Person owner) async {
    final vehicles = await getAll();
    return vehicles
        .where((Vehicle vehicle) => vehicle.owner?.id == owner.id)
        .toList();
  }

  Future<void> removeOwnerFromVehicles(Person person) async {
    final vehicles = await getAll();

    for (final vehicle in vehicles) {
      if (vehicle.owner == null || vehicle.owner?.id != person.id) {
        continue;
      }

      await update(
        vehicle.copyWith(
          owner: null,
          setOwnerToNull: true,
        ),
      );
    }
  }
}
