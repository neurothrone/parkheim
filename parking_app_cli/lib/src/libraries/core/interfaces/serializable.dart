import '../models/base_model.dart';

// abstract interface class Serializable<T extends BaseModel> {
// abstract interface class Serializable<T> {
// abstract interface class Serializable {
abstract interface class Serializable {
  Serializable fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
