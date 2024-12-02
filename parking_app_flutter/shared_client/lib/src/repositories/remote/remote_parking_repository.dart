import 'package:collection/collection.dart';

import 'package:shared/shared.dart';

import '../../../shared_client.dart';

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
            .where((Parking parking) => parking.endTime == null)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<int> getActiveParkingsCount() async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) =>
          parkings.where((Parking parking) => parking.endTime == null).length,
      failure: (error) => 0,
    );
  }

  Future<double> getTotalRevenueFromParkings() async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings.fold(0, (previousValue, parking) {
          return (previousValue as double) + parking.parkingCosts();
        });
      },
      failure: (error) => 0,
    );
  }

  Future<List<ParkingSpace>> getMostPopularParkingSpaces({
    int limit = 5,
  }) async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        final parkingSpaces = parkings
            .where((Parking parking) =>
                parking.parkingSpace != null && parking.endTime != null)
            .map((Parking parking) => parking.parkingSpace!)
            .toList();

        final grouped = groupBy(parkingSpaces, (ParkingSpace parkingSpace) {
          return parkingSpace.id;
        });

        final sorted = grouped.entries.toList()
          ..sort((a, b) => b.value.length.compareTo(a.value.length));

        return sorted.map((e) => e.value.first).take(limit).toList();
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<List<Parking>> findAllParkingsSortedByStartTime() async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings.toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
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
        // How to order by startTime?
        // Order by startTime

        return parkings
            .where((Parking parking) =>
                parking.vehicle?.id == vehicle.id &&
                parking.parkingSpace != null &&
                parking.endTime == null)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<List<Parking>> findActiveParkingsForOwner(Person owner) async {
    final vehicleResults =
        await RemoteVehicleRepository.instance.findVehiclesByOwner(owner);

    final vehicles = vehicleResults.when(
      success: (vehicles) => vehicles,
      failure: (_) => [],
    );

    final parkings = await getAll();
    return parkings.when(
      success: (parkings) {
        return parkings
            .where((parking) =>
                parking.vehicle != null &&
                vehicles.any((vehicle) => vehicle.id == parking.vehicle!.id) &&
                parking.endTime == null)
            .toList();
      },
      failure: (_) => [],
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

  Future<List<Parking>> findFinishedParkingsForOwner(
    Person owner,
  ) async {
    final vehicleResults =
        await RemoteVehicleRepository.instance.findVehiclesByOwner(owner);

    final vehicles = vehicleResults.when(
      success: (vehicles) => vehicles,
      failure: (_) => [],
    );

    final parkings = await getAll();
    return parkings.when(
      success: (parkings) {
        return parkings
            .where((parking) =>
                parking.vehicle != null &&
                vehicles.any((vehicle) => vehicle.id == parking.vehicle!.id) &&
                parking.endTime != null)
            .toList();
      },
      failure: (_) => [],
    );
  }

  Future<List<Parking>> getHistoryForParkingSpace(ParkingSpace space) async {
    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings
            .where((Parking parking) =>
                parking.parkingSpace?.id == space.id)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));
      },
      failure: (error) {
        return [];
      },
    );
  }

  Future<List<Parking>> searchParkings(String searchText) async {
    if (searchText.isEmpty) {
      return [];
    }

    final result = await getAll();
    return result.when(
      success: (List<Parking> parkings) {
        return parkings
            .where((Parking parking) =>
                parking.parkingSpace != null &&
                parking.parkingSpace!.address.contains(searchText))
            .toList();
      },
      failure: (error) {
        return [];
      },
    );
  }
}
