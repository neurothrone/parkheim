import 'package:shared/shared.dart';
import '../../../shared_client.dart';
import 'base_remote_repository.dart';

class RemoteParkingSpaceRepository
    extends BaseRemoteRepository<ParkingSpace, String> {
  RemoteParkingSpaceRepository._internal()
      : super(
          resource: ModelType.parkingSpace.resource,
          fromJson: ParkingSpace.fromJson,
        );

  static final _instance = RemoteParkingSpaceRepository._internal();

  static RemoteParkingSpaceRepository get instance => _instance;

  Future<List<ParkingSpace>> findAvailableSpaces() async {
    final parkingsResult = await RemoteParkingRepository.instance.getAll();
    final List<Parking> parkings = parkingsResult.when(
      success: (List<Parking> parkings) => parkings,
      failure: (_) => [],
    );

    final unavailableSpaces = parkings
        .where((Parking parking) => parking.parkingSpace != null)
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
