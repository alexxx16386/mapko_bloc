import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mapko_bloc/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    add(AuthEventInitUser());
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
