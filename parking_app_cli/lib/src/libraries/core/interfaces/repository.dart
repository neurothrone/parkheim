abstract interface class Repository<T> {
  Future<void> create(T item);

  Future<List<T>> getAll();

  Future<T?> getById(String id);

  Future<bool> update(T item);

  Future<bool> delete(String id);
}
