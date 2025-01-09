part of 'parking_list_bloc.dart';

sealed class ParkingListEvent {
  const ParkingListEvent();
}

final class ParkingListLoadActiveItems extends ParkingListEvent {}

final class ParkingListLoadAllItems extends ParkingListEvent {}

final class ParkingListSearchInitial extends ParkingListEvent {}

final class ParkingListSearchItems extends ParkingListEvent {
  const ParkingListSearchItems({required this.searchText});

  final String searchText;
}
