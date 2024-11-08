import '../interfaces/serializable.dart';
import '../utils/validation_helper.dart';
import 'base_model.dart';

class Person extends BaseModel {
  Person({
    super.id,
    required this.name,
    required this.socialSecurityNumber,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json.containsKey("id") ? json["id"] as String : "",
      name: json.containsKey("name") ? json["name"] as String : "",
      socialSecurityNumber: json.containsKey("socialSecurityNumber")
          ? json["socialSecurityNumber"] as String
          : "",
    );
  }

  final String name;
  final String socialSecurityNumber;

  Person copyWith({
    String? id,
    String? name,
    String? socialSecurityNumber,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
    );
  }

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

  // region Serializable

  @override
  Serializable fromJson(Map<String, dynamic> json) {
    return Person(
      id: json.containsKey("id") ? json["id"] as String : "",
      name: json.containsKey("name") ? json["name"] as String : "",
      socialSecurityNumber: json.containsKey("socialSecurityNumber")
          ? json["socialSecurityNumber"] as String
          : "",
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "socialSecurityNumber": socialSecurityNumber,
    };
  }

// endregion
}
