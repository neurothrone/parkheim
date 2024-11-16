import '../interfaces/serializable.dart';

abstract class BaseModel implements Serializable {
  BaseModel({required this.id});

  final int id;

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
