class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.role = "user",
  });

  final String id;
  final String? email;
  final String? displayName;
  final String role;

  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
    );
  }
}
