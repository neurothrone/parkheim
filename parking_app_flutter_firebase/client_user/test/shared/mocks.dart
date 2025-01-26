import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:shared_client_firebase/shared_client_firebase.dart';

class MockAppUserCubit extends Mock implements AppUserCubit {}

class MockRemotePersonRepository extends Mock
    implements FirebasePersonRepository {}

class MockRemoteVehicleRepository extends Mock
    implements FirebaseVehicleRepository {}

class MockRemoteParkingRepository extends Mock
    implements FirebaseParkingRepository {}

class MockRemoteParkingSpaceRepository extends Mock
    implements FirebaseParkingSpaceRepository {}
