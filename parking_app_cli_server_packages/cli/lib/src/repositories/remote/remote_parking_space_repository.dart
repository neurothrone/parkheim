import 'package:shared/shared.dart';
import 'base_remote_repository.dart';

class RemoteParkingSpaceRepository extends BaseRemoteRepository<ParkingSpace> {
  RemoteParkingSpaceRepository._internal()
      : super(
          resource: ModelType.parkingSpace.resource,
          fromJson: ParkingSpace.fromJson,
        );

  static final _instance = RemoteParkingSpaceRepository._internal();

  static RemoteParkingSpaceRepository get instance => _instance;
}
