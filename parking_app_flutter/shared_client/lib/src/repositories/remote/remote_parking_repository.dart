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

  Future<List<ParkingSpace>> findParkingSpacesForVehicle(
      Vehicle vehicle) async {
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

  Future<List<Parking>> findActiveParkingsForVehicle(Vehicle vehicle) async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings
            .where((Parking parking) =>
                parking.vehicle?.id == vehicle.id &&
                parking.parkingSpace != null &&
                parking.endTime == null)
            .toList();
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<Result<Parking, String>> startParking(
    ParkingSpace parkingSpace,
    Vehicle vehicle,
  ) =>
      create(
        Parking(
          id: 0,
          vehicle: vehicle,
          parkingSpace: parkingSpace,
          startTime: DateTime.now(),
          endTime: null,
        ),
      );

  Future<Result<Parking, String>> endParking(Parking parking) => update(
        parking.id,
        parking.copyWith(endTime: DateTime.now()),
      );

  Future<Result<List<Parking>, String>> findFinishedParkingsForVehicle(
    Vehicle vehicle,
  ) async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return Result.success(
            value: parkings
                .where((Parking parking) =>
                    parking.vehicle?.id == vehicle.id &&
                    parking.endTime != null)
                .toList());
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  }
}
