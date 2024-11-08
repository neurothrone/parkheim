import 'package:uuid/uuid.dart';

import '../interfaces/serializable.dart';

final _uuid = const Uuid();

abstract class BaseModel implements Serializable {
  BaseModel({String? id}) : id = id ?? _uuid.v4();

  final String id;

  bool isValid();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    // Check if both reference the same instance
    if (identical(this, other)) {
      return true;
    }

    return other is BaseModel &&
        runtimeType == other.runtimeType && // Check if same subclass
        id == other.id;
  }
}
