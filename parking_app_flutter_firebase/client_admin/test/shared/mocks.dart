import 'package:mocktail/mocktail.dart';

import 'package:shared_client_firebase/shared_client_firebase.dart';

class MockRemoteParkingRepository extends Mock
    implements FirebaseParkingRepository {}

class MockRemoteParkingSpaceRepository extends Mock
    implements FirebaseParkingSpaceRepository {}
