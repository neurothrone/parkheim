import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../cli/enums/model_type.dart';
import '../../interfaces/repository.dart';
import '../../models/base_model.dart';

const String _baseUrl = "http://localhost:8080";

abstract class BaseRemoteRepository<T extends BaseModel>
    implements Repository<T> {
  BaseRemoteRepository({
    required T Function(Map<String, dynamic>) fromJson,
  }) : _fromJson = fromJson;

  final T Function(Map<String, dynamic>) _fromJson;

  ModelType get modelType;

  @override
  Future<T> create(T item) async {
    final uri = Uri.parse("http://localhost:8080/${modelType.resource()}");
    final http.Response response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );

    // TODO: handle success or error?
    if (response.statusCode != HttpStatus.ok) {
      // TODO: throw
      throw Exception("Failed to create. Error code.");
    }
    try {
      return jsonDecode(response.body) as T;
    } catch (e) {
      throw Exception("Failed to parse");
    }
  }

  @override
  Future<List<T>> getAll() async {
    final Uri url = Uri.parse("$_baseUrl/${modelType.resource()}");
    final response = await http.get(url);

    List<T> items = [];
    if (response.statusCode == HttpStatus.ok) {
      items = _parseItemsJson(response.body);
    }

    return List.unmodifiable(items);
  }

  @override
  Future<T?> getById(String id) async {
    final Uri url = Uri.parse("$_baseUrl/${modelType.resource()}/$id");
    final response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      T item = jsonDecode(response.body) as T;
      return item;
    }

    return null;
  }

  @override
  Future<bool> update(T updatedItem) async {
    final Uri url =
        Uri.parse("$_baseUrl/${modelType.resource()}/${updatedItem.id}");
    final response = await http.put(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(updatedItem.toJson()),
    );

    return response.statusCode == HttpStatus.ok ? true : false;
  }

  @override
  Future<bool> delete(String id) async {
    final Uri url = Uri.parse("$_baseUrl/${modelType.resource()}/$id");
    final response = await http.delete(
      url,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    return response.statusCode == HttpStatus.ok ? true : false;
  }

  List<T> _parseItemsJson(String responseBody) {
    try {
      final List<dynamic> itemsJson = json.decode(responseBody) as List;
      return itemsJson
          .map<T?>((itemJson) {
            try {
              return _fromJson(itemJson as Map<String, dynamic>);
            } catch (e) {
              print("⚠️ -> Error parsing Item: ${e.toString()}");
              return null;
            }
          })
          .whereType<T>() // Filter out any nulls
          .toList();
    } catch (e) {
      print("⚠️ -> Error decoding response: ${e.toString()}");

      return [];
    }
  }
}
