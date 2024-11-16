import '../../../../cli/enums/model_type.dart';
import '../../models/parking_space.dart';
import 'base_remote_repository.dart';

class RemoteParkingSpaceRepository extends BaseRemoteRepository<ParkingSpace> {
  RemoteParkingSpaceRepository._internal()
      : super(fromJson: ParkingSpace.fromJson);

  static final _instance = RemoteParkingSpaceRepository._internal();

  static RemoteParkingSpaceRepository get instance => _instance;

  @override
  ModelType get modelType => ModelType.parkingSpace;
}
