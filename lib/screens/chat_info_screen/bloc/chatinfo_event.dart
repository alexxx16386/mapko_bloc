part of 'chatinfo_bloc.dart';

abstract class ChatInfoEvent extends Equatable {
  const ChatInfoEvent();

  @override
  List<Object> get props => [];
}

class ChatInfoJoin extends ChatInfoEvent {}

class ChatInfoLeave extends ChatInfoEvent {}

class ChatInfoInit extends ChatInfoEvent {
  final Chat chat;

  ChatInfoInit({required this.chat});
  @override
  List<Object> get props => [chat];
}

class ChatInfoLoad extends ChatInfoEvent {}
