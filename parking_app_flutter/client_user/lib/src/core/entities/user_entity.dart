class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
  });

  final String id;
  final String? email;
  final String? displayName;
}
