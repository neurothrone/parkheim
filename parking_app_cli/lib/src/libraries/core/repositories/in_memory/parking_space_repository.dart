import '../../models/parking_space.dart';
import 'base_in_memory_repository.dart';

class ParkingSpaceRepository extends BaseInMemoryRepository<ParkingSpace> {
  ParkingSpaceRepository._internal();

  static final _instance = ParkingSpaceRepository._internal();

  static ParkingSpaceRepository get instance => _instance;
}
