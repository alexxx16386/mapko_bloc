part of 'auth_bloc.dart';

enum AuthStatus { unknown, authorized, unauthorized }

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? token;

  const AuthState({
    required this.status,
    this.user,
    this.token,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.unknown);

  @override
  List<Object> get props => [
        status,
      ];

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }

}
