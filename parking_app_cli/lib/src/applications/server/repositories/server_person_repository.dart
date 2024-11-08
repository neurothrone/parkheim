import '../../../libraries/core/interfaces/repository.dart';
import '../../../libraries/core/models/base_model.dart';

class ServerPersonRepository<T extends BaseModel> implements Repository<T> {
  @override
  Future<T> create(T item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<T>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<T?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<bool> update(T item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
