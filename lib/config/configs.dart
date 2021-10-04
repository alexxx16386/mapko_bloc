import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

const SERVER_IP = 'https://dev.mapko.net/api';
const MSG_SERVER_URL = 'https://ws.mapko.net';
LatLng kStartedPosition = LatLng(55.449623, 34.502302);
TileLayerOptions kOptions = TileLayerOptions(
  urlTemplate:
      "https://api.mapbox.com/styles/v1/alexxx16386/cklgq5svj5hsi17t53eg921sr/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxleHh4MTYzODYiLCJhIjoiY2tsZ2dibGl6MDlrMTJxbjJuaXdkaXlkbCJ9.X15AUBlMhPDwxlRiZx6u7Q",
  additionalOptions: {
    'accessToken':
        'pk.eyJ1IjoiYWxleHh4MTYzODYiLCJhIjoiY2tsZ2dibGl6MDlrMTJxbjJuaXdkaXlkbCJ9.X15AUBlMhPDwxlRiZx6u7Q',
    'id': 'mapbox.mapbox-streets-v7'
  },
);
