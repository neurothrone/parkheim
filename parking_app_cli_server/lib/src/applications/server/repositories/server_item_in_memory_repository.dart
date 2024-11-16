import '../../../libraries/core/interfaces/repository.dart';
import '../entities/person_entity.dart';

class ServerItemInMemoryRepository implements Repository<PersonEntity> {
  final List<PersonEntity> _items = [];

  @override
  Future<PersonEntity> create(PersonEntity item) async {
    _items.add(item);
    return Future.value(item);
  }

  @override
  Future<List<PersonEntity>> getAll() async => Future.value(
        List.unmodifiable(_items),
      );

  @override
  Future<PersonEntity?> getById(int id) async => Future.value(
        _items.where((item) => item.id == id).firstOrNull,
      );

  @override
  Future<PersonEntity> update(int id, PersonEntity item) async {
    int index = _items.indexWhere((item) => item.id == item.id);

    if (index == -1) {
      throw Exception("⚠️ -> Update failed. Item by id: $id not found.");
    }

    _items[index] = item;
    return Future.value(item);
  }

  @override
  Future<PersonEntity> delete(int id) async {
    int index = _items.indexWhere((item) => item.id == id);

    if (index == -1) {
      throw Exception("⚠️ -> Delete failed. Item by id: $id not found.");
    }

    final item = _items[index];
    _items.removeAt(index);
    return Future.value(item);
  }

  @override
  Future<bool> exists(int id) => Future.value(
        _items.where((item) => item.id == id).firstOrNull != null,
      );
}
