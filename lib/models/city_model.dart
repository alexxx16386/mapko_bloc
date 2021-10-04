import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class City extends Equatable {
  final String id;
  final String name;
  final String description;

  City({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object> get props => [id, name, description];

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'] ?? '',
      name: json['name']['ru'] ?? '',
      description: json['description']['ru'] ?? '',
    );
  }
}
