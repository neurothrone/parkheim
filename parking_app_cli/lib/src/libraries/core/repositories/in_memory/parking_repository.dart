import '../../models/parking.dart';
import '../../models/parking_space.dart';
import '../../models/vehicle.dart';
import 'base_in_memory_repository.dart';

class ParkingRepository extends BaseInMemoryRepository<Parking> {
  ParkingRepository._internal();

  static final _instance = ParkingRepository._internal();

  static ParkingRepository get instance => _instance;

  Future<List<ParkingSpace>> findParkingSpacesByVehicle(Vehicle vehicle) async {
    final parkings = await getAll();
    return parkings
        .where((Parking parking) =>
            parking.vehicle?.id == vehicle.id && parking.parkingSpace != null)
        .map((Parking parking) => parking.parkingSpace!)
        .toList();
  }
}
