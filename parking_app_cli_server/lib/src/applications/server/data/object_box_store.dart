import '../_internal/objectbox.g.dart';

class ObjectBoxStore {
  ObjectBoxStore._internal() {
    _store = openStore(directory: "db");
  }

  late Store _store;

  static final _instance = ObjectBoxStore._internal();

  static ObjectBoxStore get instance => _instance;

  Store get store => _store;
}
