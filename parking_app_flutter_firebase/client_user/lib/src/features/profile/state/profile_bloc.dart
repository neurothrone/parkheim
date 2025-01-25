import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.appUserCubit,
    required FirebasePersonRepository personRepository,
  })  : _personRepository = personRepository,
        super(ProfileInitial()) {
    on<ProfileLoad>(_onLoad);
  }

  final AppUserCubit appUserCubit;
  final FirebasePersonRepository _personRepository;

  Future<void> loadProfile(
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = (appUserCubit.state as AppUserSignedIn).user;
      final result = await _personRepository.findPersonByName(user.displayName!);
      result.when(
        success: (person) => emit(ProfileLoaded(person: person)),
        failure: (error) => emit(ProfileFailure(message: error)),
      );
    } catch (_) {
      emit(ProfileFailure(message: "Unexpected error"));
    }
  }

  Future<void> _onLoad(
    ProfileLoad event,
    Emitter<ProfileState> emit,
  ) async {
    await loadProfile(emit);
  }
}
