import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';

class Place extends Equatable {
  final String id;
  final LatLng location;
  final List images;
  final String name;
  final String description;
  final String cityId;
  final String userId;

  Place({
    required this.id,
    required this.location,
    required this.images,
    required this.name,
    required this.description,
    required this.cityId,
    required this.userId,
  });

  @override
  List<Object> get props => [
        id,
        location,
        images,
        name,
        description,
        cityId,
        userId,
      ];

  Place copyWith({
    String? id,
    LatLng? location,
    List? images,
    String? name,
    String? description,
    String? cityId,
    String? userId,
  }) {
    return Place(
      id: id ?? this.id,
      location: location ?? this.location,
      images: images ?? this.images,
      name: name ?? this.name,
      description: description ?? this.description,
      cityId: cityId ?? this.cityId,
      userId: userId ?? this.userId,
    );
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'],
      location: LatLng(json['location']['coordinates'][1],
          json['location']['coordinates'][0]),
      images: json['image'],
      name: json['name']['uk'],
      description: json['description']['uk'],
      cityId: json['city'],
      userId: json['user'],
    );
  }
}
