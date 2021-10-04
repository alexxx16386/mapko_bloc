part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final List<Message> messages;
  final bool isMembership;
  final Chat chat;
  final ChatStatus status;
  final Failure failure;

  const ChatState({
    required this.messages,
    required this.isMembership,
    required this.chat,
    required this.status,
    required this.failure,
  });

  factory ChatState.initial() {
    return ChatState(
      messages: [],
      isMembership: true,
      chat: Chat(id: '', name: 'lol'),
      status: ChatStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        status,
        failure,
      ];

  ChatState copyWith({
    List<Message>? messages,
    bool? isMembership,
    Chat? chat,
    ChatStatus? status,
    Failure? failure,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isMembership: isMembership ?? this.isMembership,
      chat: chat ?? this.chat,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
