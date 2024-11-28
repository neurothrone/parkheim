import 'package:shared/shared.dart';
import 'base_remote_repository.dart';

class RemoteVehicleRepository extends BaseRemoteRepository<Vehicle, String> {
  RemoteVehicleRepository._internal()
      : super(
          resource: ModelType.vehicle.resource,
          fromJson: Vehicle.fromJson,
        );

  static final _instance = RemoteVehicleRepository._internal();

  static RemoteVehicleRepository get instance => _instance;

  Future<List<Vehicle>> findVehiclesByOwner(Person owner) async {
    final result = await getAll();
    return result.when(
      success: (List<Vehicle> vehicles) {
        return vehicles
            .where((Vehicle vehicle) => vehicle.owner?.id == owner.id)
            .toList();
      },
      failure: (error) {
        return [];
      },
    );
  }

// Future<void> removeOwnerFromVehicles(Person person) async {
//   final result = await getAll();
//   return result.when(
//     success: (List<Vehicle> vehicles) async {
//       for (final vehicle in vehicles) {
//         if (vehicle.owner == null || vehicle.owner?.id != person.id) {
//           continue;
//         }
//
//         await update(
//           vehicle.id,
//           vehicle.copyWith(
//             owner: null,
//             setOwnerToNull: true,
//           ),
//         );
//       }
//     },
//     failure: (_) {},
//   );
// }
}
