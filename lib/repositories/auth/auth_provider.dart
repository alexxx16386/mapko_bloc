import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mapko_bloc/config/configs.dart';
import 'package:http/http.dart' as http;
import 'package:mapko_bloc/models/models.dart';

class AuthProvider {
  Future<String> signUp({
    String? username,
    required String email,
    required String password,
  }) async {
    try {
      Uri uri = Uri.parse("$SERVER_IP/users");
      var body = {
        "email": email,
        "password": password,
      };
      if (username != null) body.addAll({"name": username});
      var response = await http.post(uri, body: body);
      if (response.statusCode == 200) {
        String? token = response.headers['x-auth-token'];
        return token!;
      } else {
        throw response.statusCode;
      }
    } catch (err) {
      throw HttpStatus.conflict;
    }
  }

  Future<String> logIn({
    required String email,
    required String password,
  }) async {
    try {
      Uri uri = Uri.parse("$SERVER_IP/auth");
      var response = await http.post(uri, body: {
        "username": email,
        "password": password,
      });
      if (response.statusCode == 200) {
        String? token = jsonDecode(response.body)['token'];
        return token!;
      } else {
        throw response.statusCode;
      }
    } catch (err) {
      throw HttpStatus.conflict;
    }
  }

  Future<UserModel> getCurrrentUserInfo({required String token}) async {
    Uri uri = Uri.parse("$SERVER_IP/users/me");
    http.Response res = await http.get(uri, headers: {
      "Authorization": token,
    });
    if (res.statusCode == 200) {
      var userInfo = jsonDecode(res.body);
      return UserModel.fromJsonDocument(userInfo['user']);
    } else {
      throw res.statusCode;
    }
  }
}
