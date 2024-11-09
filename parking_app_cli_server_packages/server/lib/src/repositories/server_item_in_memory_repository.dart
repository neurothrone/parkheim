import 'package:shared/shared.dart';
import '../entities/person_entity.dart';

class ServerItemInMemoryRepository implements Repository<PersonEntity, String> {
  final List<PersonEntity> _items = [];

  @override
  Future<Result<PersonEntity, String>> create(PersonEntity item) async {
    _items.add(item);
    return Result.success(value: item);
  }

  @override
  Future<Result<List<PersonEntity>, String>> getAll() async => Future.value(
        Result.success(
          value: List.unmodifiable(_items),
        ),
      );

  @override
  Future<Result<PersonEntity?, String>> getById(int id) async => Future.value(
        Result.success(
          value: _items.where((item) => item.id == id).firstOrNull,
        ),
      );

  @override
  Future<Result<PersonEntity, String>> update(int id, PersonEntity item) async {
    int index = _items.indexWhere((item) => item.id == item.id);

    if (index == -1) {
      return Result.failure(
          error: "⚠️ -> Update failed. Item by id: $id not found.");
    }

    _items[index] = item;
    return Result.success(value: item);
  }

  @override
  Future<Result<PersonEntity, String>> delete(int id) async {
    int index = _items.indexWhere((item) => item.id == id);

    if (index == -1) {
      return Result.failure(
          error: "⚠️ -> Delete failed. Item by id: $id not found.");
    }

    final item = _items[index];
    _items.removeAt(index);

    return Result.success(value: item);
  }

  @override
  Future<Result<bool, String>> exists(int id) async {
    if (id < 0) {
      return Result.failure(error: "⚠️ -> Provided ID was negative. Id: $id.");
    }

    return Result.success(
      value: _items.where((item) => item.id == id).firstOrNull != null,
    );
  }
}
