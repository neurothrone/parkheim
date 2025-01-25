part of 'parking_history_bloc.dart';

sealed class ParkingHistoryEvent {
  const ParkingHistoryEvent();
}

final class ParkingHistoryLoad extends ParkingHistoryEvent {
  const ParkingHistoryLoad();
}
