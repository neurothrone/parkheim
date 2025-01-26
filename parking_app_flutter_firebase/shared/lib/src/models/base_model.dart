import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../interfaces/serializable.dart';

abstract class BaseModel extends Equatable implements Serializable {
  BaseModel({String? id}) : id = id ?? Uuid().v4();

  final String id;

  bool isValid();

  @override
  List<Object?> get props => [id];
}
