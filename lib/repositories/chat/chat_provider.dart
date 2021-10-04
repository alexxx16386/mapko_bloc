import 'dart:convert';

import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/chat_model.dart';
import 'package:mapko_bloc/models/message_model.dart';
import 'package:mapko_bloc/models/user_model.dart';

import 'package:http/http.dart' as http;

class ChatProvider {
  Future<List<Chat>> getChatsByCityId({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse("$SERVER_IP/chats/bylocation/$id");
    http.Response response =
        await http.get(uri, headers: {"Authorization": token});
    if (response.statusCode == 200) {
      List chats = jsonDecode(response.body)['items'];
      return chats.map((json) => Chat.fromJson(json)).toList();
    }
    throw response.statusCode;
  }

  Future sendMessage({
    required Message message,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/msg');
    await http.post(uri, headers: {
      "Authorization": token,
    }, body: {
      "text": message.text,
      "chat": message.chatId,
      "user": message.user.id,
    });
    return;
  }

  Future<bool> checkMyMembership({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/mymembership/$id');
    http.Response response = await http.get(uri, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res.length >= 1) {
        return res[0]['status']['code'] == 100;
      } else {
        return false;
      }
    } else {
      throw response.statusCode;
    }
  }

  Future<List<Message>> getMessages({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/msgs/$id?index=1&pageSize=100');
    http.Response response = await http.get(uri, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      List items = jsonDecode(response.body);
      List<Message> messages =
          items.map((json) => Message.fromJson(json)).toList();
      return messages;
    } else {
      throw response.statusCode;
    }
  }

  Future<bool> joinChat({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/joinrequest/$id');
    http.Response response = await http.post(uri, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isChatJoined'];
    }
    throw response.statusCode;
  }

  Future<List<UserModel>> getMembers({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/members/$id');
    http.Response response = await http.get(uri, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      List items = jsonDecode(response.body);
      return items
          .map((json) => UserModel.fromJsonDocument(json['user']))
          .toList();
    }
    throw response.statusCode;
  }

  Future<bool> leaveChat({
    required String id,
    required String token,
  }) async {
    Uri uri = Uri.parse('$SERVER_IP/chats/leavechat/$id');
    http.Response response = await http.post(uri, headers: {
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      if (res['chat'].isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
