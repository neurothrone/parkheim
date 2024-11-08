import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:shared/shared.dart';

class ServerItemEndpoints<T extends Serializable> {
  ServerItemEndpoints({
    required Repository<T> repository,
    required T Function(Map<String, dynamic>) fromJson,
  })  : _repository = repository,
        _fromJson = fromJson;

  final Repository<T> _repository;
  final T Function(Map<String, dynamic>) _fromJson;

  Future<Response> createItemHandler(Request request) async {
    final data = await request.readAsString();

    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final createdItem = await _repository.create(
        _fromJson(json),
      );
      return Response.ok(
        jsonEncode(createdItem.toJson()),
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> getItemsHandler(Request request) async {
    try {
      final items = await _repository.getAll();
      return Response.ok(
        jsonEncode(items),
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> getItemByIdHandler(Request request) async {
    final id = _parseIdFromParams(request.params);

    try {
      final T? item = await _repository.getById(id);
      if (item == null) {
        return Response.notFound(null);
      }

      return Response.ok(
        jsonEncode(item.toJson()),
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> updateItemHandler(Request request) async {
    final id = _parseIdFromParams(request.params);

    if (!await _repository.exists(id)) {
      return Response.notFound(null);
    }

    final data = await request.readAsString();

    try {
      final json = jsonDecode(data) as Map<String, dynamic>;
      final updatedItem = await _repository.update(
        id,
        _fromJson(json),
      );
      return Response.ok(
        jsonEncode(updatedItem.toJson()),
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> deleteItemHandler(Request request) async {
    final id = _parseIdFromParams(request.params);

    if (!await _repository.exists(id)) {
      return Response.notFound(null);
    }

    try {
      final T deletedItem = await _repository.delete(id);
      return Response.ok(
        jsonEncode(deletedItem.toJson()),
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  int _parseIdFromParams(Map<String, dynamic> map) {
    final stringId = map.containsKey("id") ? map["id"] as String : "";
    final id = int.tryParse(stringId) ?? 0;
    return id;
  }
}
