import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:shared/shared.dart';

abstract class BaseRemoteRepository<T extends Serializable, E>
    implements Repository<T, String> {
  BaseRemoteRepository({
    required String resource,
    required T Function(Map<String, dynamic>) fromJson,
    // String host = "localhost",
    String host = "10.0.2.2", // Android Emulator
    String port = "8080",
  }) : _fromJson = fromJson {
    _endpoint = "http://$host:$port/$resource";
  }

  late final String _endpoint;
  final T Function(Map<String, dynamic>) _fromJson;

  @override
  Future<Result<T, String>> create(T item) async {
    final uri = Uri.parse(_endpoint);
    final http.Response response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      return Result.failure(
          error: "⚠️ -> Create failed. Status code: ${response.statusCode}.");
    }

    try {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      return Result.success(value: _fromJson(map));
    } catch (e) {
      return Result.failure(error: "⚠️ -> Create failed. Error: $e");
    }
  }

  @override
  Future<Result<List<T>, String>> getAll() async {
    final Uri url = Uri.parse(_endpoint);
    final response = await http.get(url);

    try {
      List<T> items = [];

      if (response.statusCode == HttpStatus.ok) {
        // !: Approach 1
        // final json = jsonDecode(response.body);
        // return (json as List)
        //     .map((item) => _fromJson(item as Map<String, dynamic>))
        //     .toList();
        // !: Approach 2
        items = _parseItemsJson(response.body);
      }

      return Result.success(value: List.unmodifiable(items));
    } catch (e) {
      return Result.failure(error: e.toString());
    }
  }

  @override
  Future<Result<T?, String>> getById(int id) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      try {
        final json = jsonDecode(response.body);
        return Result.success(value: _fromJson(json as Map<String, dynamic>));
      } catch (e) {
        return Result.failure(error: e.toString());
      }
    }

    return Result.success(value: null);
  }

  @override
  Future<Result<T, String>> update(int id, T updatedItem) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.put(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(updatedItem.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      return Result.failure(
          error: "⚠️ -> Update failed. Status code: ${response.statusCode}");
    }

    try {
      final json = jsonDecode(response.body);
      return Result.success(value: _fromJson(json as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(
          error: "⚠️ -> Update failed. Unable to parse response, error: $e");
    }
  }

  @override
  Future<Result<T, String>> delete(int id) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.delete(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      return Result.failure(
          error: "⚠️ -> Delete failed. Status code: ${response.statusCode}");
    }

    try {
      final json = jsonDecode(response.body);
      return Result.success(value: _fromJson(json as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(
          error: "⚠️ -> Delete failed. Unable to parse response, error: $e");
    }
  }

  @override
  Future<Result<bool, String>> exists(int id) async {
    final result = await getById(id);
    return result.when(
      success: (T? item) {
        return Result.success(value: item != null);
      },
      failure: (error) => Result.failure(error: error),
    );
  }

  List<T> _parseItemsJson(String responseBody) {
    try {
      final List<dynamic> itemsJson = json.decode(responseBody) as List;
      return itemsJson
          .map<T?>((itemJson) {
            try {
              return _fromJson(itemJson as Map<String, dynamic>);
            } catch (e) {
              // print("⚠️ -> Error parsing Item. Error: ${e.toString()}");
              return null;
            }
          })
          .whereType<T>() // Filter out any nulls
          .toList();
    } catch (e) {
      // print("⚠️ -> Error decoding response body. Error: ${e.toString()}");
      return [];
    }
  }
}
