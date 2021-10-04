part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatJoin extends ChatEvent {}

class ChatInit extends ChatEvent {
  final Chat chat;

  ChatInit({required this.chat});

  @override
  List<Object> get props => [chat];
}

class ChatLoad extends ChatEvent {}

class ChatSendMessage extends ChatEvent {
  final String text;

  ChatSendMessage({
    required this.text,
  });
}
