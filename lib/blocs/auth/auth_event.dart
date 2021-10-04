part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEventLogOut extends AuthEvent {}

class AuthEventLogIn extends AuthEvent {
  final String token;

  const AuthEventLogIn({
    required this.token,
  });
}

class AuthEventInitUser extends AuthEvent {}
