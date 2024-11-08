import '../../../libraries/core/interfaces/repository.dart';
import '../_internal/objectbox.g.dart';
import '../data/object_box_store.dart';

class ServerItemRepository<T> implements Repository<T> {
  final Store store = ObjectBoxStore.instance.store;

  @override
  Future<T> create(T item) async {
    final box = store.box<T>();
    return await box.putAndGetAsync(item);
  }

  @override
  Future<List<T>> getAll() async {
    final box = store.box<T>();
    return await box.getAllAsync();
  }

  @override
  Future<T?> getById(int id) async {
    final box = store.box<T>();
    return await box.getAsync(id);
  }

  @override
  Future<T> update(int id, T item) async {
    final box = store.box<T>();

    if (!await exists(id)) {
      throw Exception("⚠️ -> Update failed. Item by id: $id not found.");
    }

    return await box.putAndGetAsync(item);
  }

  @override
  Future<T> delete(int id) async {
    final box = store.box<T>();

    final T? item = await box.getAsync(id);
    if (item == null) {
      throw Exception("⚠️ -> Delete failed. Item by id: $id not found.");
    }

    await box.removeAsync(id);
    return item;
  }

  @override
  Future<bool> exists(int id) async {
    final box = store.box<T>();
    return await box.getAsync(id) != null;
  }
}
