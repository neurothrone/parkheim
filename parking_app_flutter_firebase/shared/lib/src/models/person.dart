import '../utils/validation_helper.dart';
import 'base_model.dart';

class Person extends BaseModel {
  Person({
    required super.id,
    required this.name,
    required this.socialSecurityNumber,
    this.email = "",
    this.role = "user",
  });

  factory Person.fromJson(Map<String, dynamic> map) {
    return Person(
      id: map.containsKey("id") ? map["id"] as String : null,
      name: map.containsKey("name") ? map["name"] as String : "",
      socialSecurityNumber: map.containsKey("socialSecurityNumber")
          ? map["socialSecurityNumber"] as String
          : "",
      email: map.containsKey("email") ? map["email"] as String : "",
      role: map.containsKey("role") ? map["role"] as String : "user",
    );
  }

  final String name;
  final String socialSecurityNumber;
  final String email;
  final String role;

  Person copyWith({
    String? id,
    String? name,
    String? socialSecurityNumber,
    String? email,
    String? role,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, name, socialSecurityNumber];

  @override
  String toString() {
    return "Person(name: $name, socialSecurityNumber: $socialSecurityNumber)";
  }

  @override
  bool isValid() {
    return (name.isNotEmpty &&
        socialSecurityNumber.isNotEmpty &&
        ValidationHelper.isValidSwedishSocialSecurityNumber(
          socialSecurityNumber,
        ));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "socialSecurityNumber": socialSecurityNumber,
      "email": email,
      "role": role,
    };
  }
}
