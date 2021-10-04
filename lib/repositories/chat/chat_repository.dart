import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/repositories/chat/chat_provider.dart';
import 'package:mapko_bloc/models/chat_model.dart';
import 'package:mapko_bloc/models/message_model.dart';
import 'package:mapko_bloc/models/user_model.dart';

class ChatRepository {
  final ChatProvider _chatProvider = ChatProvider();
  final AuthBloc _authBloc;

  ChatRepository({
    required AuthBloc authBloc,
  }) : _authBloc = authBloc;

  Future<List<Chat>> getChatsByCityId({
    required String id,
  }) async {
    return _chatProvider.getChatsByCityId(
      id: id,
      token: _authBloc.state.token!,
    );
  }

  Future sendMessage({
    required Message message,
  }) async {
    await _chatProvider.sendMessage(
      message: message,
      token: _authBloc.state.token!,
    );
  }

  Future<bool> checkMyMembership({
    required String id,
  }) async {
    return _chatProvider.checkMyMembership(
      id: id,
      token: _authBloc.state.token!,
    );
  }

  Future<List<Message>> getMessages({
    required String id,
  }) async {
    return _chatProvider.getMessages(
      id: id,
      token: _authBloc.state.token!,
    );
  }

  Future<bool> joinChat({
    required String id,
  }) async {
    return _chatProvider.joinChat(
      id: id,
      token: _authBloc.state.token!,
    );
  }

  Future<List<UserModel>> getMembers({
    required String id,
  }) async {
    return _chatProvider.getMembers(
      id: id,
      token: _authBloc.state.token!,
    );
  }

  Future<bool> leaveChat({
    required String id,
  }) async {
    return _chatProvider.leaveChat(
      id: id,
      token: _authBloc.state.token!,
    );
  }
}
