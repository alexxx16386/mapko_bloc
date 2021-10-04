part of 'chats_bloc.dart';

enum ChatsStatus { initial, loading, loaded, error }

class ChatsState extends Equatable {
  final List<Chat> chats;
  final ChatsStatus status;
  final Failure failure;

  const ChatsState({
    required this.chats,
    required this.status,
    required this.failure,
  });

  @override
  List<Object> get props => [
        chats,
        status,
        failure,
      ];

  factory ChatsState.initial() {
    return ChatsState(
      chats: [],
      status: ChatsStatus.initial,
      failure: Failure(),
    );
  }

  ChatsState copyWith({
    List<Chat>? chats,
    ChatsStatus? status,
    Failure? failure,
  }) {
    return ChatsState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
