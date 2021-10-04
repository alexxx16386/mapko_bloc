import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
  });

  static UserModel empty = UserModel(
    id: '',
    username: '',
    email: '',
  );

  @override
  List<Object> get props => [
        id,
        username,
        email,
      ];

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? following,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  factory UserModel.fromJsonDocument(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['_id'] ?? '',
        username: json['name'] ?? '',
        email: json['email'] ?? '',
      );
    } catch (err) {
      throw Exception();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
