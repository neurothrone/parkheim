import 'package:objectbox/objectbox.dart';

import '../../../libraries/core/interfaces/serializable.dart';

@Entity()
class PersonEntity implements Serializable {
  PersonEntity({
    this.id = 0,
    required this.name,
    required this.socialSecurityNumber,
  });

  factory PersonEntity.fromJson(Map<String, dynamic> map) {
    return PersonEntity(
      id: map["id"] as int,
      name: map["name"] as String,
      socialSecurityNumber: map["socialSecurityNumber"] as String,
    );
  }

  @Id()
  int id;
  final String name;
  final String socialSecurityNumber;

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "socialSecurityNumber": socialSecurityNumber,
    };
  }
}
