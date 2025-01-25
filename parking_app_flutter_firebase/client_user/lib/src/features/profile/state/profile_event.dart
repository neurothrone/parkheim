part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileLoad extends ProfileEvent {
  const ProfileLoad();
}
