import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mapko_bloc/constants.dart';
import 'package:mapko_bloc/models/user_model.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/repositories/storage/storage_repository.dart';
import 'package:mapko_bloc/repositories/token/token_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenRepository _tokenRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;

  AuthBloc({
    required TokenRepository tokenRepository,
    required StorageRepository storageRepository,
    required AuthRepository authRepository,
  })  : _tokenRepository = tokenRepository,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
        super(AuthState.initial()) {
    add(AuthEventInitUser());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthEventInitUser) {
      yield* _mapEToSInitUser(event);
    } else if (event is AuthEventLoadUser) {
      yield* _mapEToSLoadUser(event);
    } else if (event is AuthEventLogOut) {
      yield* _mapEToSLogOut(event);
    } else if (event is AuthEventLogIn) {
      yield* _mapEToSLogIn(event);
    }
  }

  Stream<AuthState> _mapEToSInitUser(AuthEventInitUser event) async* {
    final String? token = await _tokenRepository.getToken();
    if (token != null) {
      final String? userData = await _storageRepository.getItem(AUTH_USER);
      if (userData != null) {
        final UserModel user = UserModel.fromJson(userData);
        yield state.copyWith(
          status: AuthStatus.authorized,
          token: token,
          user: user,
        );
      }
    } else {
      yield state.copyWith(status: AuthStatus.unauthorized);
    }
  }

  Stream<AuthState> _mapEToSLoadUser(AuthEventLoadUser event) async* {
    final String? token = await _tokenRepository.getToken();
    if (token != null) {
      final UserModel user = await _authRepository.getCurrrentUserInfo(token);
      yield state.copyWith(user: user);
    } else {
      yield state.copyWith(status: AuthStatus.unauthorized);
    }
  }

  Stream<AuthState> _mapEToSLogOut(AuthEventLogOut event) async* {
    await _tokenRepository.deleteToken();
    await _storageRepository.clear();
    yield AuthState.initial();
  }

  Stream<AuthState> _mapEToSLogIn(AuthEventLogIn event) async* {
    await _tokenRepository.persistToken(event.token);
    yield state.copyWith(status: AuthStatus.authorized, token: event.token);
    add(AuthEventLoadUser());
  }
}
