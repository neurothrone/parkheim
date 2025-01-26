import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared/shared.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../core/cubits/app_user/app_user_cubit.dart';
import '../../../core/cubits/app_user/app_user_state.dart';

part 'create_profile_event.dart';

part 'create_profile_state.dart';

class CreateProfileBloc extends Bloc<CreateProfileEvent, CreateProfileState> {
  CreateProfileBloc({
    required this.appUserCubit,
    required FirebasePersonRepository personRepository,
  })  : _personRepository = personRepository,
        super(CreateProfileInitial()) {
    on<CreateProfileSubmit>(_onSubmit);
  }

  final AppUserCubit appUserCubit;
  final FirebasePersonRepository _personRepository;

  Future<void> _onSubmit(
    CreateProfileSubmit event,
    Emitter<CreateProfileState> emit,
  ) async {
    emit(CreateProfileLoading());

    final isAvailable = await _personRepository.isNameAvailable(event.name);
    if (!isAvailable) {
      emit(CreateProfileFailure(message: "Name is already taken"));
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(event.name);

      final result = await _personRepository.create(
        Person(
          id: null,
          name: event.name,
          socialSecurityNumber: event.socialSecurityNumber,
        ),
      );

      result.when(
        success: (Person person) async {
          final user = (appUserCubit.state as AppUserSignedIn).user;
          final updatedUser = user.copyWith(displayName: person.name);
          appUserCubit.updateUser(updatedUser);
          emit(CreateProfileSuccess());
        },
        failure: (String error) => emit(CreateProfileFailure(message: error)),
      );
    } catch (e) {
      emit(CreateProfileFailure(message: e.toString()));
    }
  }
}
