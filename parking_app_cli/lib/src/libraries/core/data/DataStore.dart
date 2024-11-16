// TODO: Store Person, Vehicle, Parking,Parking Spaces to map
class DataStore {
  DataStore._();

  static final _instance = DataStore._();

  static DataStore get instance => _instance;
}
