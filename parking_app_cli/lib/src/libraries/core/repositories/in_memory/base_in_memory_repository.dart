import '../../models/base_model.dart';
import '../../interfaces/repository.dart';

abstract class BaseInMemoryRepository<T extends BaseModel>
    implements Repository<T> {
  final List<T> _items = [];

  @override
  Future<void> create(T item) {
    _items.add(item);
    return Future.value(null);
  }

  @override
  Future<List<T>> getAll() async {
    return Future.value(List.unmodifiable(_items));
  }

  @override
  Future<T?> getById(String id) {
    return Future.value(_items.where((item) => item.id == id).firstOrNull);
  }

  @override
  Future<bool> update(T updatedItem) {
    int index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      return Future.value(true);
    }

    return Future.value(false);
  }

  @override
  Future<bool> delete(String id) {
    final itemToDelete = _items.where((item) => item.id == id).firstOrNull;
    if (itemToDelete == null) return Future.value(false);
    return Future.value(_items.remove(itemToDelete));
  }
}
