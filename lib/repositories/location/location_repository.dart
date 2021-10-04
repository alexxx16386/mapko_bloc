import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';

import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/location/location_provider.dart';

class LocationRepository {
  final LocationProvider _locationProvider = LocationProvider();
  final AuthBloc _authBloc;

  LocationRepository({
    required AuthBloc authBloc,
  }) : _authBloc = authBloc;

  setMyLocation({required Position position}) {
    _locationProvider.setMyLocation(position: position);
  }

  LatLng? get getMyLocation => _locationProvider.getMyLocation;

  Future<Position> getCurrentLocation() async {
    return _locationProvider.getCurrentLocation();
  }

  Future<City> getLocationInfo({
    required LatLng location,
  }) async {
    return _locationProvider.getLocationInfo(
      location: location,
      token: _authBloc.state.token!,
    );
  }

  Future<List<Place>> getPlacesByBounds({
    required LatLng southWest,
    required LatLng nordEast,
  }) async {
    return _locationProvider.getPlacesByBounds(
      southWest: southWest,
      nordEast: nordEast,
      token: _authBloc.state.token!,
    );
  }
}
