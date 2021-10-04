import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:http/http.dart' as http;

class LocationProvider {
  late LatLng? _myLocation;

  setMyLocation({required Position position}) {
    _myLocation = LatLng(position.latitude, position.longitude);
  }

  LatLng? get getMyLocation => _myLocation;

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return true;
  }

  Future<City> getLocationInfo({
    required LatLng location,
    required String token,
  }) async {
    Uri uri = Uri.parse(
      "$SERVER_IP/geo/getcity?lat=${location.latitude}&lng=${location.longitude}",
    );
    final http.Response res = await http.get(
      uri,
      headers: {
        "Authorization": token,
      },
    );
    if (res.statusCode == 200) {
      var locationInfo = jsonDecode(res.body);
      if (locationInfo.length > 0) {
        return City.fromJson(locationInfo[0]);
      }
      return City(id: '', name: 'Not found', description: '');
    } else {
      throw res.statusCode;
    }
  }

  Future<List<Place>> getPlacesByBounds({
    required LatLng southWest,
    required LatLng nordEast,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/places/filterbybounds');
    var body = jsonEncode({
      "_swLng": southWest.longitude,
      "_swLat": southWest.latitude,
      "_neLng": nordEast.longitude,
      "_neLat": nordEast.latitude
    });
    http.Response response = await http.post(
      uri,
      headers: {
        "Authorization": token,
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: body,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 200) {
      List items = jsonDecode(response.body);
      List<Place> places = items.map((json) => Place.fromJson(json)).toList();
      return places;
    }
    throw response.statusCode;
  }
}
