import 'package:shared/shared.dart';
import '../_internal/objectbox.g.dart';
import '../data/object_box_store.dart';

class ServerItemRepository<T> implements Repository<T, String> {
  final Store store = ObjectBoxStore.instance.store;

  @override
  Future<Result<T, String>> create(T item) async {
    try {
      final box = store.box<T>();
      return Result.success(value: await box.putAndGetAsync(item));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<List<T>, String>> getAll() async {
    try {
      final box = store.box<T>();
      final List<T> items = await box.getAllAsync();
      return Result.success(value: items);
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T?, String>> getById(int id) async {
    try {
      final box = store.box<T>();
      return Result.success(value: await box.getAsync(id));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T, String>> update(int id, T item) async {
    var result = await exists(id);
    if (result is Failure) {
      return Result.failure(
          error: "⚠️ -> Update failed. Item by id: $id not found.");
    }

    try {
      final box = store.box<T>();
      return Result.success(value: await box.putAndGetAsync(item));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T, String>> delete(int id) async {
    try {
      final box = store.box<T>();

      final T? item = await box.getAsync(id);
      if (item == null) {
        return Result.failure(
            error: "⚠️ -> Delete failed. Item by id: $id not found.");
      }

      await box.removeAsync(id);
      return Result.success(value: item);
    } catch (e) {
      return Result.failure(
          error: "⚠️ -> Failed to delete item by id: $id. ${e.toString()}");
    }
  }

  @override
  Future<Result<bool, String>> exists(int id) async {
    try {
      final box = store.box<T>();
      return Result.success(value: await box.getAsync(id) != null);
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }
}
