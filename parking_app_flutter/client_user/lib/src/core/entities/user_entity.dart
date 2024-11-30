class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
  });

  final String id;
  final String? email;
  final String? displayName;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}
