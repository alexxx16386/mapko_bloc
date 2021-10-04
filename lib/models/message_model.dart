import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:mapko_bloc/models/models.dart';

class Message extends Equatable {
  final String text;
  final String chatId;
  final UserModel user;

  Message({
    required this.text,
    required this.chatId,
    required this.user,
  });

  @override
  List<Object> get props => [
        text,
        chatId,
        user,
      ];

  Message copyWith({
    String? text,
    String? chatId,
    UserModel? user,
  }) {
    return Message(
      text: text ?? this.text,
      chatId: chatId ?? this.chatId,
      user: user ?? this.user,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      chatId: json['chat'],
      user: UserModel(
        id: json['user'][0]['_id'],
        username: json['user'][0]['name'],
        email: json['user'][0]['email'],
      ),
    );
  }
}
