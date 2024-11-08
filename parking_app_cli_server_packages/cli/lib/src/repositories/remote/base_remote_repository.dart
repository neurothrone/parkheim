import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:shared/shared.dart';

abstract class BaseRemoteRepository<T extends Serializable>
    implements Repository<T> {
  BaseRemoteRepository({
    required String resource,
    required T Function(Map<String, dynamic>) fromJson,
    String host = "localhost",
    String port = "8080",
  }) : _fromJson = fromJson {
    _endpoint = "http://$host:$port/$resource";
  }

  late final String _endpoint;
  final T Function(Map<String, dynamic>) _fromJson;

  @override
  Future<T> create(T item) async {
    final uri = Uri.parse(_endpoint);
    final http.Response response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          "⚠️ -> Create failed. Status code: ${response.statusCode}.");
    }
    try {
      final map = jsonDecode(response.body) as Map<String, dynamic>;
      return _fromJson(map);
    } catch (e) {
      throw Exception("⚠️ -> Create failed. Error: $e");
    }
  }

  @override
  Future<List<T>> getAll() async {
    final Uri url = Uri.parse(_endpoint);
    final response = await http.get(url);

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

    return List.unmodifiable(items);
  }

  @override
  Future<T?> getById(int id) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      return _fromJson(json as Map<String, dynamic>);
    }

    return null;
  }

  @override
  Future<T> update(int id, T updatedItem) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.put(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(updatedItem.toJson()),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Failed to create. Error code.");
    }
    try {
      final json = jsonDecode(response.body);
      return _fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to parse");
    }
  }

  @override
  Future<T> delete(int id) async {
    final Uri url = Uri.parse("$_endpoint/$id");
    final response = await http.delete(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Failed to create. Error code.");
    }

    try {
      final json = jsonDecode(response.body);
      return _fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception("Failed to parse");
    }
  }

  @override
  Future<bool> exists(int id) async {
    final item = await getById(id);
    return item != null;
  }

  List<T> _parseItemsJson(String responseBody) {
    try {
      final List<dynamic> itemsJson = json.decode(responseBody) as List;
      return itemsJson
          .map<T?>((itemJson) {
            try {
              return _fromJson(itemJson as Map<String, dynamic>);
            } catch (e) {
              print("⚠️ -> Error parsing Item. Error: ${e.toString()}");
              return null;
            }
          })
          .whereType<T>() // Filter out any nulls
          .toList();
    } catch (e) {
      print("⚠️ -> Error decoding response body. Error: ${e.toString()}");
      return [];
    }
  }
}
