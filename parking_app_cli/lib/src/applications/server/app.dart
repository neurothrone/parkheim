import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'endpoints/item_endpoints.dart';

class App {
  App() {
    _itemEndpoints = ItemEndpoints();

    // Configure routes.
    _router = Router()
      ..get('/', _rootHandler)
      ..get('/echo/<message>', _echoHandler)
      ..post('/items', _itemEndpoints.createItemHandler)
      ..get('/items', _itemEndpoints.getItemsHandler)
      ..get('/items/<id>', _itemEndpoints.getItemByIdHandler)
      ..put('/items/<id>', _itemEndpoints.updateItemHandler)
      ..delete('/items', _itemEndpoints.deleteItemHandler);
  }

  late final Router _router;
  late final ItemEndpoints _itemEndpoints;

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

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }
}
