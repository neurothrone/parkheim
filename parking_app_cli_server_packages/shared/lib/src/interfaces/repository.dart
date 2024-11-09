import '../utils/result.dart';

abstract interface class Repository<T, E> {
  Future<Result<T, E>> create(T item);

  Future<Result<List<T>, E>> getAll();

  Future<Result<T?, E>> getById(int id);

  Future<Result<T, E>> update(int id, T item);

  Future<Result<T, E>> delete(int id);

  Future<Result<bool, E>> exists(int id);
}
