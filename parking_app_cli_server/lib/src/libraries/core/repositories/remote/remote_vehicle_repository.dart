import '../../enums/model_type.dart';
import '../../models/person.dart';
import '../../models/vehicle.dart';
import 'base_remote_repository.dart';

class RemoteVehicleRepository extends BaseRemoteRepository<Vehicle> {
  RemoteVehicleRepository._internal()
      : super(
          resource: ModelType.vehicle.resource,
          fromJson: Vehicle.fromJson,
        );

  static final _instance = RemoteVehicleRepository._internal();

  static RemoteVehicleRepository get instance => _instance;

  Future<List<Vehicle>> findVehiclesByOwner(Person owner) async {
    final vehicles = await getAll();
    return vehicles
        .where((Vehicle vehicle) => vehicle.owner?.id == owner.id)
        .toList();
  }

// Future<void> removeOwnerFromVehicles(Person person) async {
//   final vehicles = await getAll();
//
//   for (final vehicle in vehicles) {
//     if (vehicle.owner == null || vehicle.owner?.id != person.id) {
//       continue;
//     }
//
//     await update(
//       vehicle.copyWith(
//         owner: null,
//         setOwnerToNull: true,
//       ),
//     );
//   }
// }
}
