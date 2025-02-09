import 'dart:async';

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

    final Set<ParkingSpace> unavailableSpaces = parkings
        .where((parking) => parking.isActive && parking.parkingSpace != null)
        .map((parking) => parking.parkingSpace!)
        .toSet();

    final spacesResult = await getAll();
    final List<ParkingSpace> spaces = spacesResult.when(
      success: (List<ParkingSpace> spaces) => spaces,
      failure: (_) => [],
    );

    final availableSpaces =
        spaces.where((space) => !unavailableSpaces.contains(space)).toList();
    return availableSpaces;
  }

  Stream<List<ParkingSpace>> getAllSpacesStream() {
    return FirebaseFirestore.instance.collection(collection).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => ParkingSpace.fromJson(doc.data()))
            .toList());
  }

  // Stream<List<ParkingSpace>> getAvailableSpacesStream() async* {
  //   final unavailableSpacesStream = FirebaseFirestore.instance
  //       .collection("parkings")
  //       .where("endTime", isNull: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => doc.data()["parkingSpace"]["id"] as String)
  //           .toList());
  //
  //   final parkingSpacesStream = FirebaseFirestore.instance
  //       .collection("parking-spaces")
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => ParkingSpace.fromJson(doc.data()))
  //           .toList());
  //
  //   yield* StreamZip([parkingSpacesStream, unavailableSpacesStream])
  //       .map((values) {
  //     final parkingSpaces = values[0] as List<ParkingSpace>;
  //     final unavailableIds = values[1] as List<String>;
  //     return parkingSpaces
  //         .where((space) => !unavailableIds.contains(space.id))
  //         .toList();
  //   });
  // }

// Stream<List<ParkingSpace>> getAvailableSpacesStream() {
//   return db.collection(collection).snapshots().asyncMap(
//     (snapshot) async {
//       final parkingsResult = await _parkingRepository.getAll();
//       final List<Parking> parkings = parkingsResult.when(
//         success: (List<Parking> parkings) => parkings,
//         failure: (_) => [],
//       );
//
//       final unavailableSpaces = parkings
//           .where((Parking parking) =>
//               parking.parkingSpace != null && parking.endTime == null)
//           .map((Parking parking) => parking.parkingSpace!)
//           .toList();
//
//       final spaces = snapshot.docs
//           .map((doc) => ParkingSpace.fromJson(doc.data()))
//           .where((space) => !unavailableSpaces.contains(space))
//           .toList();
//
//       return spaces;
//     },
//   );
// }

  Stream<List<ParkingSpace>> getAvailableSpacesStream() async* {
    final parkingsSnapshot = _parkingRepository.getAllStream();
    await for (final parkings in parkingsSnapshot) {
      final Set<ParkingSpace> unavailableSpaces = parkings
          .where((Parking parking) =>
              parking.isActive && parking.parkingSpace != null)
          .map((Parking parking) => parking.parkingSpace!)
          .toSet();

      final spacesSnapshot = db.collection(collection).snapshots();
      await for (final snapshot in spacesSnapshot) {
        final spaces = snapshot.docs
            .map((doc) => ParkingSpace.fromJson(doc.data()))
            .where((space) => !unavailableSpaces.contains(space))
            .toList();
        yield spaces;
      }
    }
  }
}
