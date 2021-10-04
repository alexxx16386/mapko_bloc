part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoad extends HomeEvent {}

class HomeSetMarker extends HomeEvent {
  final LatLng location;

  HomeSetMarker({
    required this.location,
  });

  @override
  List<Object> get props => [location];
}

class HomeChangeMyLocation extends HomeEvent {}

class HomePositionChange extends HomeEvent {
  final LatLng southWest;
  final LatLng nordEast;

  HomePositionChange({
    required this.southWest,
    required this.nordEast,
  });

  @override
  List<Object> get props => [southWest, nordEast];
}
