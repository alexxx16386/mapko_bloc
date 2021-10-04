import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Chat extends Equatable {
  final String id;
  final String name;

  Chat({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        id,
        name,
      ];

  Chat copyWith({
    String? id,
    String? name,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? '',
      name: json['name']['ru'] ?? '',
    );
  }
}
