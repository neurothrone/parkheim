# Parking App CLI

### Function to calculate cost for a Parking based on time and price per hour

- `double parkingCosts()`:
    - Found at: `src/core/models/parking.dart`.

### Search functionality

- `Future<List<ParkingSpace>> findParkingSpacesByVehicle(Vehicle vehicle)`:
    - Found at: `src/core/repositories/parking_repository.dart`.
    - Used by `BaseManager` at `src/domain/managers/base_manager.dart`.
- `Future<List<Vehicle>> findVehiclesByOwner(Person owner)`:
    - Found at: `src/core/repositories/vehicle_repository.dart`.
    - Used by `BaseManager` at `src/domain/managers/base_manager.dart`.

### Repositories (Singleton)

- Can be found at `src/core/repositories`
