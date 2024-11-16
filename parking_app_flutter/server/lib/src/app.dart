import 'dart:io';

import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'entities/parking_entity.dart';
import 'entities/parking_space_entity.dart';
import 'entities/person_entity.dart';
import 'entities/vehicle_entity.dart';
import 'endpoints/server_item_endpoints.dart';
import 'repositories/server_item_repository.dart';

class App {
  App() {
    _personEndpoints = ServerItemEndpoints<PersonEntity, String>(
      repository: ServerItemRepository<PersonEntity>(),
      fromJson: PersonEntity.fromJson,
    );
    _vehicleEndpoints = ServerItemEndpoints<VehicleEntity, String>(
      repository: ServerItemRepository<VehicleEntity>(),
      fromJson: VehicleEntity.fromJson,
    );
    _parkingEndpoints = ServerItemEndpoints<ParkingEntity, String>(
      repository: ServerItemRepository<ParkingEntity>(),
      fromJson: ParkingEntity.fromJson,
    );
    _parkingSpaceEndpoints = ServerItemEndpoints<ParkingSpaceEntity, String>(
      repository: ServerItemRepository<ParkingSpaceEntity>(),
      fromJson: ParkingSpaceEntity.fromJson,
    );

    final personResource = ModelType.person.resource;
    final vehicleResource = ModelType.vehicle.resource;
    final parkingResource = ModelType.parking.resource;
    final parkingSpaceResource = ModelType.parkingSpace.resource;

    // Configure routes.
    _router = Router()
      // Person
      ..post("/$personResource", _personEndpoints.createItemHandler)
      ..get("/$personResource", _personEndpoints.getItemsHandler)
      ..get("/$personResource/<id>", _personEndpoints.getItemByIdHandler)
      ..put("/$personResource/<id>", _personEndpoints.updateItemHandler)
      ..delete("/$personResource/<id>", _personEndpoints.deleteItemHandler)
      // Vehicle
      ..post("/$vehicleResource", _vehicleEndpoints.createItemHandler)
      ..get("/$vehicleResource", _vehicleEndpoints.getItemsHandler)
      ..get("/$vehicleResource/<id>", _vehicleEndpoints.getItemByIdHandler)
      ..put("/$vehicleResource/<id>", _vehicleEndpoints.updateItemHandler)
      ..delete("/$vehicleResource/<id>", _vehicleEndpoints.deleteItemHandler)
      // Parking
      ..post("/$parkingResource", _parkingEndpoints.createItemHandler)
      ..get("/$parkingResource", _parkingEndpoints.getItemsHandler)
      ..get("/$parkingResource/<id>", _parkingEndpoints.getItemByIdHandler)
      ..put("/$parkingResource/<id>", _parkingEndpoints.updateItemHandler)
      ..delete("/$parkingResource/<id>", _parkingEndpoints.deleteItemHandler)
      // Parking Space
      ..post("/$parkingSpaceResource", _parkingSpaceEndpoints.createItemHandler)
      ..get("/$parkingSpaceResource", _parkingSpaceEndpoints.getItemsHandler)
      ..get("/$parkingSpaceResource/<id>",
          _parkingSpaceEndpoints.getItemByIdHandler)
      ..put("/$parkingSpaceResource/<id>",
          _parkingSpaceEndpoints.updateItemHandler)
      ..delete("/$parkingSpaceResource/<id>",
          _parkingSpaceEndpoints.deleteItemHandler);
  }

  late final Router _router;
  late final ServerItemEndpoints<PersonEntity, String> _personEndpoints;
  late final ServerItemEndpoints<VehicleEntity, String> _vehicleEndpoints;
  late final ServerItemEndpoints<ParkingEntity, String> _parkingEndpoints;
  late final ServerItemEndpoints<ParkingSpaceEntity, String>
      _parkingSpaceEndpoints;

  Future<void> run() async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    // Configure a pipeline that logs requests.
    final handler =
        Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

    // For running in containers, we respect the PORT environment variable.
    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(handler, ip, port);
    print('Server listening on port ${server.port}');
  }
}
