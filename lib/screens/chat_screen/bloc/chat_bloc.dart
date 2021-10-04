import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final UserRepository _userRepository;
  late IO.Socket _socket;

  ChatBloc({
    required ChatRepository chatRepository,
    required UserRepository userRepository,
  })  : _chatRepository = chatRepository,
        _userRepository = userRepository,
        super(ChatState.initial()) {
    _socket = IO.io(
      MSG_SERVER_URL,
      IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
          .build(),
    );
    _socket.onConnecting((data) => print('Connecting...'));
    _socket.onConnect((data) => print('Connected!'));
    _socket.onConnectError((data) => print('Connection failed!'));
    _socket.onConnectTimeout((data) => print('Connection timeout'));
    _socket.onDisconnect((data) => print('Disconnected'));
    _socket.onError((data) => print('Socket error'));
    _socket.on('messagesChanged', (data) => print(555));
    _socket.connect();
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatInit) {
      yield* _mapChatInitToState(event);
    } else if (event is ChatLoad) {
      yield* _mapChatLoadToState(event);
    } else if (event is ChatJoin) {
      yield* _mapChatJoinToState(event);
    } else if (event is ChatSendMessage) {
      yield* _mapChatSendMessageToState(event);
    }
  }

  Stream<ChatState> _mapChatInitToState(ChatInit event) async* {
    yield state.copyWith(chat: event.chat);
    add(ChatLoad());
  }

  Stream<ChatState> _mapChatLoadToState(ChatLoad event) async* {
    yield state.copyWith(status: ChatStatus.loading);
    try {
      bool membership = await _chatRepository.checkMyMembership(
        id: state.chat.id,
      );

      List<Message> messages = await _chatRepository.getMessages(
        id: state.chat.id,
      );

      yield state.copyWith(
        status: ChatStatus.loaded,
        messages: messages,
        isMembership: membership,
      );
    } catch (err) {
      yield state.copyWith(
          status: ChatStatus.error, failure: Failure(message: err.toString()));
    }
  }

  Stream<ChatState> _mapChatJoinToState(ChatJoin event) async* {
    try {
      await _chatRepository.joinChat(
        id: state.chat.id,
      );
      add(ChatLoad());
    } catch (err) {
      state.copyWith(
        status: ChatStatus.error,
        failure: Failure(message: err.toString()),
      );
    }
  }

  Stream<ChatState> _mapChatSendMessageToState(ChatSendMessage event) async* {
    try {
      UserModel me = await _userRepository.getCurrrentUserInfo();
      print(me.toString());
      await _chatRepository.sendMessage(
        message: Message(
          text: event.text,
          chatId: state.chat.id,
          user: me,
        ),
      );
      add(ChatInit(chat: state.chat));
    } catch (err) {
      yield state.copyWith(
        status: ChatStatus.error,
        failure: Failure(message: err.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _socket.dispose();
    return super.close();
  }
}
