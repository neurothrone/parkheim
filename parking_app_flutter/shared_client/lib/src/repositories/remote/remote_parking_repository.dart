import 'package:shared/shared.dart';
import 'base_remote_repository.dart';

class RemoteParkingRepository extends BaseRemoteRepository<Parking, String> {
  RemoteParkingRepository._internal()
      : super(
          resource: ModelType.parking.resource,
          fromJson: Parking.fromJson,
        );

  static final _instance = RemoteParkingRepository._internal();

  static RemoteParkingRepository get instance => _instance;

  Future<List<ParkingSpace>> findParkingSpacesByVehicle(Vehicle vehicle) async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings
            .where((Parking parking) =>
                parking.vehicle?.id == vehicle.id &&
                parking.parkingSpace != null)
            .map((Parking parking) => parking.parkingSpace!)
            .toList();
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<List<Parking>> findActiveParkings() async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings
            .where((Parking parking) => parking.endTime != null)
            .toList();
      },
      failure: (error) {
        return [];
      },
    );
  }
}
