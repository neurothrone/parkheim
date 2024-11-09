import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:shared/shared.dart';

class ServerItemEndpoints<T extends Serializable, E> {
  ServerItemEndpoints({
    required Repository<T, E> repository,
    required T Function(Map<String, dynamic>) fromJson,
  })  : _repository = repository,
        _fromJson = fromJson;

  final Repository<T, E> _repository;
  final T Function(Map<String, dynamic>) _fromJson;

  Future<Response> createItemHandler(Request request) async {
    try {
      final data = await request.readAsString();
      final json = jsonDecode(data) as Map<String, dynamic>;

      final result = await _repository.create(
        _fromJson(json),
      );
      return result.when(
        success: (T createdItem) {
          return Response.ok(
            jsonEncode(createdItem.toJson()),
          );
        },
        failure: (error) {
          return Response.badRequest(body: error);
        },
      );
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  Future<Response> getItemsHandler(Request request) async {
    try {
      final result = await _repository.getAll();
      return result.when(
        success: (List<T> items) {
          return Response.ok(
            jsonEncode(items),
          );
        },
        failure: (error) {
          return Response.badRequest(body: error);
        },
      );
    } catch (e) {
      return Response.internalServerError(body: e.toString());
    }
  }

  Future<Response> getItemByIdHandler(Request request) async {
    final id = _parseIdFromParams(request.params);

    try {
      final result = await _repository.getById(id);
      return result.when(
        success: (T? item) {
          return item == null
              ? Response.notFound(null)
              : Response.ok(
                  jsonEncode(item.toJson()),
                );
        },
        failure: (error) {
          return Response.badRequest(body: error);
        },
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }

  Future<Response> updateItemHandler(Request request) async {
    final id = _parseIdFromParams(request.params);
    if (id == -1) {
      return Response.badRequest(body: "⚠️ -> Invalid ID provided.");
    }

    final result = await _repository.exists(id);
    return result.when(
      success: (bool exists) async {
        if (!exists) {
          return Response.notFound(null);
        }

        try {
          final data = await request.readAsString();
          final json = jsonDecode(data) as Map<String, dynamic>;

          final updateResult = await _repository.update(
            id,
            _fromJson(json),
          );

          return updateResult.when(
            success: (T updatedItem) {
              return Response.ok(
                jsonEncode(updatedItem.toJson()),
              );
            },
            failure: (error) {
              return Response.internalServerError(body: error);
            },
          );
        } catch (e) {
          return Response.internalServerError();
        }
      },
      failure: (error) {
        return Response.internalServerError(body: error);
      },
    );
  }

  Future<Response> deleteItemHandler(Request request) async {
    final id = _parseIdFromParams(request.params);
    if (id == -1) {
      return Response.badRequest(body: "⚠️ -> Invalid ID provided.");
    }

    final result = await _repository.exists(id);
    return result.when(
      success: (bool exists) async {
        if (!exists) {
          return Response.notFound(null);
        }

        try {
          final deleteResult = await _repository.delete(id);
          return deleteResult.when(
            success: (T deletedItem) {
              return Response.ok(
                jsonEncode(deletedItem.toJson()),
              );
            },
            failure: (error) {
              return Response.internalServerError(body: error);
            },
          );
        } catch (e) {
          return Response.internalServerError();
        }
      },
      failure: (error) {
        return Response.internalServerError(body: error);
      },
    );
  }

  int _parseIdFromParams(Map<String, dynamic> map) {
    final stringId = map.containsKey("id") ? map["id"] as String : "";
    final id = int.tryParse(stringId) ?? -1;
    return id;
  }
}
