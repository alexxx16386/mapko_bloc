import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final LocationRepository _locationRepository;
  final AuthBloc _authBloc;

  HomeBloc({
    required LocationRepository locationRepository,
    required AuthBloc authBloc,
  })  : _locationRepository = locationRepository,
        _authBloc = authBloc,
        super(HomeState.initial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeSetMarker) {
      yield* _mapHomeSetMarkerToState(event);
    } else if (event is HomeChangeMyLocation) {
      yield* _mapHomeChangeMyLocationToState(event);
    } else if (event is HomeLoad) {
      yield* _mapHomeLoadToState(event);
    } else if (event is HomePositionChange) {
      yield* _mapPositionChangeToState(event);
    }
  }

  Stream<HomeState> _mapHomeSetMarkerToState(HomeSetMarker event) async* {
    HomeState newState = state;

    final LatLng location = LatLng(
      event.location.latitude,
      event.location.longitude,
    );
    try {
      final locationInfo = await _locationRepository.getLocationInfo(
        location: location,
      );
      newState = state.copyWith(
        location: locationInfo,
        markerLocation: location,
        status: HomeStatus.setMarker,
      );
      yield newState;
    } catch (err) {
      newState = state.copyWith(
        status: HomeStatus.error,
        failure: Failure(message: err.toString()),
      );
      yield newState;
    }
    yield newState.copyWith(status: HomeStatus.staticS);
  }

  Stream<HomeState> _mapHomeChangeMyLocationToState(
      HomeChangeMyLocation event) async* {
    yield state.copyWith(status: HomeStatus.returnLoc);
    yield state.copyWith(status: HomeStatus.staticS);
  }

  Stream<HomeState> _mapHomeLoadToState(HomeLoad event) async* {
    HomeState newState = state;

    newState = state.copyWith(status: HomeStatus.loading);
    yield newState;

    _locationRepository.setMyLocation(
      position: await Geolocator.getCurrentPosition(),
    );

    try {
      LatLng? location = _locationRepository.getMyLocation;
      final locationInfo = await _locationRepository.getLocationInfo(
        location: location!,
      );
      newState = state.copyWith(
        myLocation: location,
        markerLocation: location,
        status: HomeStatus.currentPositionLoaded,
        location: locationInfo,
      );
      yield newState;
    } catch (err) {
      newState = state.copyWith(
        status: HomeStatus.error,
        failure: Failure(message: err.toString()),
      );
      yield newState;
    }

    yield newState.copyWith(status: HomeStatus.staticS);
  }

  Stream<HomeState> _mapPositionChangeToState(HomePositionChange event) async* {
    HomeState newState = state;

    try {
      final List<Place> places = await _locationRepository.getPlacesByBounds(
        southWest: event.southWest,
        nordEast: event.nordEast,
      );
      newState = state.copyWith(places: places, status: HomeStatus.loaded);
      yield newState;
    } on SocketException {} catch (err) {
      print('error _mapPositionChangeToState');
      newState = state.copyWith(
        status: HomeStatus.error,
        failure: Failure(message: err.toString()),
      );
      yield newState;
    }
    yield newState.copyWith(status: HomeStatus.staticS);
  }

  @override
  Stream<Transition<HomeEvent, HomeState>> transformEvents(
      Stream<HomeEvent> events,
      TransitionFunction<HomeEvent, HomeState> transitionFn) {
    final nonDebounceStream =
        events.where((event) => event is! HomePositionChange);
    final debounceStream = events
        .where((event) => event is HomePositionChange)
        .debounceTime(Duration(milliseconds: 100));
    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }
}
