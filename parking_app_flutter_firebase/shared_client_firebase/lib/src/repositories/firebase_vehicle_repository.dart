// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared/shared.dart';

import 'package:shared_client_firebase/src/repositories/base_firebase_repository.dart';

class FirebaseVehicleRepository
    extends BaseFirebaseRepository<Vehicle, String> {
  FirebaseVehicleRepository()
      : super(
          collection: ModelType.vehicle.resource,
          fromJson: Vehicle.fromJson,
        );

  Future<Result<List<Vehicle>, String>> findVehiclesByOwner(
      Person owner) async {
    final result = await getAll();
    return result.when(
      success: (List<Vehicle> vehicles) {
        return Result.success(
          value: vehicles
              .where((Vehicle vehicle) => vehicle.owner?.id == owner.id)
              .toList(),
        );
      },
      failure: (error) => Result.failure(error: error),
    );
  }

// FirebaseVehicleRepository._internal()
//     : super(
//   collection: ModelType.vehicle.resource,
//   fromJson: Vehicle.fromJson,
// );

// @override
// String get collection => "vehicles";

// final db = FirebaseFirestore.instance;

// @override
// Future<Result<Vehicle, String>> create(Vehicle item) async {
//   try {
//     await db.collection("vehicles").doc(item.id).set(item.toJson());
//     return Result.success(value: item);
//   } catch (e) {
//     return Result.failure(error: e.toString());
//   }
// }
//
// @override
// Future<Result<List<Vehicle>, String>> getAll() async {
//   try {
//     final snapshot = await db.collection("vehicles").get();
//     final vehicles = snapshot.docs
//         .map((doc) => Vehicle.fromJson(doc.data()))
//         .toList(growable: false);
//     return Result.success(value: List.unmodifiable(vehicles));
//   } catch (e) {
//     return Result.failure(error: e.toString());
//   }
// }
//
// @override
// Future<Result<Vehicle?, String>> getById(String id) async {
//   try {
//     final snapshot = await db.collection("vehicles").doc(id).get();
//     final json = snapshot.data();
//     if (json == null) {
//       return Result.success(value: null);
//     }
//     return Result.success(value: Vehicle.fromJson(json));
//   } catch (e) {
//     return Result.failure(error: e.toString());
//   }
// }
//
// @override
// Future<Result<Vehicle, String>> update(String id, Vehicle item) async {
//   try {
//     await db.collection("vehicles").doc(item.id).set(item.toJson());
//     // await db.collection("vehicles").doc(item.id).update(item.toJson());
//     return Result.success(value: item);
//   } catch (e) {
//     return Result.failure(error: e.toString());
//   }
// }
//
// @override
// Future<Result<Vehicle, String>> delete(String id) async {
//   Vehicle? vehicle;
//
//   final result = await getById(id);
//   result.when(
//     success: (Vehicle? v) => vehicle = v,
//     failure: (error) => Result.failure(error: error),
//   );
//
//   if (vehicle == null) {
//     return Result.failure(error: "Vehicle not found");
//   }
//
//   try {
//     await db.collection("vehicles").doc(id).delete();
//     return Result.success(value: vehicle!);
//   } catch (e) {
//     return Result.failure(error: e.toString());
//   }
// }
//
// @override
// Future<Result<bool, String>> exists(String id) async {
//   final result = await getById(id);
//   return result.when(
//     success: (Vehicle? vehicle) => Result.success(value: vehicle != null),
//     failure: (error) => Result.failure(error: error),
//   );
// }
}
