import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong/latlong.dart';
import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/screens/home_screen/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Map extends StatelessWidget {
  const Map({
    required StreamController<double> centerCurrentLocationStreamController,
    required MapController mapController,
    required List<Place> places,
    required LatLng markerLocation,
  })  : _centerCurrentLocationStreamController =
            centerCurrentLocationStreamController,
        _mapController = mapController,
        _places = places,
        _markerLocation = markerLocation;

  final StreamController<double> _centerCurrentLocationStreamController;
  final MapController _mapController;
  final List<Place> _places;
  final LatLng _markerLocation;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      children: [
        LocationMarkerLayerWidget(
          plugin: LocationMarkerPlugin(
            centerCurrentLocationStream:
                _centerCurrentLocationStreamController.stream,
            centerOnLocationUpdate: CenterOnLocationUpdate.first,
          ),
        ),
      ],
      mapController: _mapController,
      options: MapOptions(
        plugins: [
          LocationMarkerPlugin(), // <-- add plugin here
        ],
        center: _markerLocation,
        zoom: 13.0,
        onPositionChanged: (position, _) {
          context.read<HomeBloc>().add(
                HomePositionChange(
                  nordEast: position.bounds.northEast,
                  southWest: position.bounds.southWest,
                ),
              );
        },
        onLongPress: (location) async {
          context.read<HomeBloc>().add(
                HomeSetMarker(
                  location: location,
                ),
              );
        },
      ),
      layers: [
        kOptions,
        LocationMarkerLayerOptions(),
        MarkerLayerOptions(
          markers: _places
              .map(
                (place) => Marker(
                  point: place.location,
                  builder: (ctx) => Container(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (builder) => Column(
                            children: [
                              ListTile(
                                title: Text(place.name),
                                subtitle: Text(place.description),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
