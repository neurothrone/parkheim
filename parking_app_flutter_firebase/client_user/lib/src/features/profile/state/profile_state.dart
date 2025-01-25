part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.person,
  });

  final Person person;

  @override
  List<Object?> get props => [person];
}

class ProfileFailure extends ProfileState {
  const ProfileFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
