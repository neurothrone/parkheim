import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream<List<ParkingSpace>> getAllSpacesStream() {
    return FirebaseFirestore.instance.collection(collection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ParkingSpace.fromJson(doc.data()))
            .toList());
  }

  Stream<List<ParkingSpace>> getAllAvailableSpacesStream() async* {
    // Get a stream of all parkings
    final parkingsSnapshot = _parkingRepository.getAllStream();
    await for (final parkings in parkingsSnapshot) {
      // Filter out unavailable parking spaces
      final unavailableSpaces = parkings
          .where((Parking parking) =>
              parking.parkingSpace != null && parking.endTime == null)
          .map((Parking parking) => parking.parkingSpace!)
          .toList();

      // Get a stream of all parking spaces
      final spacesSnapshot = db.collection(collection).snapshots();
      await for (final snapshot in spacesSnapshot) {
        // Remove unavailable spaces from all spaces
        final spaces = snapshot.docs
            .map((doc) => ParkingSpace.fromJson(doc.data()))
            .where((space) => !unavailableSpaces.contains(space))
            .toList();
        yield spaces;
      }
    }
  }
}
