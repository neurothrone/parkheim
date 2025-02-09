import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

import '../../../firebase_options.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../domain/interfaces/auth_repository.dart';
import '../../domain/use_cases/auth.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/parkings/state/active_parkings/active_parkings_bloc.dart';
import '../../features/parkings/state/available_spaces/available_spaces_bloc.dart';
import '../../features/parkings/state/parking_history/parking_history_bloc.dart';
import '../../features/profile/state/create_profile_bloc.dart';
import '../../features/profile/state/profile_bloc.dart';
import '../../features/settings/state/dark_mode_cubit.dart';
import '../../features/vehicles/state/vehicle_list_bloc.dart';
import '../cubits/app_user/app_user_cubit.dart';
import '../cubits/navigation/bottom_navigation_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (kDebugMode) {
  //   await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  // }

  // !: Firebase
  serviceLocator.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  // !: App User
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // !: Bottom Navigation
  serviceLocator.registerLazySingleton(() => BottomNavigationCubit());

  // !: Dark Mode Cubit
  serviceLocator.registerLazySingleton(() => DarkModeCubit());

  // !: Auth
  serviceLocator
    // !: Repositories
    ..registerFactory<AuthRepository>(
      () => FirebaseAuthRepository(firebaseAuth: serviceLocator()),
    )
    // !: Use Cases
    ..registerFactory(
      () => CurrentUserUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignOutUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignUpUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UserSignInUseCase(authRepository: serviceLocator()),
    )
    // !: Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        currentUserUseCase: serviceLocator(),
        userSignOutUseCase: serviceLocator(),
        userSignUpUseCase: serviceLocator(),
        userSignInUseCase: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );

  // !: Remote Repositories
  serviceLocator
    ..registerLazySingleton(() => FirebasePersonRepository())
    ..registerLazySingleton(() => FirebaseVehicleRepository())
    ..registerLazySingleton(
        () => FirebaseParkingRepository(vehicleRepository: serviceLocator()))
    ..registerLazySingleton(() =>
        FirebaseParkingSpaceRepository(parkingRepository: serviceLocator()));

  // !: Profile
  serviceLocator
    ..registerLazySingleton(
      () => CreateProfileBloc(
        appUserCubit: serviceLocator(),
        personRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ProfileBloc(
        appUserCubit: serviceLocator(),
        personRepository: serviceLocator(),
      ),
    );

  // !: Parking
  serviceLocator.registerLazySingleton(() => NotificationRepository());

  serviceLocator
    ..registerLazySingleton(
      () => ActiveParkingsBloc(
        appUserCubit: serviceLocator(),
        personRepository: serviceLocator(),
        parkingRepository: serviceLocator(),
        notificationRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AvailableSpacesBloc(
        parkingSpaceRepository: serviceLocator(),
        parkingRepository: serviceLocator(),
        notificationRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ParkingHistoryBloc(
        appUserCubit: serviceLocator(),
        parkingRepository: serviceLocator(),
        personRepository: serviceLocator(),
      ),
    );

  // !: Vehicles
  serviceLocator.registerLazySingleton(
    () => VehicleListBloc(
      appUserCubit: serviceLocator(),
      personRepository: serviceLocator(),
      vehicleRepository: serviceLocator(),
    ),
  );
}
