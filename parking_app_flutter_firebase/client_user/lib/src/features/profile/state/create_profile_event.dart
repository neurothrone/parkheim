part of 'create_profile_bloc.dart';

sealed class CreateProfileEvent {
  const CreateProfileEvent();
}

final class CreateProfileSubmit extends CreateProfileEvent {
  const CreateProfileSubmit({
    required this.name,
    required this.socialSecurityNumber,
  });

  final String name;
  final String socialSecurityNumber;
}
