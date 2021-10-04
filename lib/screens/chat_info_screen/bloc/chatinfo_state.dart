part of 'chatinfo_bloc.dart';

enum ChatInfoStatus { initial, loading, loaded, error }

class ChatInfoState extends Equatable {
  final Chat chat;
  final List<UserModel> members;
  final bool isMembership;
  final ChatInfoStatus status;
  final Failure failure;

  const ChatInfoState({
    required this.chat,
    required this.members,
    required this.isMembership,
    required this.status,
    required this.failure,
  });

  factory ChatInfoState.initial() {
    return ChatInfoState(
      chat: Chat(id: '', name: ''),
      members: [],
      isMembership: false,
      status: ChatInfoStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        status,
        failure,
      ];

  ChatInfoState copyWith({
    Chat? chat,
    List<UserModel>? members,
    bool? isMembership,
    ChatInfoStatus? status,
    Failure? failure,
  }) {
    return ChatInfoState(
      chat: chat ?? this.chat,
      members: members ?? this.members,
      isMembership: isMembership ?? this.isMembership,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
