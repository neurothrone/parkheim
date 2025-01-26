part of 'create_profile_bloc.dart';

sealed class CreateProfileState extends Equatable {
  const CreateProfileState();
}

class CreateProfileInitial extends CreateProfileState {
  @override
  List<Object?> get props => [];
}

class CreateProfileLoading extends CreateProfileState {
  @override
  List<Object?> get props => [];
}

class CreateProfileSuccess extends CreateProfileState {
  @override
  List<Object?> get props => [];
}

class CreateProfileFailure extends CreateProfileState {
  const CreateProfileFailure({
    required this.message,
  });

  final String message;

  @override
  List<Object?> get props => [message];
}
