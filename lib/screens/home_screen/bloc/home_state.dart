part of 'home_bloc.dart';

enum HomeStatus {
  initial,
  loading,
  currentPositionLoaded,
  loaded,
  setMarker,
  staticS,
  returnLoc,
  error
}

class HomeState extends Equatable {
  final HomeStatus status;
  final LatLng myLocation;
  final LatLng markerLocation;
  final City location;
  final List<Place> places;
  final Failure failure;

  const HomeState({
    required this.status,
    required this.markerLocation,
    required this.myLocation,
    required this.location,
    required this.places,
    required this.failure,
  });

  factory HomeState.initial() {
    return HomeState(
      status: HomeStatus.initial,
      myLocation: kStartedPosition,
      location: City(id: '', name: '', description: ''),
      markerLocation: kStartedPosition,
      places: [],
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        status,
        failure,
      ];

  HomeState copyWith({
    LatLng? myLocation,
    LatLng? markerLocation,
    City? location,
    Failure? failure,
    HomeStatus? status,
    List<Place>? places,
    StreamController<double>? centerCurrentLocationStreamController,
  }) {
    return HomeState(
      myLocation: myLocation ?? this.myLocation,
      markerLocation: markerLocation ?? this.markerLocation,
      location: location ?? this.location,
      places: places ?? this.places,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
