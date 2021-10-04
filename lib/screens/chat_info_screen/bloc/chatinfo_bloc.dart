import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mapko_bloc/models/models.dart';
import 'package:mapko_bloc/repositories/repositories.dart';

part 'chatinfo_event.dart';
part 'chatinfo_state.dart';

class ChatInfoBloc extends Bloc<ChatInfoEvent, ChatInfoState> {
  final ChatRepository _chatRepository;

  ChatInfoBloc({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(ChatInfoState.initial());

  @override
  Stream<ChatInfoState> mapEventToState(
    ChatInfoEvent event,
  ) async* {
    if (event is ChatInfoInit) {
      yield* _mapChatInfoInitToState(event);
    } else if (event is ChatInfoLoad) {
      yield* _mapChatInfoLoadToState(event);
    } else if (event is ChatInfoJoin) {
      yield* _mapChatInfoJoinToState(event);
    } else if (event is ChatInfoLeave) {
      yield* _mapChatInfoLeaveToState(event);
    }
  }

  Stream<ChatInfoState> _mapChatInfoInitToState(ChatInfoInit event) async* {
    yield state.copyWith(chat: event.chat);
    add(ChatInfoLoad());
  }

  Stream<ChatInfoState> _mapChatInfoLoadToState(ChatInfoLoad event) async* {
    yield state.copyWith(status: ChatInfoStatus.loading);
    try {
      bool isMembership = await _chatRepository.checkMyMembership(
        id: state.chat.id,
      );

      List<UserModel> members = await _chatRepository.getMembers(
        id: state.chat.id,
      );
      yield state.copyWith(
        isMembership: isMembership,
        members: members,
        status: ChatInfoStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: ChatInfoStatus.error,
        failure: Failure(message: err.toString()),
      );
    }
  }

  Stream<ChatInfoState> _mapChatInfoJoinToState(ChatInfoJoin event) async* {
    try {
      await _chatRepository.joinChat(
        id: state.chat.id,
      );
      add(ChatInfoLoad());
    } catch (err) {
      state.copyWith(
        status: ChatInfoStatus.error,
        failure: Failure(message: err.toString()),
      );
    }
  }

  Stream<ChatInfoState> _mapChatInfoLeaveToState(ChatInfoLeave event) async* {
    try {
      await _chatRepository.leaveChat(
        id: state.chat.id,
      );
      add(ChatInfoLoad());
    } catch (err) {
      state.copyWith(
        status: ChatInfoStatus.error,
        failure: Failure(message: err.toString()),
      );
    }
  }
}
