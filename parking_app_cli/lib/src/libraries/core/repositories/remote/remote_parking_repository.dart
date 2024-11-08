import '../../../../cli/enums/model_type.dart';
import '../../models/parking.dart';
import '../../models/parking_space.dart';
import '../../models/vehicle.dart';
import 'base_remote_repository.dart';

class RemoteParkingRepository extends BaseRemoteRepository<Parking> {
  RemoteParkingRepository._internal() : super(fromJson: Parking.fromJson);

  static final _instance = RemoteParkingRepository._internal();

  static RemoteParkingRepository get instance => _instance;

  @override
  ModelType get modelType => ModelType.parking;

  Future<List<ParkingSpace>> findParkingSpacesByVehicle(Vehicle vehicle) async {
    final parkings = await getAll();
    return parkings
        .where((Parking parking) =>
            parking.vehicle?.id == vehicle.id && parking.parkingSpace != null)
        .map((Parking parking) => parking.parkingSpace!)
        .toList();
  }
}
