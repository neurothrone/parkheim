import 'dart:convert';

import 'package:shelf/shelf.dart';

class ItemEndpoints {
  Future<Response> createItemHandler(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    print(json);

    return Response.ok(null);
  }

  Future<Response> getItemsHandler(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    print(json);

    return Response.ok(null);
  }

  Future<Response> getItemByIdHandler(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    print(json);

    return Response.ok(null);
  }

  Future<Response> updateItemHandler(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    print(json);

    return Response.ok(null);
  }

  Future<Response> deleteItemHandler(Request request) async {
    final data = await request.readAsString();
    final json = jsonDecode(data);

    print(json);

    return Response.ok(null);
  }
}
