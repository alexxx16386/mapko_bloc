import 'dart:convert';

import 'package:mapko_bloc/config/configs.dart';
import 'package:mapko_bloc/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider {
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
