import 'package:shared/shared.dart';

import '../../shared_client_firebase.dart';

class FirebaseParkingSpaceRepository
    extends BaseFirebaseRepository<ParkingSpace, String> {
  FirebaseParkingSpaceRepository({
    required FirebaseParkingRepository parkingRepository,
  })  : _parkingRepository = parkingRepository,
        super(
          collection: ModelType.parkingSpace.resource,
          fromJson: ParkingSpace.fromJson,
        );

  final FirebaseParkingRepository _parkingRepository;

  Future<List<ParkingSpace>> findAvailableSpaces() async {
    final parkingsResult = await _parkingRepository.getAll();
    final List<Parking> parkings = parkingsResult.when(
      success: (List<Parking> parkings) => parkings,
      failure: (_) => [],
    );

    final unavailableSpaces = parkings
        .where((Parking parking) =>
            parking.parkingSpace != null && parking.endTime == null)
        .map((Parking parking) => parking.parkingSpace!)
        .toList();

    final spacesResult = await getAll();
    final List<ParkingSpace> spaces = spacesResult.when(
      success: (List<ParkingSpace> spaces) => spaces,
      failure: (_) => [],
    );

    return spaces
        .where((ParkingSpace space) => !unavailableSpaces.contains(space))
        .toList();
  }
}
