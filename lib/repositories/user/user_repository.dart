import 'package:mapko_bloc/blocs/auth/auth_bloc.dart';
import 'package:mapko_bloc/repositories/user/user_provider.dart';
import 'package:mapko_bloc/models/user_model.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();
  final AuthBloc _authBloc;

  UserRepository({
    required AuthBloc authBloc,
  }) : _authBloc = authBloc;

  Future<UserModel> getCurrrentUserInfo() async {
    return _userProvider.getCurrrentUserInfo(
      token: _authBloc.state.token!,
    );
  }
}
