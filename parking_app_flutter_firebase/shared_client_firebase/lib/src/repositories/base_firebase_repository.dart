import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared/shared.dart';

abstract class BaseFirebaseRepository<T extends Serializable, E>
    implements Repository<T, String> {
  BaseFirebaseRepository({
    required String collection,
    required T Function(Map<String, dynamic>) fromJson,
  })  : _collection = collection,
        _fromJson = fromJson;

  final String _collection;
  final T Function(Map<String, dynamic>) _fromJson;

  final db = FirebaseFirestore.instance;

  @override
  Future<Result<T, String>> create(T item) async {
    try {
      final json = item.toJson();
      final result = await db.runTransaction((transaction) async {
        final docRef = db.collection(_collection).doc();
        final updatedJson = {
          ...json,
          "id": docRef.id,
        };
        transaction.set(docRef, updatedJson);
        return updatedJson;
      });
      return Result.success(value: _fromJson(result));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<List<T>, String>> getAll() async {
    try {
      final snapshot = await db.collection(_collection).get();
      final items = snapshot.docs
          .map((doc) => _fromJson(doc.data()))
          .toList(growable: false);
      return Result.success(value: List.unmodifiable(items));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T?, String>> getById(String id) async {
    try {
      final snapshot = await db.collection(_collection).doc(id).get();
      if (!snapshot.exists) {
        return Result.success(value: null);
      }

      final json = snapshot.data();
      if (json == null) {
        return Result.success(value: null);
      }

      return Result.success(value: _fromJson(json));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T, String>> update(String id, T item) async {
    try {
      await db.collection(_collection).doc(id).set(item.toJson());
      // await db.collection(_collection).doc(id).update(item.toJson());
      return Result.success(value: item);
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T, String>> delete(String id) async {
    T? item;

    final result = await getById(id);
    result.when(
      success: (T? i) => item = i,
      failure: (error) => Result.failure(error: error),
    );

    if (item == null) {
      return Result.failure(error: "Item not found");
    }

    try {
      await db.collection(_collection).doc(id).delete();
      return Result.success(value: item!);
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<bool, String>> exists(String id) async {
    final result = await getById(id);
    return result.when(
      success: (T? item) => Result.success(value: item != null),
      failure: (error) => Result.failure(error: error),
    );
  }
}
