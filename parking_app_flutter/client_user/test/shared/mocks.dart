import 'package:mocktail/mocktail.dart';

import 'package:client_user/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:shared_client/shared_client.dart';

class MockAppUserCubit extends Mock implements AppUserCubit {}

class MockRemotePersonRepository extends Mock
    implements RemotePersonRepository {}

class MockRemoteVehicleRepository extends Mock
    implements RemoteVehicleRepository {}

class MockRemoteParkingRepository extends Mock
    implements RemoteParkingRepository {}

class MockRemoteParkingSpaceRepository extends Mock
    implements RemoteParkingSpaceRepository {}
