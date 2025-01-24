part of 'space_history_bloc.dart';

sealed class SpaceHistoryEvent {
  const SpaceHistoryEvent();
}

class SpaceHistoryLoad extends SpaceHistoryEvent {
  const SpaceHistoryLoad({required this.space});

  final ParkingSpace space;
}
